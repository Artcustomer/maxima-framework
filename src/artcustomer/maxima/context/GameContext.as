/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.context {
	import flash.display.DisplayObjectContainer;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.events.*;
	import artcustomer.maxima.engine.*;
	import artcustomer.maxima.proxies.*;
	import artcustomer.maxima.utils.consts.*;
	
	[Event(name = "gameSetup", type = "artcustomer.maxima.events.GameEvent")]
	[Event(name = "gameReset", type = "artcustomer.maxima.events.GameEvent")]
	[Event(name = "gamePause", type = "artcustomer.maxima.events.GameEvent")]
	[Event(name = "gameResume", type = "artcustomer.maxima.events.GameEvent")]
	[Event(name = "gameDestroy", type = "artcustomer.maxima.events.GameEvent")]
	
	
	/**
	 * GameContext : Context of the game.
	 * 
	 * @author David Massenot
	 */
	public class GameContext extends ServiceContext {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.context::GameContext';
		
		private var _engineManager:EngineManager;
		private var _multiThreadProxy:MultiThreadProxy;
		
		private var _isContextSetup:Boolean;
		
		private static var __allowInstantiation:Boolean;
		private static var __currentContext:IGameContext;
		
		
		/**
		 * Constructor
		 * 
		 * @param	contextView
		 */
		public function GameContext(contextView:DisplayObjectContainer = null) {
			_isContextSetup = false;
			__allowInstantiation = true;
			
			super();
			
			if (!__allowInstantiation) throw new IllegalGameError(IllegalGameError.E_CONTEXT_INSTANTIATION);
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_CONTEXT_CONSTRUCTOR);
			if (contextView) this.contextView = contextView;
			
			__allowInstantiation = false;
		}
		
		//---------------------------------------------------------------------
		//  Stage
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupStage():void {
			this.stageReference.scaleMode = StageScaleMode.NO_SCALE;
			this.stageReference.quality = StageQuality.HIGH;
			this.stageReference.align = StageAlign.TOP_LEFT;
		}
		
		//---------------------------------------------------------------------
		//  EngineManager
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupEngineManager():void {
			_engineManager = EngineManager.getInstance();
			_engineManager.context = this;
			_engineManager.setup();
		}
		
		/**
		 * @private
		 */
		private function destroyEngineManager():void {
			_engineManager.destroy();
			_engineManager = null;
		}
		
		/**
		 * @private
		 */
		private function startEngineManager():void {
			_engineManager.start();
		}
		
		/**
		 * @private
		 */
		private function resetEngineManager():void {
			_engineManager.reset();
		}
		
		/**
		 * @private
		 */
		private function resizeEngineManager():void {
			_engineManager.resize();
		}
		
		//---------------------------------------------------------------------
		//  MultiThreadProxy
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupMultiThreadProxy():void {
			_multiThreadProxy = MultiThreadProxy.getInstance();
		}
		
		/**
		 * @private
		 */
		private function destroyMultiThreadProxy():void {
			_multiThreadProxy.destroy();
			_multiThreadProxy = null;
		}
		
		
		/**
		 * Get Debug version of Context.
		 * 
		 * @return
		 */
		public function debug():String {
			var t:String = '';
			var a:Array;
			var o:Object;
			
			if (!_isContextSetup) return "Setup method don't called !";
			
			t += '[[ ' + this.name + ' DEBUG GAME CONTEXT ]]';
			t += '\n';
			t += 'Width : ' + this.contextWidth;
			t += '\n';
			t += 'Height : ' + this.contextHeight;
			t += '\n';
			t += 'Mode : ' + this.mode;
			
			return t;
		}
		
		/**
		 * Get Debug version of Player.
		 * 
		 * @return
		 */
		public function infos():String {
			var t:String = '';
			
			t += '[[ DEBUG PLAYER ]]';
			t += '\n';
			t += 'Runtime : ' + this.runtime;
			t += '\n';
			t += 'Version : ' + this.flashVersion;
			t += '\n';
			t += 'Framerate : ' + this.framerate;
			t += '\n';
			t += 'Operating system : ' + this.operatingSystem;
			t += '\n';
			t += 'Bits processes supported : ' + this.bitsProcessesSupported;
			t += '\n';
			t += 'CPU : ' + this.cpuArchitecture;
			t += '\n';
			
			return t;
		}
		
		/**
		 * Called by InteractiveContext during resizing. Don't call it !
		 */
		internal final function resize():void {
			resizeEngineManager();
		}
		
		/**
		 * Start Game after called setup and set all core classes. Override it !
		 */
		public function start():void {
			startEngineManager();
		}
		
		/**
		 * Reset the context. Must be overrided.
		 */
		public function reset():void {
			resetEngineManager();
		}
		
		/**
		 * Setup the context. Must be overrided and called at first.
		 */
		override public function setup():void {
			if (_isContextSetup) throw new GameError(GameError.E_CONTEXT_SETUP_TRUE);
			if (!this.contextView) throw new GameError(GameError.E_CONTEXT_SETUP);
			
			setupStage();
			setupMultiThreadProxy();
			setupEngineManager();
			
			super.setup();
			
			__currentContext = this;
			
			this.instance = this;
			this.dispatchEvent(new GameEvent(GameEvent.GAME_SETUP, true, false, this, this.contextWidth, this.contextHeight, this.contextView.stage.stageWidth, this.contextView.stage.stageHeight));
			this.showMenu();
			
			_isContextSetup = true;
		}
		
		/**
		 * Destroy the context. Must be overrided and called at end.
		 */
		override public function destroy():void {
			if (!_isContextSetup) throw new GameError(GameError.E_CONTEXT_SETUP_FALSE);
			if (!this.contextView) throw new GameError(GameError.E_CONTEXT_DESTROY);
			
			destroyEngineManager();
			destroyMultiThreadProxy();
			
			this.dispatchEvent(new GameEvent(GameEvent.GAME_DESTROY, true, false, this, this.contextWidth, this.contextHeight, this.contextView.stage.stageWidth, this.contextView.stage.stageHeight));
			
			super.destroy();
			
			_isContextSetup = false;
			__allowInstantiation = false;
			__currentContext = null;
		}
		
		/**
		 * Send external message from internal elements of the framework. Must be overrided.
		 * 
		 * @param	message
		 * @param	id
		 */
		public function sendExternalMessage(message:String, id:String = null):void {
			
		}
		
		/**
		 * Throw an Error.
		 * 
		 * @param	message
		 * @param	id
		 */
		public function throwError(message:* = "", id:* = 0):void {
			throw new Error(message, id);
		}
		
		/**
		 * Throw a custom Error.
		 * 
		 * @param	error
		 * @param	message
		 * @param	id
		 */
		public function throwCustomError(error:Class, message:* = "", id:* = 0):void {
			if (error) throw new error(message, id);
		}
		
		
		/**
		 * @private
		 */
		public function get isContextSetup():Boolean {
			return _isContextSetup;
		}
		
		/**
		 * @private
		 */
		public function get multiThreadProxy():MultiThreadProxy {
			return _multiThreadProxy;
		}
		
		/**
		 * @private
		 */
		public function get shore():Shore {
			return _engineManager.shore;
		}
		
		/**
		 * @private
		 */
		public function get assetsLoader():AssetsLoader {
			return _engineManager.assetsLoader;
		}
		
		/**
		 * @private
		 */
		public function get renderEngine():RenderEngine {
			return _engineManager.renderEngine;
		}
		
		/**
		 * @private
		 */
		public function get gameEngine():GameEngine {
			return _engineManager.gameEngine;
		}
		
		/**
		 * @private
		 */
		public function get directInputEngine():DirectInputEngine {
			return _engineManager.directInputEngine;
		}
		
		/**
		 * @private
		 */
		public function get scoreEngine():ScoreEngine {
			return _engineManager.scoreEngine;
		}
		
		/**
		 * @private
		 */
		public function get sfxEngine():SFXEngine {
			return _engineManager.sfxEngine;
		}
		
		
		/**
		 * Get current Context.
		 * @private
		 */
		public static function get currentContext():IGameContext {
			return __currentContext;
		}
		
		/**
		 * Test if Context is available.
		 * @private
		 */
		public static function get allowInstantiation():Boolean {
			return __allowInstantiation;
		}
	}
}