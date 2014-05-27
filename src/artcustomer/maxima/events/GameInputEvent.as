/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.events {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	import artcustomer.maxima.context.IGameContext;
	
	
	/**
	 * GameInputEvent
	 * 
	 * @author David Massenot
	 */
	public class GameInputEvent extends Event {
		public static const INPUT_KEY_PRESS:String = 'inputKeyPress';
		public static const INPUT_KEY_RELEASE:String = 'inputKeyRelease';
		public static const INPUT_KEY_REPEAT:String = 'inputKeyRepeat';
		public static const INPUT_KEY_FAST_REPEAT:String = 'inputKeyFastRepeat';
		
		public static const INPUT_MOUSE_ROLL_OVER:String = 'inputMouseRollOver';
		public static const INPUT_MOUSE_ROLL_OUT:String = 'inputMouseRollOut';
		public static const INPUT_MOUSE_OVER:String = 'inputMouseOver';
		public static const INPUT_MOUSE_OUT:String = 'inputMouseOut';
		public static const INPUT_MOUSE_MOVE:String = 'inputMouseMove';
		public static const INPUT_MOUSE_DOWN:String = 'inputMouseDown';
		public static const INPUT_MOUSE_UP:String = 'inputMouseUp';
		public static const INPUT_MOUSE_CLICK:String = 'inputMouseClick';
		public static const INPUT_MOUSE_DOUBLECLICK:String = 'inputMouseDoubleClick';
		public static const INPUT_MOUSE_WHEEL_UP:String = 'inputMouseWheelUp';
		public static const INPUT_MOUSE_WHEEL_DOWN:String = 'inputMouseWheelDown';
		public static const INPUT_MOUSE_LEAVE:String = 'inputMouseLeave';
		
		public static const INPUT_TOUCH_BEGIN:String = 'inputTouchBegin';
		public static const INPUT_TOUCH_END:String = 'inputTouchEnd';
		public static const INPUT_TOUCH_MOVE:String = 'inputTouchMove';
		public static const INPUT_TOUCH_TAP:String = 'inputTouchTap';
		
		public static const INPUT_PAD_PRESS:String = 'inputPadPress';
		public static const INPUT_PAD_RELEASE:String = 'inputPadRelease';
		public static const INPUT_PAD_REPEAT:String = 'inputPadRepeat';
		public static const INPUT_PAD_FAST_REPEAT:String = 'inputPadFastRepeat';
		
		private var _context:IGameContext;
		private var _nativeEvent:Event;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	context
		 * @param	nativeEvent
		 */
		public function GameInputEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, context:IGameContext = null, nativeEvent:Event = null) {
			_context = context;
			_nativeEvent = nativeEvent;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone GameInputEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new GameInputEvent(type, bubbles, cancelable, _context, _nativeEvent);
		}
		
		/**
		 * Get String value of GameInputEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("GameInputEvent", "type", "bubbles", "cancelable", "eventPhase", "context", "nativeEvent");
		}
		
		
		/**
		 * @private
		 */
		public function get context():IGameContext {
			return _context;
		}
		
		/**
		 * @private
		 */
		public function get nativeEvent():Event {
			return _nativeEvent;
		}
	}
}