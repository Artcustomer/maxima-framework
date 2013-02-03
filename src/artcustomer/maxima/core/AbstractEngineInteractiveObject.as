/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core {
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.engine.inputs.controls.IGameControl;
	import artcustomer.maxima.engine.inputs.controls.table.ControlTable;
	import artcustomer.maxima.errors.*;
	
	
	/**
	 * AbstractEngineInteractiveObject
	 * 
	 * @author David Massenot
	 */
	public class AbstractEngineInteractiveObject extends AbstractEngineObject {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.core::AbstractEngineInteractiveObject';
		
		private var _onFocus:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractEngineInteractiveObject() {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_ABSTRACT_CLASS);
			
			_onFocus = true;
		}
		
		
		/**
		 * Entry point. Override it !
		 */
		override protected function onEntry():void {
			// 
			
			super.onEntry();
		}
		
		/**
		 * Exit point. Override it !
		 */
		override protected function onExit():void {
			// 
			
			super.onExit();
		}
		
		/**
		 * Destructor. Must be overrided !
		 */
		override protected function destroy():void {
			_onFocus = false;
			
			super.destroy();
		}
		
		/**
		 * Map control in DirectInputEngine.
		 * 
		 * @param	action
		 * @param	table
		 */
		protected final function mapControl(action:String, table:ControlTable):void {
			this.context.instance.directInputEngine.mapControl(this.name, action, table);
		}
		
		/**
		 * Unmap control in DirectInputEngine.
		 * 
		 * @param	action
		 */
		protected final function unmapControl(action:String):void {
			this.context.instance.directInputEngine.unmapControl(this.name, action);
		}
		
		/**
		 * On control pressed. Override it !
		 * 
		 * @param	control
		 */
		protected function onControlPressed(control:IGameControl):void {
			
		}
		
		/**
		 * On control released. Override it !
		 * 
		 * @param	control
		 */
		protected function onControlReleased(control:IGameControl):void {
			
		}
		
		/**
		 * On control repeated. Override it !
		 * 
		 * @param	control
		 */
		protected function onControlRepeated(control:IGameControl):void {
			
		}
		
		/**
		 * On control fast repeated. Override it !
		 * 
		 * @param	control
		 */
		protected function onControlFastRepeated(control:IGameControl):void {
			
		}
		
		/**
		 * Inject control into object (called by EngineObjectManager)
		 * 
		 * @param	method
		 * @param	control
		 */
		internal function injectControl(method:String, control:IGameControl):void {
			var closure:Function = this[method];
			
			if (_onFocus && closure != null) closure.call(null, control);
		}
		
		/**
		 * @private
		 */
		internal function set focus(value:Boolean):void {
			_onFocus = value;
		}
	}
}