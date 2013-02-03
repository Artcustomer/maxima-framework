/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine.inputs.controls {
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.utils.tools.StringTools;
	
	
	/**
	 * AbstractGameControl
	 * 
	 * @author David Massenot
	 */
	public class AbstractGameControl implements IGameControl {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.engine.inputs.controls::AbstractGameControl';
		
		protected var _type:String;
		protected var _action:String;
		protected var _inputCode:String;
		
		
		/**
		 * Constructor
		 */
		public function AbstractGameControl() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_ABSTRACT_CLASS);
		}
		
		
		/**
		 * Destructor
		 */
		public function destroy():void {
			_type = null;
			_action = null;
			_inputCode = null;
		}
		
		/**
		 * Get String format of object.
		 * 
		 * @return
		 */
		public function toString():String {
			return StringTools.formatToString(this, 'AbstractGameControl', 'type', 'action', 'inputCode');
		}
		
		
		/**
		 * @private
		 */
		public function get type():String {
			return _type;
		}
		
		/**
		 * @private
		 */
		public function set action(value:String):void {
			_action = value;
		}
		
		/**
		 * @private
		 */
		public function get action():String {
			return _action;
		}
		
		/**
		 * @private
		 */
		public function set inputCode(value:String):void {
			_inputCode = value;
		}
		
		/**
		 * @private
		 */
		public function get inputCode():String {
			return _inputCode;
		}
	}
}