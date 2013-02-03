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
		private var _gameEngine:GameEngine;
		private var _scoreEngine:ScoreEngine;
		private var _sfxEngine:SFXEngine;
		private var _directInputEngine:DirectInputEngine;
		
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
		
		//---------------------------------------------------------------------
		//  EngineObjectInjector
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupEngineObjectInjector():void {
			_engineObjectInjector = EngineObjectInjector.getInstance();
		}
		
		/**
		 * @private
		 */
		private function destroyEngineObjectInjector():void {
			_engineObjectInjector.destroy();
			_engineObjectInjector = null;
		}
		
		//---------------------------------------------------------------------
		//  Shore
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupShore():void {
			_shore = Shore.getInstance();
		}
		
		/**
		 * @private
		 */
		private function destroyShore():void {
			_shore.destroy();
			_shore = null;
		}
		
		//---------------------------------------------------------------------
		//  AssetsLoader
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupAssetsLoader():void {
			_assetsLoader = AssetsLoader.getInstance();
			_assetsLoader.context = _context;
			_assetsLoader.setup();
		}
		
		/**
		 * @private
		 */
		private function destroyAssetsLoader():void {
			_assetsLoader.destroy();
			_assetsLoader = null;
		}
		
		//---------------------------------------------------------------------
		//  RenderEngine
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupRenderEngine():void {
			_renderEngine = RenderEngine.getInstance();
			_renderEngine.context = _context;
			_renderEngine.injector = _engineObjectInjector;
			_renderEngine.setup();
		}
		
		/**
		 * @private
		 */
		private function destroyRenderEngine():void {
			_renderEngine.destroy();
			_renderEngine = null;
		}
		
		//---------------------------------------------------------------------
		//  GameEngine
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupGameEngine():void {
			_gameEngine = GameEngine.getInstance();
			_gameEngine.context = _context;
			_gameEngine.injector = _engineObjectInjector;
			_gameEngine.setup();
		}
		
		/**
		 * @private
		 */
		private function destroyGameEngine():void {
			_gameEngine.destroy();
			_gameEngine = null;
		}
		
		/**
		 * @private
		 */
		private function startGameEngine():void {
			_gameEngine.start();
		}
		
		/**
		 * @private
		 */
		private function resetGameEngine():void {
			_gameEngine.reset();
		}
		
		//---------------------------------------------------------------------
		//  ScoreEngine
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupScoreEngine():void {
			_scoreEngine = ScoreEngine.getInstance();
			_scoreEngine.context = _context;
			_scoreEngine.injector = _engineObjectInjector;
			_scoreEngine.setup();
		}
		
		/**
		 * @private
		 */
		private function destroyScoreEngine():void {
			_scoreEngine.destroy();
			_scoreEngine = null;
		}
		
		//---------------------------------------------------------------------
		//  SFXEngine
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupSFXEngine():void {
			_sfxEngine = SFXEngine.getInstance();
			_sfxEngine.context = _context;
			_sfxEngine.setup();
		}
		
		/**
		 * @private
		 */
		private function destroySFXEngine():void {
			_sfxEngine.destroy();
			_sfxEngine = null;
		}
		
		//---------------------------------------------------------------------
		//  DirectInputEngine
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupDirectInputEngine():void {
			_directInputEngine = DirectInputEngine.getInstance();
			_directInputEngine.context = _context;
			_directInputEngine.injector = _engineObjectInjector;
			_directInputEngine.setup();
		}
		
		/**
		 * @private
		 */
		private function destroyDirectInputEngine():void {
			_directInputEngine.destroy();
			_directInputEngine = null;
		}
		
		
		/**
		 * Entry point.
		 */
		public function setup():void {
			setupEngineObjectInjector();
			setupShore();
			setupAssetsLoader();
			setupRenderEngine();
			setupScoreEngine();
			setupSFXEngine();
			setupDirectInputEngine();
			setupGameEngine();
		}
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			destroyDirectInputEngine();
			destroyGameEngine();
			destroySFXEngine();
			destroyScoreEngine();
			destroyRenderEngine();
			destroyAssetsLoader();
			destroyShore();
			destroyEngineObjectInjector();
			
			__instance = null;
			__allowInstantiation = false;
			_allowSetContext = false;
		}
		
		/**
		 * Start engine.
		 */
		public function start():void {
			startGameEngine();
		}
		
		/**
		 * Reset engine.
		 */
		public function reset():void {
			resetGameEngine();
		}
		
		/**
		 * Resize engine.
		 */
		public function resize():void {
			if (_gameEngine.currentEngineObject) _engineObjectInjector.resizeObject(_gameEngine.currentEngineObject);
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
		public function get gameEngine():GameEngine {
			return _gameEngine;
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
	}
}