/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.context {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.events.GestureEvent;
	import flash.events.TransformGestureEvent;
	import flash.utils.getQualifiedClassName;
	import flash.ui.Keyboard;
	
	import artcustomer.maxima.events.*;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.utils.*;
	
	[Event(name = "inputKeyRelease", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputKeyRepeat", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputKeyFastRepeat", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputMouseRollOver", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputMouseRollOut", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputMouseOver", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputMouseOut", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputMouseMove", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputMouseDown", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputMouseUp", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputMouseClick", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputMouseDoubleClick", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputMouseWheelUp", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputMouseWheelDown", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputMouseLeave", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputTouchBegin", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputTouchEnd", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputTouchMove", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "inputTouchTap", type = "artcustomer.maxima.events.GameInputEvent")]
	[Event(name = "deviceBack", type = "artcustomer.framework.events.DeviceInputsEvent")]
	[Event(name = "deviceSearch", type = "artcustomer.framework.events.DeviceInputsEvent")]
	[Event(name = "deviceMenu", type = "artcustomer.framework.events.DeviceInputsEvent")]
	[Event(name = "deviceHome", type = "artcustomer.framework.events.DeviceInputsEvent")]
	
	
	/**
	 * CrossPlatformInputsContext
	 * 
	 * @author David Massenot
	 */
	public class CrossPlatformInputsContext extends InteractiveContext {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.context::CrossPlatformInputsContext';
		
		private var _keyInputCounter:int;
		private var _keyInputRepeatDelay:int;
		private var _keyInputFastRepeatDelay:int;
		
		private var _isKeyReleased:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function CrossPlatformInputsContext() {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_CROSSPLATFORMINPUTSCONTEXT_CONSTRUCTOR);
		}
		
		//---------------------------------------------------------------------
		//  StageEvents
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function listenStageEvents():void {
			this.contextView.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleStageKeys, false, 0, true);
			this.contextView.stage.addEventListener(KeyboardEvent.KEY_UP, handleStageKeys, false, 0, true);
			this.contextView.stage.addEventListener(Event.MOUSE_LEAVE, handleStage, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.ROLL_OUT, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.ROLL_OVER, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.MOUSE_OVER, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.MOUSE_OUT, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.MOUSE_WHEEL, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.MOUSE_DOWN, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.MOUSE_UP, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.CLICK, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.DOUBLE_CLICK, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(TouchEvent.TOUCH_BEGIN, handleStageTouch, false, 0, true);
			this.contextView.stage.addEventListener(TouchEvent.TOUCH_END, handleStageTouch, false, 0, true);
			this.contextView.stage.addEventListener(TouchEvent.TOUCH_MOVE, handleStageTouch, false, 0, true);
			this.contextView.stage.addEventListener(TouchEvent.TOUCH_TAP, handleStageTouch, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function unlistenStageEvents():void {
			this.contextView.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleStageKeys);
			this.contextView.stage.removeEventListener(KeyboardEvent.KEY_UP, handleStageKeys);
			this.contextView.stage.removeEventListener(Event.MOUSE_LEAVE, handleStage);
			this.contextView.stage.removeEventListener(MouseEvent.ROLL_OUT, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.ROLL_OVER, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.MOUSE_OVER, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.MOUSE_OUT, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.MOUSE_DOWN, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.MOUSE_UP, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.CLICK, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.DOUBLE_CLICK, handleStageMouse);
			this.contextView.stage.removeEventListener(TouchEvent.TOUCH_BEGIN, handleStageTouch);
			this.contextView.stage.removeEventListener(TouchEvent.TOUCH_END, handleStageTouch);
			this.contextView.stage.removeEventListener(TouchEvent.TOUCH_MOVE, handleStageTouch);
			this.contextView.stage.removeEventListener(TouchEvent.TOUCH_TAP, handleStageTouch);
			
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleStage(e:Event):void {
			switch (e.type) {
				case(Event.MOUSE_LEAVE):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_LEAVE, false, false, this, e));
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleStageMouse(e:MouseEvent):void {
			switch (e.type) {
				case(MouseEvent.ROLL_OVER):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_ROLL_OVER, false, false, this, e));
					break;
					
				case(MouseEvent.ROLL_OUT):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_ROLL_OUT, false, false, this, e));
					break;
				
				case(MouseEvent.MOUSE_OVER):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_OVER, false, false, this, e));
					break;
					
				case(MouseEvent.MOUSE_OUT):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_OUT, false, false, this, e));
					break;
					
				case(MouseEvent.MOUSE_MOVE):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_MOVE, false, false, this, e));
					break;
					
				case(MouseEvent.MOUSE_DOWN):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_DOWN, false, false, this, e));
					break;
					
				case(MouseEvent.MOUSE_UP):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_UP, false, false, this, e));
					break;
					
				case(MouseEvent.CLICK):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_CLICK, false, false, this, e));
					break;
					
				case(MouseEvent.DOUBLE_CLICK):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_DOUBLECLICK, false, false, this, e));
					break;
					
				case(MouseEvent.MOUSE_WHEEL):
					if (e.delta > 0) {
						this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_WHEEL_UP, false, false, this, e));
					} else {
						this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_WHEEL_DOWN, false, false, this, e));
					}
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleStageKeys(e:KeyboardEvent):void {
			var callPreventDefault:Boolean = false;
			
			switch (e.type) {
				case(KeyboardEvent.KEY_DOWN):
					if (!_isKeyReleased) {
						if (e.keyCode == Keyboard.MENU) {
							this.dispatchEvent(new DeviceInputsEvent(DeviceInputsEvent.DEVICE_MENU, false, false, e, e.keyCode, e.charCode));
							callPreventDefault = true;
						}
						
						if (e.keyCode == Keyboard.BACK) {
							this.dispatchEvent(new DeviceInputsEvent(DeviceInputsEvent.DEVICE_BACK, false, false, e, e.keyCode, e.charCode));
							callPreventDefault = true;
						}
						
						if (e.keyCode == Keyboard.SEARCH) {
							this.dispatchEvent(new DeviceInputsEvent(DeviceInputsEvent.DEVICE_SEARCH, false, false, e, e.keyCode, e.charCode));
							callPreventDefault = true;
						}
						
						if (e.keyCode == Keyboard.HOME) {
							this.dispatchEvent(new DeviceInputsEvent(DeviceInputsEvent.DEVICE_HOME, false, false, e, e.keyCode, e.charCode));
							callPreventDefault = true;
						}
						
						this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_KEY_PRESS, false, false, this, e));
						
						if (callPreventDefault) e.preventDefault();
						
						_isKeyReleased = true;
					}
					
					++_keyInputCounter;
					
					if (_keyInputCounter % _keyInputRepeatDelay == 0) this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_KEY_REPEAT, false, false, this, e));
					if (_keyInputCounter % _keyInputFastRepeatDelay == 0) this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_KEY_FAST_REPEAT, false, false, this, e));
					break;
					
				case(KeyboardEvent.KEY_UP):
					_keyInputCounter = 0;
					_isKeyReleased = false;
					
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_KEY_RELEASE, false, false, this, e));
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleStageTouch(e:TouchEvent):void {
			switch (e.type) {
				case(TouchEvent.TOUCH_BEGIN):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_TOUCH_BEGIN, false, false, this, e));
					break;
					
				case(TouchEvent.TOUCH_END):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_TOUCH_END, false, false, this, e));
					break;
					
				case(TouchEvent.TOUCH_MOVE):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_TOUCH_MOVE, false, false, this, e));
					break;
					
				case(TouchEvent.TOUCH_TAP):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_TOUCH_TAP, false, false, this, e));
					break;
					
				default:
					break;
			}
		}
		
		
		/**
		 * Setup CrossPlatformInputsContext.
		 */
		override public function setup():void {
			_keyInputCounter = 0;
			_keyInputRepeatDelay = 10;
			_keyInputFastRepeatDelay = 2;
			_isKeyReleased = false;
			
			super.setup();
			
			listenStageEvents();
		}
		
		/**
		 * Destroy CrossPlatformInputsContext.
		 */
		override public function destroy():void {
			unlistenStageEvents();
			
			_keyInputCounter = 0;
			_keyInputRepeatDelay = 0;
			_keyInputFastRepeatDelay = 0;
			_isKeyReleased = false;
			
			super.destroy();
		}
		
		
		/**
		 * @private
		 */
		public function set keyInputRepeatDelay(value:int):void {
			_keyInputRepeatDelay = value;
		}
		
		/**
		 * @private
		 */
		public function get keyInputRepeatDelay():int {
			return _keyInputRepeatDelay;
		}
		
		/**
		 * @private
		 */
		public function set keyInputFastRepeatDelay(value:int):void {
			_keyInputFastRepeatDelay = value;
		}
		
		/**
		 * @private
		 */
		public function get keyInputFastRepeatDelay():int {
			return _keyInputFastRepeatDelay;
		}
	}
}