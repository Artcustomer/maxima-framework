/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine {
	import artcustomer.maxima.context.*;
	import artcustomer.maxima.core.*;
	import artcustomer.maxima.core.game.*;
	import artcustomer.maxima.core.loader.*;
	import artcustomer.maxima.core.score.*;
	import artcustomer.maxima.core.view.*;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.events.*;
	
	
	/**
	 * GameEngine
	 * 
	 * @author David Massenot
	 */
	public class GameEngine extends AbstractDisplayCoreEngine {
		private static var __instance:GameEngine;
		private static var __allowInstantiation:Boolean;
		
		private var _navigationSystem:NavigationSystem;
		
		private var _currentEngineObject:AbstractEngineObject;
		
		private var _onReset:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function GameEngine() {
			super();
			
			if (!__allowInstantiation) {
				throw new GameError(GameError.E_GAMEENGINE_CREATE);
				
				return;
			}
		}
		
		//---------------------------------------------------------------------
		//  NavigationSystem
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupNavigationSystem():void {
			_navigationSystem = NavigationSystem.getInstance();
			_navigationSystem.context = this.context;
			
			_navigationSystem.addEventListener(NavigationSystemEvent.ON_LOCATION_REQUESTED, handleNavigationSystem, false, 0, true);
			_navigationSystem.addEventListener(NavigationSystemEvent.ON_LOCATION_CHANGE, handleNavigationSystem, false, 0, true);
			_navigationSystem.addEventListener(NavigationSystemEvent.ON_LOCATION_NOT_FOUND, handleNavigationSystem, false, 0, true);
			_navigationSystem.addEventListener(NavigationSystemEvent.ON_SYSTEM_ERROR, handleNavigationSystem, false, 0, true);
			_navigationSystem.setup();
		}
		
		/**
		 * @private
		 */
		private function destroyNavigationSystem():void {
			_navigationSystem.removeEventListener(NavigationSystemEvent.ON_LOCATION_REQUESTED, handleNavigationSystem);
			_navigationSystem.removeEventListener(NavigationSystemEvent.ON_LOCATION_CHANGE, handleNavigationSystem);
			_navigationSystem.removeEventListener(NavigationSystemEvent.ON_LOCATION_NOT_FOUND, handleNavigationSystem);
			_navigationSystem.removeEventListener(NavigationSystemEvent.ON_SYSTEM_ERROR, handleNavigationSystem);
			_navigationSystem.destroy();
			_navigationSystem = null;
		}
		
		/**
		 * @private
		 */
		private function updateMapInNavigationSystem(key:String, engineClass:Class):void {
			_navigationSystem.addInMap(key, engineClass);
		}
		
		/**
		 * @private
		 */
		private function updateLocationInNavigationSystem():void {
			_navigationSystem.updateLocationAfterRequest(_currentEngineObject.isAvailableForHistory);
		}
		
		/**
		 * @private
		 */
		private function runTimeLineInNavigationSystem():void {
			_navigationSystem.runTimeLine();
		}
		
		/**
		 * @private
		 */
		private function handleNavigationSystem(e:NavigationSystemEvent):void {
			switch (e.type) {
				case('onLocationRequested'):
					checkCurrentEngineObject();
					break;
					
				case('onLocationChange'):
					break;
					
				case('onLocationNotFound'):
					break;
					
				case('onSystemError'):
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  Engine Object
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function entryCurrentEngineObject():void {
			createCurrentEngineObject();
			
			if (_currentEngineObject) {
				_currentEngineObject.addEventListener(EngineObjectEvent.ON_ENTRY, handleCurrentEngineObject, false, 0, true);
				_currentEngineObject.addEventListener(EngineObjectEvent.ON_EXIT, handleCurrentEngineObject, false, 0, true);
				_injector.entryObject(_currentEngineObject);
			} else {
				throw new GameError(GameError.E_NULL_CURRENTOBJECT);
			}
		}
		
		/**
		 * @private
		 */
		private function exitCurrentEngineObject():void {
			if (_currentEngineObject) _injector.exitObject(_currentEngineObject);
		}
		
		/**
		 * @private
		 */
		private function checkCurrentEngineObject():void {
			if (_currentEngineObject) {
				exitCurrentEngineObject();
			} else {
				entryCurrentEngineObject();
			}
		}
		
		/**
		 * @private
		 */
		private function createCurrentEngineObject():void {
			if (_navigationSystem.currentEngineClass) {
				_currentEngineObject = new _navigationSystem.currentEngineClass();
				
				if (_currentEngineObject) {
					_currentEngineObject.context = this.context;
					
					if (_currentEngineObject is AbstractEngineDisplayObject) (_currentEngineObject as AbstractEngineDisplayObject).parent = this.engineDisplayContainer;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function destroyCurrentEngineObject():void {
			if (_currentEngineObject) {
				_injector.destroyObject(_currentEngineObject);
				_currentEngineObject.removeEventListener(EngineObjectEvent.ON_ENTRY, handleCurrentEngineObject);
				_currentEngineObject.removeEventListener(EngineObjectEvent.ON_EXIT, handleCurrentEngineObject);
				_currentEngineObject = null;
			}
		}
		
		/**
		 * @private
		 */
		private function handleCurrentEngineObject(e:EngineObjectEvent):void {
			switch (e.type) {
				case('onEntry'):
					updateLocationInNavigationSystem();
					break;
					
				case('onExit'):
					destroyCurrentEngineObject();
					
					if (_onReset) {
						this.start();
					} else {
						entryCurrentEngineObject();
					}
					break;
					
				default:
					break;
			}
		}
		
		
		/**
		 * Entry point.
		 */
		override internal function setup():void {
			super.setup();
			
			setupNavigationSystem();
			
			_onReset = false;
		}
		
		/**
		 * Destructor
		 */
		override internal function destroy():void {
			destroyNavigationSystem();
			
			_currentEngineObject = null;
			_onReset = false;
			
			super.destroy();
		}
		
		/**
		 * Start game.
		 */
		internal function start():void {
			_onReset = false;
			
			runTimeLineInNavigationSystem();
		}
		
		/**
		 * Reset game.
		 */
		internal function reset():void {
			_onReset = true;
			
			exitCurrentEngineObject();
		}
		
		/**
		 * Set global loader for the game.
		 * Would be called at first !
		 * 
		 * @param	engineClass : Class extends GlobalLoader
		 * @param	name : Name of the object (the key)
		 */
		public function setGlobalLoader(engineClass:Class, name:String):void {
			if (!engineClass || !engineClass is GlobalLoader) {
				throw new GameError(GameError.E_CORE_GLOBALLOADER);
				
				return;
			}
			
			updateMapInNavigationSystem(name, engineClass);
		}
		
		/**
		 * Set single view in the engine.
		 * 
		 * @param	engineClass : Class extends DisplayView
		 * @param	name : Name of the object (the key)
		 */
		public function setView(engineClass:Class, name:String):void {
			if (!engineClass || !engineClass is DisplayView) {
				throw new GameError(GameError.E_CORE_DISPLAYVIEW);
				
				return;
			}
			
			updateMapInNavigationSystem(name, engineClass);
		}
		
		/**
		 * Set view group in the engine. A view group can contain multiple views.
		 * 
		 * @param	engineClass : Class extends DisplayViewGroup
		 * @param	name : Name of the object (the key)
		 */
		public function setViewGroup(engineClass:Class, name:String):void {
			if (!engineClass || !engineClass is DisplayViewGroup) {
				throw new GameError(GameError.E_CORE_DISPLAYVIEWGROUP);
				
				return;
			}
			
			updateMapInNavigationSystem(name, engineClass);
		}
		
		/**
		 * Set the game in the engine.
		 * 
		 * @param	engineClass : Class extends DisplayGame
		 * @param	name : Name of the object (the key)
		 */
		public function setGame(engineClass:Class, name:String):void {
			if (!engineClass || !engineClass is DisplayGame) {
				throw new GameError(GameError.E_CORE_DISPLAYGAME);
				
				return;
			}
			
			updateMapInNavigationSystem(name, engineClass);
		}
		
		
		/**
		 * Instantiate GameEngine.
		 */
		public static function getInstance():GameEngine {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new GameEngine();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
		
		
		/**
		 * @private
		 */
		internal function get currentEngineObject():AbstractEngineObject {
			return _currentEngineObject;
		}
		
		/**
		 * @private
		 */
		public function get navigationSystem():NavigationSystem {
			return _navigationSystem;
		}
	}
}