/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.events {
	import flash.events.Event;
	
	
	/**
	 * GameErrorEvent
	 * 
	 * @author David Massenot
	 */
	public class GameErrorEvent extends Event {
		public static const ERROR:String = 'error';
		public static const GAME_ERROR:String = 'gameError';
		public static const ILLEGAL_ERROR:String = 'illegalError';
		
		private var _error:Error;
		private var _errorName:String;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	error
		 * @param	errorName
		 */
		public function GameErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, error:Error = null, errorName:String = null) {
			_error = error;
			_errorName = errorName;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone GameErrorEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new GameErrorEvent(type, bubbles, cancelable, _error, _errorName);
		}
		
		/**
		 * Get String value of GameErrorEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("GameErrorEvent", "type", "bubbles", "cancelable", "eventPhase", "error", "errorName"); 
		}
		
		
		/**
		 * @private
		 */
		public function get error():Error {
			return _error;
		}
		
		/**
		 * @private
		 */
		public function get errorName():String {
			return _errorName;
		}
	}
}