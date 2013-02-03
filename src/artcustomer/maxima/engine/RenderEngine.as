/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine {
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.system.System;
	
	import artcustomer.maxima.context.*;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.events.RenderEngineEvent;
	import artcustomer.maxima.utils.consts.RenderEngineState;
	
	[Event(name = "onRender", type = "artcustomer.maxima.events.RenderEngineEvent")]
	[Event(name = "startRender", type = "artcustomer.maxima.events.RenderEngineEvent")]
	[Event(name = "stopRender", type = "artcustomer.maxima.events.RenderEngineEvent")]
	[Event(name = "heartBeat", type = "artcustomer.maxima.events.RenderEngineEvent")]
	
	
	/**
	 * RenderEngine : Rendering in real time with EnterFrame.
	 * 
	 * @author David Massenot
	 */
	public class RenderEngine extends AbstractCoreEngine {
		private static var __instance:RenderEngine;
		private static var __allowInstantiation:Boolean;
		
		private const MEMORY:Number = 0.000000954;
		
		private var _heartbeatFunction:Function;
		
		private var _nextHeartbeatTime:uint = 0;
		private var _heartbeatIntervalMs:uint = 0;
		
		private var _startTime:Number = 0;
		private var _elapsedTime:Number = 0;
		private var _lastFrameTime:Number = 0;
		private var _currentFrameTime:Number = 0;
		private var _frameMs:Number = 0;
		private var _frameCount:uint = 0;
		
		private var _timeDelay:Number = 0;
		
		private var _fps:Number = 0;
		private var _fpsTicks:Number = 0;
		private var _fpsLast:Number = 0;
		private var _memory:Number = 0;
		private var _freeMemory:Number = 0;
		private var _privateMemory:Number = 0;
		private var _totalMemory:Number = 0;
		
		private var _state:String;
		
		private var _isConstruct:Boolean;
		private var _onRendering:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function RenderEngine() {
			super();
			
			if (!__allowInstantiation) {
				throw new GameError(GameError.E_RENDERENGINE_CREATE);
				
				return;
			}
		}
		
		//---------------------------------------------------------------------
		//  Private points
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function constructor():void {
			init();
			
			_isConstruct = true;
		}
		
		/**
		 * @private
		 */
		private function destructor():void {
			unlistenEnterFrame();
			
			_isConstruct = false;
		}
		
		//---------------------------------------------------------------------
		//  Initialize
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function init():void {
			_state = RenderEngineState.RENDERENGINE_OFF;
			_timeDelay = 1000;
			_heartbeatIntervalMs = 1000;
			_onRendering = false;
		}
		
		//---------------------------------------------------------------------
		//  EnterFrame
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function listenEnterFrame():void {
			this.context.contextView.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function unlistenEnterFrame():void {
			if (this.context.contextView.hasEventListener(Event.ENTER_FRAME)) this.context.contextView.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleEnterFrame(e:Event):void {
			tick();
			updateFPS();
			updateMemory();
			updateFreeMemory();
			updatePrivateMemory();
			updateTotalMemory();
			
			if (this.context.instance.gameEngine.currentEngineObject) _injector.renderObject(this.context.instance.gameEngine.currentEngineObject);
			
			dispatchRenderEngineEvent(RenderEngineEvent.ON_RENDER);
		}
		
		//---------------------------------------------------------------------
		//  Tick
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function tick():void {
			_currentFrameTime = getTimer();
			
			if (_frameCount == 0) {
				_startTime = _currentFrameTime;
				_elapsedTime = 0;
				_frameMs = 0;
			} else {
				_frameMs = _currentFrameTime - _lastFrameTime;
				_elapsedTime += _frameMs;
			}
			
			if (_currentFrameTime >= _nextHeartbeatTime) {
				if (_heartbeatFunction != null) _heartbeatFunction();
				
				_nextHeartbeatTime = _currentFrameTime + _heartbeatIntervalMs;
				
				dispatchRenderEngineEvent(RenderEngineEvent.HEARTBEAT);
			}
			
			_lastFrameTime = _currentFrameTime;
			_frameCount++;
		}
		
		/**
		 * @private
		 */
		private function updateFPS():void {
			var nowTime:uint = getTimer();
			var delta:uint = nowTime - _fpsLast;
			
			_fpsTicks++;
			
			if (delta >= _timeDelay) {
				_fps = _fpsTicks / delta * _timeDelay;
				_fpsTicks = 0;
				_fpsLast = nowTime;
			}
		}
		
		/**
		 * @private
		 */
		private function updateMemory():void {
			_memory = Number((System.totalMemory * MEMORY).toFixed(4));
		}
		
		/**
		 * @private
		 */
		private function updateFreeMemory():void {
			_freeMemory = System.freeMemory;
		}
		
		/**
		 * @private
		 */
		private function updatePrivateMemory():void {
			_privateMemory = System.privateMemory;
		}
		
		/**
		 * @private
		 */
		private function updateTotalMemory():void {
			_totalMemory = System.totalMemoryNumber;
		}
		
		//---------------------------------------------------------------------
		//  Event Dispatching
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function dispatchRenderEngineEvent(type:String):void {
			this.dispatchEvent(new RenderEngineEvent(type, false, false, _fps, _memory, _freeMemory, _privateMemory, _totalMemory));
		}
		
		
		/**
		 * Setup RenderEngine.
		 */
		override internal function setup():void {
			if (this.isSetup) return;
			if (_isConstruct) return;
			
			super.setup();
			
			constructor();
		}
		
		/**
		 * Destroy RenderEngine.
		 */
		override internal function destroy():void {
			destructor();
			
			_heartbeatFunction = null;
			_nextHeartbeatTime = 0;
			_heartbeatIntervalMs = 0;
			_state = null;
			_startTime = 0;
			_elapsedTime = 0;
			_lastFrameTime = 0;
			_currentFrameTime = 0;
			_frameMs = 0;
			_frameCount = 0;
			_timeDelay = 0;
			_fps = 0;
			_fpsTicks = 0;
			_fpsLast = 0;
			_memory = 0;
			_freeMemory = 0;
			_privateMemory = 0;
			_totalMemory = 0;
			_onRendering = false;
			_isConstruct = false;
			
			__instance = null;
			
			super.destroy();
		}
		
		/**
		 * Start RenderEngine.
		 */
		public function start():void {
			if (!_onRendering) {				
				listenEnterFrame();
				dispatchRenderEngineEvent(RenderEngineEvent.START_RENDER);
				
				_state = RenderEngineState.RENDERENGINE_ON;
				_onRendering = true;
			}
		}
		
		/**
		 * Stop RenderEngine.
		 */
		public function stop():void {
			if (_onRendering) {
				unlistenEnterFrame();
				dispatchRenderEngineEvent(RenderEngineEvent.STOP_RENDER);
				
				_state = RenderEngineState.RENDERENGINE_OFF;
				_onRendering = false;
			}
		}
		
		
		/**
		 * Instantiate RenderEngine.
		 */
		public static function getInstance():RenderEngine {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new RenderEngine();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
		
		
		/**
		 * @private
		 */
		public function set heartbeatFunction(value:Function):void {
			_heartbeatFunction = value;
		}
		
		/**
		 * @private
		 */
		public function get startTime():Number {
			return _startTime;
		}
		
		/**
		 * @private
		 */
		public function get currentFrameTime():Number {
			return _currentFrameTime;
		}
		
		/**
		 * @private
		 */
		public function get elapsedTime():Number {
			return _elapsedTime;
		}
		
		/**
		 * @private
		 */
		public function get frameMs():Number {
			return _frameMs;
		}
		
		/**
		 * @private
		 */
		public function get frameCount():uint {
			return _frameCount;
		}
		
		/**
		 * @private
		 */
		public function get fps():Number {
			return _fps;
		}
		
		/**
		 * @private
		 */
		public function get memory():Number {
			return _memory;
		}
		
		/**
		 * @private
		 */
		public function get freeMemory():Number {
			return _freeMemory;
		}
		
		/**
		 * @private
		 */
		public function get privateMemory():Number {
			return _privateMemory;
		}
		
		/**
		 * @private
		 */
		public function get totalMemory():Number {
			return _totalMemory;
		}
		
		/**
		 * @private
		 */
		public function get onRendering():Boolean {
			return _onRendering;
		}
		
		/**
		 * @private
		 */
		public function get state():String {
			return _state;
		}
	}
}