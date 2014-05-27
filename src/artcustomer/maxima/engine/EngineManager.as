/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine {
	import artcustomer.maxima.base.*;
	import artcustomer.maxima.context.*;
	import artcustomer.maxima.engine.*;
	import artcustomer.maxima.core.*;
	import artcustomer.maxima.errors.*;
	
	
	/**
	 * EngineManager
	 * 
	 * @author David Massenot
	 */
	public class EngineManager implements IDestroyable {
		private static var __instance:EngineManager;
		private static var __allowInstantiation:Boolean;
		
		private var _context:IGameContext;
		
		private var _engineObjectInjector:EngineObjectInjector;
		private var _shore:Shore;
		private var _assetsLoader:AssetsLoader;
		private var _renderEngine:RenderEngine;
		private var _logicEngine:LogicEngine;
		private var _scoreEngine:ScoreEngine;
		private var _sfxEngine:SFXEngine;
		private var _directInputEngine:DirectInputEngine;
		private var _gameEngine:GameEngine;
		
		private var _allowSetContext:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function EngineManager() {
			if (!__allowInstantiation) {
				throw new GameError(GameError.E_ENGINEMANAGER_CREATE);
				
				return;
			}
			
			_allowSetContext = true;
		}
		
		
		/**
		 * Entry point.
		 */
		public function setup():void {
			_engineObjectInjector = EngineObjectInjector.getInstance();
			
			_shore = Shore.getInstance();
			
			_assetsLoader = createEngine(AssetsLoader, false) as AssetsLoader;
			_renderEngine = createEngine(RenderEngine, false) as RenderEngine;
			_scoreEngine = createEngine(ScoreEngine) as ScoreEngine;
			_sfxEngine = createEngine(SFXEngine, false) as SFXEngine;
			_logicEngine = createEngine(LogicEngine) as LogicEngine;
			_directInputEngine = createEngine(DirectInputEngine) as DirectInputEngine;
		}
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			_gameEngine.destroy();
			_gameEngine = null;
			
			_directInputEngine.destroy();
			_directInputEngine = null;
			
			_sfxEngine.destroy();
			_sfxEngine = null;
			
			_scoreEngine.destroy();
			_scoreEngine = null;
			
			_renderEngine.destroy();
			_renderEngine = null;
			
			_assetsLoader.destroy();
			_assetsLoader = null;
			
			_shore.destroy();
			_shore = null;
			
			_engineObjectInjector.destroy();
			_engineObjectInjector = null;
			
			__instance = null;
			__allowInstantiation = false;
			_allowSetContext = false;
		}
		
		/**
		 * Start engine.
		 */
		public function start():void {
			_gameEngine.start();
		}
		
		/**
		 * Reset engine.
		 */
		public function reset():void {
			_gameEngine.reset();
		}
		
		/**
		 * Resize engine.
		 */
		public function resize():void {
			if (_gameEngine && _gameEngine.currentEngineObject) _engineObjectInjector.resizeObject(_gameEngine.currentEngineObject);
		}
		
		/**
		 * Create Flash game engine.
		 */
		public function createGameEngine(engineClass:Class):void {
			_gameEngine = this.createEngine(engineClass) as GameEngine;
		}
		
		/**
		 * Create engine.
		 * 
		 * @param	engineClass
		 * @param	needInjector
		 * @return
		 */
		public function createEngine(engineClass:Class, needInjector:Boolean = true):AbstractCoreEngine {
			var engine:AbstractCoreEngine = new engineClass();
			engine.context = _context;
			if (needInjector) engine.injector = _engineObjectInjector;
			engine.setup();
			
			return engine;
		}
		
		/**
		 * Remove engine.
		 * 
		 * @param	engine
		 */
		public function removeEngine(engine:AbstractCoreEngine):void {
			if (engine) engine.destroy();
		}
		
		
		/**
		 * Instantiate EngineManager.
		 */
		public static function getInstance():EngineManager {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new EngineManager();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
		
		
		/**
		 * @private
		 */
		public function set context(value:IGameContext):void {
			if (_allowSetContext) {
				_context = value;
				
				_allowSetContext = false;
			}
		}
		
		/**
		 * @private
		 */
		public function get shore():Shore {
			return _shore;
		}
		
		/**
		 * @private
		 */
		public function get assetsLoader():AssetsLoader {
			return _assetsLoader;
		}
		
		/**
		 * @private
		 */
		public function get renderEngine():RenderEngine {
			return _renderEngine;
		}
		
		/**
		 * @private
		 */
		public function get logicEngine():LogicEngine {
			return _logicEngine;
		}
		
		/**
		 * @private
		 */
		public function get scoreEngine():ScoreEngine {
			return _scoreEngine;
		}
		
		/**
		 * @private
		 */
		public function get sfxEngine():SFXEngine {
			return _sfxEngine;
		}
		
		/**
		 * @private
		 */
		public function get directInputEngine():DirectInputEngine {
			return _directInputEngine;
		}
		
		/**
		 * @private
		 */
		public function get gameEngine():GameEngine {
			return _gameEngine;
		}
	}
}