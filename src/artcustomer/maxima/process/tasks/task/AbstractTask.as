/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.process.tasks.task {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.base.IDestroyable;
	import artcustomer.maxima.errors.IllegalGameError;
	import artcustomer.maxima.process.tasks.events.TaskEvent;
	
	[Event(name = "onStartTask", type = "artcustomer.maxima.tasks.events.TaskEvent")]
	[Event(name = "onEndTask", type = "artcustomer.maxima.tasks.events.TaskEvent")]
	[Event(name = "onErrorTask", type = "artcustomer.maxima.tasks.events.TaskEvent")]
	
	
	/**
	 * AbstractTask
	 * 
	 * @author David Massenot
	 */
	public class AbstractTask extends EventDispatcher implements IDestroyable {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.process.tasks.task::AbstractTask';
		
		protected var _description:String;
		protected var _data:Object;
		
		private var _index:int;
		
		private var _allowSetIndex:Boolean;
		private var _allowSetData:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractTask() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_ABSTRACT_CLASS);
			
			_allowSetIndex = true;
			_allowSetData = true;
		}
		
		
		/**
		 * Start Task. Override it and call it at begin !
		 */
		public function start():void {
			this.dispatchEvent(new TaskEvent(TaskEvent.ON_START_TASK, false, false, _index, _description));
		}
		
		/**
		 * Stop Task. Override it and call it at end !
		 */
		public function stop():void {
			this.dispatchEvent(new TaskEvent(TaskEvent.ON_END_TASK, false, false, _index, _description));
		}
		
		/**
		 * Notify error.
		 * 
		 * @param	error
		 * @param	mandatory
		 */
		public function notifyError(error:String, mandatory:Boolean = false):void {
			this.dispatchEvent(new TaskEvent(TaskEvent.ON_ERROR_TASK, false, false, _index, _description, error));
		}
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			_index = 0;
			_data = null;
			_description = null;
		}
		
		
		/**
		 * @private
		 */
		public function get index():int {
			return _index;
		}
		
		/**
		 * @private
		 */
		public function set index(value:int):void {
			if (_allowSetIndex) {
				_allowSetIndex = false;
				_index = value;
			}
		}
		
		/**
		 * @private
		 */
		public function set data(value:Object):void {
			if (_allowSetData) {
				_allowSetData = false;
				_data = value;
			}
		}
		
		/**
		 * @private
		 */
		public function get description():String {
			return _description;
		}
	}
}