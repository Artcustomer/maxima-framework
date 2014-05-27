/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.context {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.events.*;
	import artcustomer.maxima.engine.*;
	import artcustomer.maxima.proxies.threads.*;
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
		
		private static var __allowInstantiation:Boolean;
		private static var __currentContext:IGameContext;
		
		private var _multiThreadProxy:MultiThreadProxy;
		private var _engineManager:EngineManager;
		
		private var _isContextSetup:Boolean;
		
		protected var _delayedGameEngineCreation:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function GameContext() {
			_isContextSetup = false;
			__allowInstantiation = true;
			
			super();
			
			if (!__allowInstantiation) throw new IllegalGameError(IllegalGameError.E_CONTEXT_INSTANTIATION);
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_CONTEXT_CONSTRUCTOR);
			
			__allowInstantiation = false;
		}
		
		
		/**
		 * Called by InteractiveContext during resizing. Don't call it !
		 */
		internal function resize():void {
			_engineManager.resize();
		}
		
		/**
		 * Called when framework is ready. Override it, add entities and call start() here !
		 */
		protected function onReady():void {
			
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
			
			t += '[[ DEBUG GAME CONTEXT : ' + this.name + ' ]]';
			t += '\n';
			t += 'Context Width : ' + this.contextWidth;
			t += '\n';
			t += 'Context Height : ' + this.contextHeight;
			t += '\n';
			t += 'Fullscreen Width : ' + this.fullScreenWidth;
			t += '\n';
			t += 'Fullscreen Height : ' + this.fullScreenHeight;
			t += '\n';
			t += 'Stage Width : ' + this.stageWidth;
			t += '\n';
			t += 'Stage Height : ' + this.stageHeight;
			t += '\n';
			t += 'Scene Width : ' + this.sceneWidth;
			t += '\n';
			t += 'Scene Height : ' + this.sceneHeight;
			t += '\n';
			t += 'ScaleToStage : ' + this.scaleToStage;
			t += '\n';
			t += 'ScaleFactor : ' + this.scaleFactor;
			t += '\n';
			t += 'DPI : ' + this.screenDPI;
			t += '\n';
			t += 'Tablet : ' + _isTablet;
			t += '\n';
			t += 'Mode : ' + this.mode;
			t += '\n';
			t += '[[ END DEBUG GAME CONTEXT ]]';
			
			return t;
		}
		
		/**
		 * Start Game after called setup and set all core classes. Can be overrided, call it at end !
		 */
		public function start():void {
			_engineManager.start();
		}
		
		/**
		 * Reset the context. Can be overrided.
		 */
		public function reset():void {
			_engineManager.reset();
		}
		
		/**
		 * Setup the context. Must be overrided and called at first.
		 */
		override public function setup():void {
			if (_isContextSetup) throw new GameError(GameError.E_CONTEXT_SETUP_TRUE);
			if (!this.contextView) throw new GameError(GameError.E_CONTEXT_SETUP);
			
			this.instance = this;
			
			__currentContext = this;
			
			_multiThreadProxy = MultiThreadProxy.getInstance();
			
			_engineManager = EngineManager.getInstance();
			_engineManager.context = this;
			_engineManager.setup();
			
			super.setup();
			
			if (!_delayedGameEngineCreation) this.createGameEngine();
			this.dispatchEvent(new GameEvent(GameEvent.GAME_SETUP, true, false, this, this.contextWidth, this.contextHeight, this.contextView.stage.stageWidth, this.contextView.stage.stageHeight));
			
			_isContextSetup = true;
		}
		
		/**
		 * Destroy the context. Must be overrided and called at end.
		 */
		override public function destroy():void {
			if (!_isContextSetup) throw new GameError(GameError.E_CONTEXT_SETUP_FALSE);
			if (!this.contextView) throw new GameError(GameError.E_CONTEXT_DESTROY);
			
			_engineManager.destroy();
			_engineManager = null;
			
			_multiThreadProxy.destroy();
			_multiThreadProxy = null;
			
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
		 * Create game engine, depends of the platform. Override it !
		 */
		protected function createGameEngine():void {
			
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
		public function get logicEngine():LogicEngine {
			return _engineManager.logicEngine;
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
		 * @private
		 */
		public function get gameEngine():GameEngine {
			return _engineManager.gameEngine;
		}
		/**
		 * @private
		 */
		internal function get engineManager():EngineManager {
			return _engineManager;
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