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
	import artcustomer.maxima.core.view.*;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.events.*;
	
	
	/**
	 * GameEngine
	 * 
	 * @author David Massenot
	 */
	public class GameEngine extends AbstractCoreEngine {
		protected var _navigationSystem:NavigationSystem;
		protected var _currentEngineObject:AbstractEngineObject;
		
		protected var _onReset:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function GameEngine() {
			super();
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleDeviceInputs(e:DeviceInputsEvent):void {
			switch (e.type) {
				case(DeviceInputsEvent.DEVICE_BACK):
					if (_currentEngineObject) _injector.onBack(_currentEngineObject);
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  NavigationSystem
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleNavigationSystem(e:NavigationSystemEvent):void {
			switch (e.type) {
				case(NavigationSystemEvent.ON_LOCATION_REQUESTED):
					checkCurrentEngineObject();
					break;
					
				case(NavigationSystemEvent.ON_LOCATION_CHANGE):
					break;
					
				case(NavigationSystemEvent.ON_LOCATION_NOT_FOUND):
					throw new GameError(e.error);
					break;
					
				case(NavigationSystemEvent.ON_SYSTEM_ERROR):
					throw new GameError(GameError.E_NAVIGATION_ERROR + ' ' + e.error);
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
				_currentEngineObject.addEventListener(EngineObjectEvent.ON_RESTART, handleCurrentEngineObject, false, 0, true);
				_injector.entryObject(_currentEngineObject);
				if (!this.context.instance.isFocusOnStage) _injector.disableFocus(_currentEngineObject);
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
					
					this.addCurrentObjectToStage();
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
				_currentEngineObject.removeEventListener(EngineObjectEvent.ON_RESTART, handleCurrentEngineObject);
				_currentEngineObject = null;
			}
		}
		
		/**
		 * @private
		 */
		private function handleCurrentEngineObject(e:EngineObjectEvent):void {
			switch (e.type) {
				case(EngineObjectEvent.ON_ENTRY):
					_navigationSystem.updateLocationAfterRequest(_currentEngineObject.isAvailableForHistory);
					break;
					
				case(EngineObjectEvent.ON_EXIT):
					destroyCurrentEngineObject();
					
					if (_onReset) {
						this.start();
					} else {
						entryCurrentEngineObject();
					}
					break;
					
				case(EngineObjectEvent.ON_RESTART):
					_navigationSystem.restartCurrent();
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * Add display object to stage. Override it !
		 */
		protected function addCurrentObjectToStage():void {
			
		}
		
		/**
		 * Entry point.
		 */
		override internal function setup():void {
			super.setup();
			
			_navigationSystem = NavigationSystem.getInstance();
			_navigationSystem.context = this.context;
			_navigationSystem.addEventListener(NavigationSystemEvent.ON_LOCATION_REQUESTED, handleNavigationSystem, false, 0, true);
			_navigationSystem.addEventListener(NavigationSystemEvent.ON_LOCATION_CHANGE, handleNavigationSystem, false, 0, true);
			_navigationSystem.addEventListener(NavigationSystemEvent.ON_LOCATION_NOT_FOUND, handleNavigationSystem, false, 0, true);
			_navigationSystem.addEventListener(NavigationSystemEvent.ON_SYSTEM_ERROR, handleNavigationSystem, false, 0, true);
			_navigationSystem.setup();
			
			this.context.addEventListener(DeviceInputsEvent.DEVICE_BACK, handleDeviceInputs, false, 0, true);
			
			_onReset = false;
		}
		
		/**
		 * Destructor
		 */
		override internal function destroy():void {
			_navigationSystem.removeEventListener(NavigationSystemEvent.ON_LOCATION_REQUESTED, handleNavigationSystem);
			_navigationSystem.removeEventListener(NavigationSystemEvent.ON_LOCATION_CHANGE, handleNavigationSystem);
			_navigationSystem.removeEventListener(NavigationSystemEvent.ON_LOCATION_NOT_FOUND, handleNavigationSystem);
			_navigationSystem.removeEventListener(NavigationSystemEvent.ON_SYSTEM_ERROR, handleNavigationSystem);
			_navigationSystem.destroy();
			_navigationSystem = null;
			
			this.context.removeEventListener(DeviceInputsEvent.DEVICE_BACK, handleDeviceInputs);
			
			_currentEngineObject = null;
			_onReset = false;
			
			super.destroy();
		}
		
		/**
		 * Start game.
		 */
		internal function start():void {
			_onReset = false;
			_navigationSystem.runTimeLine();
		}
		
		/**
		 * Reset game.
		 */
		internal function reset():void {
			_onReset = true;
			
			exitCurrentEngineObject();
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