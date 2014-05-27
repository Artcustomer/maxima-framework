/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.utils {
	import flash.utils.*;
	
	
	/**
	 * TimeOut
	 * 
	 * @author David Massenot
	 */
	public class TimeOut {
		private var _timeout:uint;
		private var _closure:Function;
		private var _isCleared:Boolean;
		
		
		/**
		 * Constructor
		 * 
		 * @param	pClosure
		 * @param	pDelay
		 * @param	pArgs
		 */
		public function TimeOut(pClosure:Function, pDelay:Number, pArgs:Array = null) {
			_closure = pClosure;
			_isCleared = false;
			_timeout = setTimeout(callback, pDelay, pArgs);
		}
		
		/**
		 * TimeOut callback.
		 * 
		 * @param	pArgs
		 */
		private function callback(pArgs:Array = null):void {
			_closure.apply(null, pArgs);
			_isCleared = true;
			
			clearTimeout(_timeout);
		}
		
		
		/**
		 * Clear TimeOut (if running)
		 */
		public function clear():void {
			if (!_isCleared) clearTimeout(_timeout);
		}
	}
}