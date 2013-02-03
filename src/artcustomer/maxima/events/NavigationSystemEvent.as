/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.events {
	import flash.events.Event;
	
	import artcustomer.maxima.core.AbstractEngineObject;
	
	
	/**
	 * NavigationSystemEvent
	 * 
	 * @author David Massenot
	 */
	public class NavigationSystemEvent extends Event {
		public static const ON_LOCATION_REQUESTED:String = 'onLocationRequested';
		public static const ON_LOCATION_CHANGE:String = 'onLocationChange';
		public static const ON_LOCATION_NOT_FOUND:String = 'onLocationNotFound';
		public static const ON_SYSTEM_ERROR:String = 'onSystemError';
		
		private var _requestKey:String;
		private var _location:String;
		private var _error:String;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	requestKey
		 * @param	location
		 * @param	error
		 */
		public function NavigationSystemEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, requestKey:String = null, location:String = null, error:String = null) {
			_requestKey = requestKey;
			_location = location;
			_error = error;
			
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clone NavigationSystemEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new NavigationSystemEvent(type, bubbles, cancelable, _requestKey, _location, _error);
		}
		
		/**
		 * Get String format of NavigationSystemEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("NavigationSystemEvent", "type", "bubbles", "cancelable", "eventPhase", "requestKey", "location", "error"); 
		}
		
		
		/**
		 * @private
		 */
		public function get requestKey():String {
			return _requestKey;
		}
		
		/**
		 * @private
		 */
		public function get location():String {
			return _location;
		}
		
		/**
		 * @private
		 */
		public function get error():String {
			return _error;
		}
	}
}