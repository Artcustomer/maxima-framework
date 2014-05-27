/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.utils.net.events {
	import flash.events.Event;
	
	
	/**
	 * InternetConnectionCheckerEvent
	 * 
	 * @author David Massenot
	 */
	public class InternetConnectionCheckerEvent extends Event {
		public static const ON_SERVICE_AVAILABLE:String = 'onServiceAvailable';
		public static const ON_SERVICE_UNAVAILABLE:String = 'onServiceUnavailable';
		
		private var _isAvailable:Boolean;
		private var _code:String;
		private var _level:String;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	isAvailable
		 * @param	code
		 * @param	level
		 */
		public function InternetConnectionCheckerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, isAvailable:Boolean = false, code:String = null, level:String = null) {
			super(type, bubbles, cancelable);
			
			_isAvailable = isAvailable;
			_code = code;
			_level = level;
		}
		
		/**
		 * Clone InternetConnectionCheckerEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new InternetConnectionCheckerEvent(type, bubbles, cancelable, _isAvailable, _code, _level);
		}
		
		/**
		 * Get String format of InternetConnectionCheckerEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("InternetConnectionCheckerEvent", "type", "bubbles", "cancelable", "eventPhase", "isAvailable", "code", "level"); 
		}
		
		
		/**
		 * @private
		 */
		public function get isAvailable():Boolean {
			return _isAvailable;
		}
		
		/**
		 * @private
		 */
		public function get code():String {
			return _code;
		}
		
		/**
		 * @private
		 */
		public function get level():String {
			return _level;
		}
	}
}