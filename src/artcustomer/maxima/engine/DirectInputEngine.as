/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine {
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	import artcustomer.maxima.context.*;
	import artcustomer.maxima.core.*;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.events.DirectInputEvent;
	import artcustomer.maxima.engine.inputs.controls.*;
	import artcustomer.maxima.engine.inputs.controls.table.ControlTable;
	import artcustomer.maxima.engine.inputs.controls.map.GameControlsMap;
	import artcustomer.maxima.events.GameInputEvent;
	import artcustomer.maxima.utils.consts.ControlType;
	
	[Event(name="onControlPressed", type="artcustomer.maxima.events.DirectInputEvent")]
	[Event(name="onControlReleased", type="artcustomer.maxima.events.DirectInputEvent")]
	[Event(name="onControlRepeated", type="artcustomer.maxima.events.DirectInputEvent")]
	[Event(name="onControlFastRepeated", type="artcustomer.maxima.events.DirectInputEvent")]
	
	
	/**
	 * DirectInputEngine
	 * 
	 * @author David Massenot
	 */
	public class DirectInputEngine extends AbstractCoreEngine {
		private static var __instance:DirectInputEngine;
		private static var __allowInstantiation:Boolean;
		
		private var _gameControlsMap:GameControlsMap;
		
		
		/**
		 * Constructor
		 */
		public function DirectInputEngine() {
			super();
			
			if (!__allowInstantiation) {
				throw new GameError(GameError.E_SCOREENGINE_CREATE);
				
				return;
			}
		}
		
		//---------------------------------------------------------------------
		//  Events
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function listenEvents():void {
			this.context.addEventListener(GameInputEvent.INPUT_KEY_PRESS, handleInputs, false, 0, true);
			this.context.addEventListener(GameInputEvent.INPUT_KEY_RELEASE, handleInputs, false, 0, true);
			this.context.addEventListener(GameInputEvent.INPUT_KEY_REPEAT, handleInputs, false, 0, true);
			this.context.addEventListener(GameInputEvent.INPUT_KEY_FAST_REPEAT, handleInputs, false, 0, true);
			this.context.addEventListener(GameInputEvent.INPUT_MOUSE_CLICK, handleInputs, false, 0, true);
			this.context.addEventListener(GameInputEvent.INPUT_MOUSE_DOUBLECLICK, handleInputs, false, 0, true);
			this.context.addEventListener(GameInputEvent.INPUT_MOUSE_DOWN, handleInputs, false, 0, true);
			this.context.addEventListener(GameInputEvent.INPUT_MOUSE_UP, handleInputs, false, 0, true);
			this.context.addEventListener(GameInputEvent.INPUT_TOUCH_BEGIN, handleInputs, false, 0, true);
			this.context.addEventListener(GameInputEvent.INPUT_TOUCH_END, handleInputs, false, 0, true);
			this.context.addEventListener(GameInputEvent.INPUT_TOUCH_MOVE, handleInputs, false, 0, true);
			this.context.addEventListener(GameInputEvent.INPUT_TOUCH_TAP, handleInputs, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function unlistenEvents():void {
			this.context.removeEventListener(GameInputEvent.INPUT_KEY_PRESS, handleInputs);
			this.context.removeEventListener(GameInputEvent.INPUT_KEY_RELEASE, handleInputs);
			this.context.removeEventListener(GameInputEvent.INPUT_KEY_REPEAT, handleInputs);
			this.context.removeEventListener(GameInputEvent.INPUT_KEY_FAST_REPEAT, handleInputs);
			this.context.removeEventListener(GameInputEvent.INPUT_MOUSE_CLICK, handleInputs);
			this.context.removeEventListener(GameInputEvent.INPUT_MOUSE_DOUBLECLICK, handleInputs);
			this.context.removeEventListener(GameInputEvent.INPUT_MOUSE_DOWN, handleInputs);
			this.context.removeEventListener(GameInputEvent.INPUT_MOUSE_UP, handleInputs);
			this.context.removeEventListener(GameInputEvent.INPUT_TOUCH_BEGIN, handleInputs);
			this.context.removeEventListener(GameInputEvent.INPUT_TOUCH_END, handleInputs);
			this.context.removeEventListener(GameInputEvent.INPUT_TOUCH_MOVE, handleInputs);
			this.context.removeEventListener(GameInputEvent.INPUT_TOUCH_TAP, handleInputs);
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleInputs(e:GameInputEvent):void {
			var keyCode:String;
			var controlType:String;
			var eventType:String;
			
			switch (e.type) {
				case(GameInputEvent.INPUT_KEY_PRESS):
					keyCode = (e.nativeEvent as KeyboardEvent).keyCode.toString();
					controlType = ControlType.KEYBOARD;
					eventType = DirectInputEvent.ON_CONTROL_PRESSED;
					break;
					
				case(GameInputEvent.INPUT_KEY_RELEASE):
					keyCode = (e.nativeEvent as KeyboardEvent).keyCode.toString();
					controlType = ControlType.KEYBOARD;
					eventType = DirectInputEvent.ON_CONTROL_RELEASED;
					break;
					
				case(GameInputEvent.INPUT_KEY_REPEAT):
					keyCode = (e.nativeEvent as KeyboardEvent).keyCode.toString();
					controlType = ControlType.KEYBOARD;
					eventType = DirectInputEvent.ON_CONTROL_REPEATED;
					break;
					
				case(GameInputEvent.INPUT_KEY_FAST_REPEAT):
					keyCode = (e.nativeEvent as KeyboardEvent).keyCode.toString();
					controlType = ControlType.KEYBOARD;
					eventType = DirectInputEvent.ON_CONTROL_FAST_REPEATED;
					break;
					
				case(GameInputEvent.INPUT_MOUSE_CLICK):
				case(GameInputEvent.INPUT_MOUSE_DOUBLECLICK):
				case(GameInputEvent.INPUT_MOUSE_DOWN):
				case(GameInputEvent.INPUT_MOUSE_UP):
					keyCode = e.nativeEvent.type;
					controlType = ControlType.MOUSE;
					eventType = DirectInputEvent.ON_CONTROL_RELEASED;
					break;
					
				case(GameInputEvent.INPUT_TOUCH_BEGIN):
				case(GameInputEvent.INPUT_TOUCH_END):
				case(GameInputEvent.INPUT_TOUCH_MOVE):
				case(GameInputEvent.INPUT_TOUCH_TAP):
					keyCode = e.nativeEvent.type;
					controlType = ControlType.TOUCHSCREEN;
					eventType = DirectInputEvent.ON_CONTROL_RELEASED;
					break;
					
				default:
					keyCode = null;
					controlType = null;
					eventType = null;
					break;
			}
			
			if (keyCode) processToControlInjection(eventType, controlType, keyCode);
		}
		
		//---------------------------------------------------------------------
		//  GameControlsMap
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupGameControlsMap():void {
			_gameControlsMap = new GameControlsMap();
		}
		
		/**
		 * @private
		 */
		private function destroyGameControlsMap():void {
			_gameControlsMap.destroy();
			_gameControlsMap = null;
		}
		
		/**
		 * @private
		 */
		private function addControlInGameControlsMap(action:String, table:ControlTable):void {
			_gameControlsMap.addControl(action, table);
		}
		
		/**
		 * @private
		 */
		private function removeControlInGameControlsMap(action:String):void {
			_gameControlsMap.removeControl(action);
		}
		
		/**
		 * @private
		 */
		private function getControlByKeyInGameControlsMap(keyCode:String, controlType:String):String {
			return _gameControlsMap.getControlByKey(keyCode, controlType);
		}
		
		//---------------------------------------------------------------------
		//  Injection
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function processToControlInjection(eventType:String, controlType:String, inputCode:String):void {
			var action:String;
			var gameControl:IGameControl;
			var isValidControl:Boolean;
			
			action = getControlByKeyInGameControlsMap(inputCode, controlType);
			
			if (!action) return;
			
			switch (controlType) {
				case(ControlType.KEYBOARD):
					gameControl = new KeyboardControl();
					isValidControl = true;
					break;
					
				case(ControlType.MOUSE):
					gameControl = new MouseControl();
					isValidControl = true;
					break;
					
				case(ControlType.TOUCHSCREEN):
					gameControl = new TouchScreenControl();
					isValidControl = true;
					break;
					
				case(ControlType.GAMEPAD):
					gameControl = new GamepadControl();
					isValidControl = true;
					break;
					
				default:
					isValidControl = false;
					break;
			}
			
			if (isValidControl) {
				(gameControl as AbstractGameControl).action = action;
				(gameControl as AbstractGameControl).inputCode = inputCode;
				
				if (this.context.instance.gameEngine.currentEngineObject) _injector.injectControl(this.context.instance.gameEngine.currentEngineObject, gameControl, eventType);
				
				this.dispatchEvent(new DirectInputEvent(eventType, false, false, gameControl, inputCode));
			}
		}
		
		
		/**
		 * Entry point.
		 */
		override internal function setup():void {
			if (this.isSetup) return;
			
			super.setup();
			
			listenEvents();
			setupGameControlsMap();
		}
		
		/**
		 * Destructor
		 */
		override internal function destroy():void {
			destroyGameControlsMap();
			unlistenEvents();
			
			super.destroy();
		}
		
		/**
		 * Map control.
		 * 
		 * @param	objectName
		 * @param	action
		 * @param	table
		 */
		public function mapControl(objectName:String, action:String, table:ControlTable):void {
			addControlInGameControlsMap(action, table);
		}
		
		/**
		 * Unmap control.
		 * 
		 * @param	objectName
		 * @param	action
		 */
		public function unmapControl(objectName:String, action:String):void {
			removeControlInGameControlsMap(action);
		}
		
		
		/**
		 * Instantiate DirectInputEngine.
		 */
		public static function getInstance():DirectInputEngine {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new DirectInputEngine();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
	}
}