/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine.inputs.controls.table.builder {
	import artcustomer.maxima.base.IDestroyable;
	import artcustomer.maxima.engine.inputs.controls.table.ControlTable;
	import artcustomer.maxima.utils.tools.StringTools;
	
	
	/**
	 * ControlTableBuilder
	 * 
	 * @author David Massenot
	 */
	public class ControlTableBuilder implements IDestroyable {
		private var _stack:Array;
		
		private var _numControls:int;
		
		
		/**
		 * Constructor
		 */
		public function ControlTableBuilder() {
			createStack();
		}
		
		//---------------------------------------------------------------------
		//  Stack
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function createStack():void {
			_stack = new Array();
		}
		
		/**
		 * @private
		 */
		private function releaseStack():void {
			while (_stack.length > 0) {
				_stack.shift();
			}
		}
		
		/**
		 * @private
		 */
		private function destroyStack():void {
			_stack = null;
		}
		
		
		/**
		 * Destructor
		 */
		public function destroy():void {
			releaseStack();
			destroyStack();
			
			_numControls = 0;
		}
		
		/**
		 * Clear.
		 */
		public function clear():void {
			releaseStack();
			
			_numControls = 0;
		}
		
		/**
		 * Get String format of object.
		 * 
		 * @return
		 */
		public function toString():String {
			return StringTools.formatToString(this, 'ControlTableBuilder', 'numControls');
		}
		
		/**
		 * Add control.
		 * 
		 * @param	controlType : Control type (available as const in ControlType class)
		 * @param	keyCode : KeyCode in String value
		 */
		public function addControl(controlType:String, keyCode:String):void {
			var control:Object = new Object();
			control.controlType = controlType;
			control.keyCode = keyCode;
			
			_stack.push(control);
			_numControls++;
		}
		
		/**
		 * Assemble table with controls.
		 * 
		 * @return
		 */
		public function assemble():ControlTable {
			var table:ControlTable = new ControlTable();
			var control:Object;
			var i:int = 0;
			var length:int = _stack.length;
			
			for (i ; i < length ; i++) {
				control = _stack[i];
				
				table.addControl(control.controlType, control.keyCode);
			}
			
			return table;
		}
		
		
		/**
		 * @private
		 */
		public function get numControls():int {
			return _numControls;
		}
	}
}