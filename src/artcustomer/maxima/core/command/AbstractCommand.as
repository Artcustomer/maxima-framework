/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core.command {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.context.IGameContext;
	import artcustomer.maxima.core.model.AbstractModel;
	import artcustomer.maxima.errors.*;
	
	
	/**
	 * AbstractCommand
	 * 
	 * @author David Massenot
	 */
	public class AbstractCommand {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.core.command::AbstractCommand';
		
		private var _id:String;
		private var _allowSetContext:Boolean;
		
		protected var _context:IGameContext;
		
		
		/**
		 * Constructor
		 * 
		 * @param	pID
		 */
		public function AbstractCommand(pID:String) {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_COMMAND_CONSTRUCTOR);
			if (!pID) throw new GameError(GameError.E_NULL_COMMAND_ID);
			
			_id = pID;
			_allowSetContext = true;
		}
		
		
		/**
		 * Helper. Get Model by id.
		 * 
		 * @param	id
		 * @return
		 */
		protected function getModel(id:String):AbstractModel {
			return _context.instance.logicEngine.getModel(id);
		}
		
		/**
		 * Setup Command. Must be overrided and called at first in child !
		 */
		public function setup():void {
			
		}
		
		/**
		 * Destroy Command. Must be overrided and called at last in child !
		 */
		public function destroy():void {
			_id = null;
			_allowSetContext = false;
			_context = null;
		}
		
		/**
		 * Execute Command. Must be overrided !
		 */
		public function execute(event:Event):void {
			throw new IllegalGameError(IllegalGameError.E_COMMAND_EXECUTE);
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
		public function get id():String {
			return _id;
		}
	}
}