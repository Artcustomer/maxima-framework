/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core.model {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.context.IGameContext;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.data.IViewData;
	
	
	/**
	 * AbstractModel
	 * 
	 * @author David Massenot
	 */
	public class AbstractModel {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.core.model::AbstractModel';
		
		private var _id:String;
		private var _updateCallback:Function;
		private var _allowSetContext:Boolean;
		private var _allowSetCallback:Boolean;
		
		protected var _context:IGameContext;
		
		
		/**
		 * Constructor
		 * 
		 * @param	pID
		 */
		public function AbstractModel(pID:String) {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_MODEL_CONSTRUCTOR);
			if (!pID) throw new GameError(GameError.E_NULL_MODEL_ID);
			
			_id = pID;
			_allowSetContext = true;
			_allowSetCallback = true;
		}
		
		
		/**
		 * Setup Model. Must be overrided and called at first in child !
		 */
		public function setup():void {
			
		}
		
		/**
		 * Destroy Model. Must be overrided and called at last in child !
		 */
		public function destroy():void {
			_id = null;
			_updateCallback = null;
			_allowSetContext = false;
			_context = null;
		}
		
		/**
		 * Send update
		 * 
		 * @param	data
		 * @param	type
		 */
		public function update(type:String, data:IViewData = null):void {
			_updateCallback.call(null, _id, data, type);
		}
		
		
		/**
		 * @private
		 */
		public function set context(value:IGameContext):void {
			if (_allowSetContext) {
				_context = value;
				_allowSetContext = false;
			}
		}
		
		/**
		 * @private
		 */
		public function set updateCallback(value:Function):void {
			if (_allowSetCallback) {
				_updateCallback = value;
				_allowSetCallback = false;
			}
		}
		
		/**
		 * @private
		 */
		public function get id():String {
			return _id;
		}
	}
}