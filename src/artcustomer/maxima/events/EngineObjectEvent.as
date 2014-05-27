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
	 * EngineObjectEvent
	 * 
	 * @author David Massenot
	 */
	public class EngineObjectEvent extends Event {
		public static const ON_ENTRY:String = 'onEntry';
		public static const ON_EXIT:String = 'onExit';
		public static const ON_RESTART:String = 'onRestart';
		
		private var _object:AbstractEngineObject;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	object
		 */
		public function EngineObjectEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, object:AbstractEngineObject = null) {
			_object = object;
			
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clone EngineObjectEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new EngineObjectEvent(type, bubbles, cancelable, _object);
		}
		
		/**
		 * Get String format of EngineObjectEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("EngineObjectEvent", "type", "bubbles", "cancelable", "eventPhase", "object"); 
		}
		
		
		/**
		 * @private
		 */
		public function get object():AbstractEngineObject {
			return _object;
		}
	}
}