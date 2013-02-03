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
		//  Initialize
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function init():void {
			_keyInputCounter = 0;
			_keyInputRepeatDelay = 10;
			_keyInputFastRepeatDelay = 2;
			_isKeyReleased = false;
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
				case('mouseLeave'):
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
				case('rollOver'):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_ROLL_OVER, false, false, this, e));
					break;
					
				case('rollOut'):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_ROLL_OUT, false, false, this, e));
					break;
				
				case('mouseOver'):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_OVER, false, false, this, e));
					break;
					
				case('mouseOut'):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_OUT, false, false, this, e));
					break;
					
				case('mouseMove'):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_MOVE, false, false, this, e));
					break;
					
				case('mouseDown'):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_DOWN, false, false, this, e));
					break;
					
				case('mouseUp'):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_UP, false, false, this, e));
					break;
					
				case('click'):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_CLICK, false, false, this, e));
					break;
					
				case('doubleClick'):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_MOUSE_DOUBLECLICK, false, false, this, e));
					break;
					
				case('mouseWheel'):
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
			switch (e.type) {
				case('keyDown'):
					if (!_isKeyReleased) {
						this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_KEY_PRESS, false, false, this, e));
						
						_isKeyReleased = true;
					}
					
					_keyInputCounter++;
					
					if (_keyInputCounter % _keyInputRepeatDelay == 0) this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_KEY_REPEAT, false, false, this, e));
					if (_keyInputCounter % _keyInputFastRepeatDelay == 0) this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_KEY_FAST_REPEAT, false, false, this, e));
					break;
					
				case('keyUp'):
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
				case('touchBegin'):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_TOUCH_BEGIN, false, false, this, e));
					break;
					
				case('touchEnd'):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_TOUCH_END, false, false, this, e));
					break;
					
				case('touchMove'):
					this.dispatchEvent(new GameInputEvent(GameInputEvent.INPUT_TOUCH_MOVE, false, false, this, e));
					break;
					
				case('touchTap'):
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
			init();
			
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