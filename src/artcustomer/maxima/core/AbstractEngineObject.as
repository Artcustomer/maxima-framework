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
	import artcustomer.maxima.data.IViewData;
	import artcustomer.maxima.engine.NavigationSystem;
	
	[Event(name="onEntry", type="artcustomer.maxima.events.EngineObjectEvent")]
	[Event(name="onExit", type="artcustomer.maxima.events.EngineObjectEvent")]
	[Event(name="onRestart", type="artcustomer.maxima.events.EngineObjectEvent")]
	
	
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
		
		protected var _navigationSystem:NavigationSystem;
		protected var _isAvailableForHistory:Boolean;
		protected var _delayPostExit:Boolean;
		
		
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
		 * Inject back keyboard input.
		 */
		internal function onBack():void {
			this.onKeyBack();
		}
		
		/**
		 * Inject resize method on object.
		 */
		internal function callResize():void {
			this.resize();
		}
		
		/**
		 * Inject update method on object.
		 * 
		 * @param	id
		 * @param	data
		 * @param	type
		 */
		internal function callUpdate(id:String, data:IViewData, type:String):void {
			this.update(data, type);
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
			this.onPreEntry();
			this.onEntry();
		}
		
		/**
		 * Inject onExit destroy on object.
		 */
		internal function callExit():void {
			this.onExit();
			if (!_delayPostExit) this.onPostExit();
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
		 * Dispatch command to controller by ID
		 * 
		 * @param	commandID : Id of the controller
		 * @param	event : Event with params
		 */
		protected function dispatchCommand(commandID:String, event:Event):void {
			_context.instance.logicEngine.executeCommand(commandID, event);
		}
		
		/**
		 * Internal entry point. Override it and call it at first !
		 * Only for use in Maxima core elements !
		 */
		protected function onPreEntry():void {
			dispatchObjectEvent(EngineObjectEvent.ON_ENTRY);
		}
		
		/**
		 * Internal exit point. Override it and call it at end !
		 * Only for use in Maxima core elements !
		 * If you set this._delayPostExit at true, don't forget to call super.onPostExit() on your object to exit and continue navigation !
		 */
		protected function onPostExit():void {
			dispatchObjectEvent(EngineObjectEvent.ON_EXIT);
		}
		
		/**
		 * Entry point. Override it !
		 * No need to call super method !
		 */
		protected function onEntry():void {
			
		}
		
		/**
		 * Exit point. Override it !
		 * No need to call super method !
		 * You can delay object destruction by setting this._delayPostExit = true.
		 * With doing that, you must call super.onPostExit() to exit object and continue navigation !
		 */
		protected function onExit():void {
			
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
		 * When back key is released. Must be overrided !
		 */
		protected function onKeyBack():void {
			
		}
		
		/**
		 * Restart object.
		 */
		protected final function restart():void {
			dispatchObjectEvent(EngineObjectEvent.ON_RESTART);
		}
		
		/**
		 * Destructor. Must be overrided !
		 */
		protected function destroy():void {
			_context = null;
			_navigationSystem = null;
			_name = null;
			_allowSetContext = false;
			_allowSetName = false;
			_isAvailableForHistory = false;
			_delayPostExit = false;
		}
		
		/**
		 * Called when model is updated. Override it and don't call it !
		 * 
		 * @param	data
		 * @param	type
		 */
		public function update(data:IViewData, type:String):void {
			
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
				_navigationSystem = _context.instance.gameEngine.navigationSystem;
				
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