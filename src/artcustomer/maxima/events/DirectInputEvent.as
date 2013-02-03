/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.events {
	import flash.events.Event;
	
	import artcustomer.maxima.engine.inputs.controls.IGameControl;
	
	
	/**
	 * DirectInputEvent
	 * 
	 * @author David Massenot
	 */
	public class DirectInputEvent extends Event {
		public static const ON_CONTROL_PRESSED:String = 'onControlPressed';
		public static const ON_CONTROL_RELEASED:String = 'onControlReleased';
		public static const ON_CONTROL_REPEATED:String = 'onControlRepeated';
		public static const ON_CONTROL_FAST_REPEATED:String = 'onControlFastRepeated';
		
		private var _gameControl:IGameControl;
		private var _keyCode:String;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	gameControl
		 * @param	keyCode
		 */
		public function DirectInputEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, gameControl:IGameControl = null, keyCode:String = null) {
			_gameControl = gameControl;
			_keyCode = keyCode;
			
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clone DirectInputEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new DirectInputEvent(type, bubbles, cancelable, _gameControl, _keyCode);
		}
		
		/**
		 * Get String format of DirectInputEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("DirectInputEvent", "type", "bubbles", "cancelable", "eventPhase", "gameControl", "keyCode"); 
		}
		
		
		/**
		 * @private
		 */
		public function get gameControl():IGameControl {
			return _gameControl;
		}
		
		/**
		 * @private
		 */
		public function get keyCode():String {
			return _keyCode;
		}
	}
}