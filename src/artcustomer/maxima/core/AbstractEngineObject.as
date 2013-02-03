/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.context.IGameContext;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.events.EngineObjectEvent;
	
	[Event(name="onEntry", type="artcustomer.maxima.events.EngineObjectEvent")]
	[Event(name="onExit", type="artcustomer.maxima.events.EngineObjectEvent")]
	
	
	/**
	 * AbstractEngineObject
	 * 
	 * @author David Massenot
	 */
	public class AbstractEngineObject extends EventDispatcher {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.core::AbstractEngineObject';
		
		private var _context:IGameContext;
		private var _name:String;
		
		private var _allowSetContext:Boolean;
		private var _allowSetName:Boolean;
		
		protected var _isAvailableForHistory:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractEngineObject() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_ABSTRACT_CLASS);
			
			_allowSetContext = true;
			_allowSetName = true;
			_isAvailableForHistory = true;
		}
		
		//---------------------------------------------------------------------
		//  Event Dispatching
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function dispatchObjectEvent(type:String):void {
			this.dispatchEvent(new EngineObjectEvent(type, false, false, this));
		}
		
		
		/**
		 * Inject resize methid on object.
		 */
		internal function callResize():void {
			this.resize();
		}
		
		/**
		 * Inject render method on object.
		 */
		internal function callRender():void {
			this.render();
		}
		
		/**
		 * Inject onEntry destroy on object.
		 */
		internal function callEntry():void {
			this.onEntry();
		}
		
		/**
		 * Inject onExit destroy on object.
		 */
		internal function callExit():void {
			this.onExit();
		}
		
		/**
		 * Inject destroy destroy on object.
		 */
		internal function callDestroy():void {
			this.destroy();
		}
		
		/**
		 * Get String format of object.
		 * 
		 * @param	object
		 * @param	className
		 * @param	...properties
		 * @return
		 */
		protected function formatToString(object:*, className:String, ...properties:*):String {
			var s:String = '[' + className;
			var prop:String;
			
			for (var i:int = 0 ; i < properties.length ; i++) {
				prop = properties[i];
				
				s += ' ' + prop + '=' + object[prop];
			}
			
			return s + ']';
        }
		
		/**
		 * Entry point. Override it and call it at end !
		 */
		protected function onEntry():void {
			dispatchObjectEvent(EngineObjectEvent.ON_ENTRY);
		}
		
		/**
		 * Exit point. Override it and call it at end !
		 */
		protected function onExit():void {
			dispatchObjectEvent(EngineObjectEvent.ON_EXIT);
		}
		
		/**
		 * Resize object. Must be overrided !
		 */
		protected function resize():void {
			
		}
		
		/**
		 * Render object. Must be overrided !
		 */
		protected function render():void {
			
		}
		
		/**
		 * Restart object.
		 */
		protected final function restart():void {
			this.context.instance.gameEngine.navigationSystem.restartCurrent();
		}
		
		/**
		 * Destructor. Must be overrided !
		 */
		protected function destroy():void {
			_context = null;
			_name = null;
			_allowSetContext = false;
			_allowSetName = false;
			_isAvailableForHistory = false;
		}
		
		/**
		 * Get String format of object.
		 * 
		 * @return
		 */
		override public function toString():String {
			return formatToString(this, 'AbstractEngineObject', 'name');
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
		public function get context():IGameContext {
			return _context;
		}
		
		/**
		 * @private
		 */
		public function set name(value:String):void {
			if (_allowSetName) {
				_name = value;
				
				_allowSetName = false;
			}
		}
		
		/**
		 * @private
		 */
		public function get name():String {
			return _name;
		}
		
		/**
		 * @private
		 */
		public function get isAvailableForHistory():Boolean {
			return _isAvailableForHistory;
		}
	}
}