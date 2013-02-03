/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine {
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import artcustomer.maxima.context.*;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.events.NavigationSystemEvent;
	
	[Event(name="onLocationRequested", type="artcustomer.maxima.events.NavigationSystemEvent")]
	[Event(name="onLocationChange", type="artcustomer.maxima.events.NavigationSystemEvent")]
	[Event(name="onLocationNotFound", type="artcustomer.maxima.events.NavigationSystemEvent")]
	[Event(name="onSystemError", type="artcustomer.maxima.events.NavigationSystemEvent")]
	
	
	/**
	 * NavigationSystem
	 * 
	 * @author David Massenot
	 */
	public class NavigationSystem extends AbstractCoreEngine {
		private static var __instance:NavigationSystem;
		private static var __allowInstantiation:Boolean;
		
		private var _navigationMap:Dictionary;
		private var _navigationStack:Array;
		private var _historyStack:Array;
		
		private var _navigationIndex:int;
		private var _historyIndex:int;
		
		private var _requestedLocation:String;
		private var _currentLocation:String;
		private var _currentEngineClass:Class;
		private var _tempError:String;
		
		private var _isChangeByHistory:Boolean;
		private var _isHistoryForward:Boolean;
		private var _onProcessing:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function NavigationSystem() {
			if (!__allowInstantiation) {
				throw new GameError(GameError.E_NAVIGATIONSYSTEM_CREATE);
				
				return;
			}
		}
		
		//---------------------------------------------------------------------
		//  Navigation Map
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupNavigationMap():void {
			_navigationMap = new Dictionary();
		}
		
		/**
		 * @private
		 */
		private function destroyNavigationMap():void {
			_navigationMap = null;
		}
		
		/**
		 * @private
		 */
		private function disposeNavigationMap():void {
			var key:String;
			
			for (key in _navigationMap) {
				_navigationMap[key] = null;
				delete _navigationMap[key];
			}
		}
		
		//---------------------------------------------------------------------
		//  Navigation Stack
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupNavigationStack():void {
			_navigationStack = new Array();
		}
		
		/**
		 * @private
		 */
		private function destroyNavigationStack():void {
			_navigationStack = null;
		}
		
		/**
		 * @private
		 */
		private function disposeNavigationStack():void {
			var i:int;
			var length:int = _navigationStack.length;
			
			for (i ; i < length ; i++) {
				_navigationStack[i] = null;
				delete _navigationStack[i];
			}
			
			_navigationStack.length = 0;
		}
		
		/**
		 * @private
		 */
		private function getNavigationIndexByKey(key:String):int {
			var i:int = 0;
			var length:int = _navigationStack.length;
			
			for (i ; i < length ; i++) {
				if (key == _navigationStack[i]) return i;
			}
			
			return -1;
		}
		
		//---------------------------------------------------------------------
		//  History Stack
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupHistoryStack():void {
			_historyStack = new Array();
		}
		
		/**
		 * @private
		 */
		private function destroyHistoryStack():void {
			_historyStack = null;
		}
		
		/**
		 * @private
		 */
		private function disposeHistoryStack():void {
			var i:int;
			var length:int = _historyStack.length;
			
			for (i ; i < length ; i++) {
				_historyStack[i] = null;
				delete _historyStack[i];
			}
			
			_historyStack.length = 0;
		}
		
		//---------------------------------------------------------------------
		//  Event Dispatching
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function dispatchRequestedEvent():void {
			this.dispatchEvent(new NavigationSystemEvent(NavigationSystemEvent.ON_LOCATION_REQUESTED, false, false, _requestedLocation, _currentLocation));
		}
		
		/**
		 * @private
		 */
		private function dispatchChangeEvent():void {
			this.dispatchEvent(new NavigationSystemEvent(NavigationSystemEvent.ON_LOCATION_CHANGE, false, false, _requestedLocation, _currentLocation));
		}
		
		/**
		 * @private
		 */
		private function dispatchNotFoundEvent():void {
			this.dispatchEvent(new NavigationSystemEvent(NavigationSystemEvent.ON_LOCATION_NOT_FOUND, false, false, _requestedLocation, _currentLocation, _tempError));
		}
		
		/**
		 * @private
		 */
		private function dispatchErrorEvent():void {
			this.dispatchEvent(new NavigationSystemEvent(NavigationSystemEvent.ON_SYSTEM_ERROR, false, false, _requestedLocation, _currentLocation, _tempError));
		}
		
		//---------------------------------------------------------------------
		//  Navigation
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function gotoKey(key:String):void {
			if (_onProcessing) return;
			
			if (!hasKey(key)) {
				_tempError = ErrorsList.LOCATION_NOT_FOUND + key;
				
				dispatchNotFoundEvent();
			} else {
				if (_currentLocation == key) _isChangeByHistory = true;
				
				_requestedLocation = key;
				_currentEngineClass = _navigationMap[key];
				_onProcessing = true;
				
				dispatchRequestedEvent();
			}
		}
		
		/**
		 * @private
		 */
		private function hasKey(key:String):Boolean {
			return _navigationMap[key] != null;
		}
		
		
		/**
		 * Entry point.
		 */
		override internal function setup():void {
			super.setup();
			
			_navigationIndex = -1;
			_historyIndex = -1;
			_onProcessing = false;
			
			setupNavigationMap();
			setupNavigationStack();
			setupHistoryStack();
		}
		
		/**
		 * Destructor.
		 */
		override internal function destroy():void {
			disposeNavigationMap();
			destroyNavigationMap();
			disposeHistoryStack();
			destroyHistoryStack();
			disposeNavigationStack();
			destroyNavigationStack();
			
			_navigationIndex = 0;
			_historyIndex = 0;
			_requestedLocation = null;
			_currentLocation = null;
			_currentEngineClass = null;
			_tempError = null;
			_onProcessing = false;
			_isChangeByHistory = false;
			_isHistoryForward = false;
			
			super.destroy();
		}
		
		/**
		 * Add key in Map.
		 * 
		 * @param	key
		 * @param	engineClass
		 */
		internal function addInMap(key:String, engineClass:Class):void {
			if (_navigationMap[key]) {
				throw new GameError(key + ' ' + GameError.E_EXISTING_KEY);
			} else {
				_navigationMap[key] = engineClass;
				_navigationStack.push(key);
			}
		}
		
		/**
		 * Update current location after successfully set new EngineObject.
		 * 
		 * @param	isAvailableForHistory
		 */
		internal function updateLocationAfterRequest(isAvailableForHistory:Boolean):void {
			_currentLocation = _requestedLocation;
			_navigationIndex = getNavigationIndexByKey(_currentLocation);
			
			if (!_isChangeByHistory) {
				if (isAvailableForHistory) {
					_historyStack.push(_currentLocation);
					
					if (_isHistoryForward) {
						_historyIndex++;
					} else {
						_historyIndex--;
					}
				}
			}
			
			dispatchChangeEvent();
			
			_isChangeByHistory = false;
			_onProcessing = false;
			_isHistoryForward = false;
		}
		
		/**
		 * Run the TimeLine.
		 */
		internal function runTimeLine():void {
			var firstKey:String;
			
			if (_navigationStack.length < 1) {
				throw new GameError(GameError.E_EMPTY_MAP);
			} else {
				firstKey = _navigationStack[0];
				
				_requestedLocation = null;
				_isChangeByHistory = false;
				_isHistoryForward = true;
				
				gotoKey(firstKey);
			}
		}
		
		/**
		 * Reports whether there is a previous element in the browsing history.
		 * 
		 * @return
		 */
		public function isHistoryBack():Boolean {
			return _historyIndex > 0;
		}
		
		/**
		 * Reports whether there is a next element in the browsing history.
		 * 
		 * @return
		 */
		public function isHistoryForward():Boolean {
			return _historyIndex < _historyStack.length - 1;
		}
		
		/**
		 * Navigates to the previous element in the browsing history.
		 */
		public function historyBack():void {
			var key:String;
			
			if (_historyIndex > 0) {
				_requestedLocation = null;
				_isChangeByHistory = true;
				_isHistoryForward = false;
				
				key = _historyStack[_historyIndex - 1];
				
				gotoKey(key);
			}
		}
		
		/**
		 * Navigates to the next element in the browsing history.
		 */
		public function historyForward():void {
			var key:String;
			
			if (_historyIndex < _historyStack.length - 1) {
				_requestedLocation = null;
				_isChangeByHistory = true;
				_isHistoryForward = true;
				
				key = _historyStack[_historyIndex + 1];
				
				gotoKey(key);
			}
		}
		
		/**
		 * Navigates to the previous element in the browsing TimeLine.
		 */
		public function timelineBack():void {
			var key:String;
			
			if (_navigationIndex > 0) {
				_requestedLocation = null;
				_isChangeByHistory = false;
				_isHistoryForward = true;
				
				key = _navigationStack[_navigationIndex - 1];
				
				gotoKey(key);
			}
		}
		
		/**
		 * Navigates to the next element in the browsing TimeLine.
		 */
		public function timelineForward():void {
			var key:String;
			
			if (_navigationIndex < _navigationStack.length - 1) {
				_requestedLocation = null;
				_isChangeByHistory = false;
				_isHistoryForward = true;
				
				key = _navigationStack[_navigationIndex + 1];
				
				gotoKey(key);
			}
		}
		
		/**
		 * Navigates to an element in the browsing TimeLine.
		 * 
		 * @param	key
		 */
		public function gotoTimeLine(key:String):void {
			_requestedLocation = null;
			_isChangeByHistory = false;
			_isHistoryForward = true;
			
			gotoKey(key);
		}
		
		/**
		 * Restart current object.
		 */
		public function restartCurrent():void {
			_requestedLocation = null;
			_isChangeByHistory = true;
			_isHistoryForward = true;
			
			gotoKey(_currentLocation);
		}
		
		
		/**
		 * Instantiate NavigationSystem.
		 */
		public static function getInstance():NavigationSystem {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new NavigationSystem();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
		
		
		/**
		 * @private
		 */
		public function get navigationLength():int {
			return _navigationStack.length;
		}
		
		/**
		 * @private
		 */
		public function get historyLength():int {
			return _historyStack.length;
		}
		
		/**
		 * @private
		 */
		public function get currentLocation():String {
			return _currentLocation;
		}
		
		/**
		 * @private
		 */
		public function get currentEngineClass():Class {
			return _currentEngineClass;
		}
		
		/**
		 * @private
		 */
		public function get onProcessing():Boolean {
			return _onProcessing;
		}
	}
}