/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine.inputs.controls.table {
	import flash.utils.Dictionary;
	
	import artcustomer.maxima.base.IDestroyable;
	import artcustomer.maxima.utils.tools.StringTools;
	
	
	/**
	 * ControlTable
	 * 
	 * @author David MassenotDictionary
	 */
	public class ControlTable implements IDestroyable {
		private var _table:Dictionary;
		
		private var _numControls:int;
		
		
		/**
		 * Constructor
		 */
		public function ControlTable() {
			_table = new Dictionary();
			_numControls = 0;
		}
		
		//---------------------------------------------------------------------
		//  Table
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function disposeTable():void {
			var id:String;
			
			for (id in _table) {
				_table[id] = undefined;
				delete _table[id];
			}
		}
		
		
		/**
		 * Destructor
		 */
		public function destroy():void {
			disposeTable();
			
			_table = null;
			_numControls = 0;
		}
		
		/**
		 * Get String format of object.
		 * 
		 * @return
		 */
		public function toString():String {
			return StringTools.formatToString(this, 'ControlTable', 'numControls');
		}
		
		/**
		 * Add Control in table.
		 * 
		 * @param	controlType : Control type (available as const in ControlType class)
		 * @param	keyCode : KeyCode in String value
		 */
		public function addControl(controlType:String, keyCode:String):void {
			if (!hasControl(keyCode, controlType)) {
				_table[keyCode] = controlType;
				
				_numControls++;
			}
		}
		
		/**
		 * Remove control in table.
		 * 
		 * @param	keyCode
		 * @param	controlType
		 */
		public function removeControl(keyCode:String, controlType:String):void {
			if (hasControl(keyCode, controlType)) {
				_table[keyCode] = undefined;
				delete _table[keyCode];
				
				_numControls--;
			}
		}
		
		/**
		 * Test control in table.
		 * 
		 * @param	keyCode
		 * @param	controlType
		 * @return
		 */
		public function hasControl(keyCode:String, controlType:String):Boolean {
			return _table[keyCode] != undefined && _table[keyCode] == controlType;
		}
		
		
		/**
		 * @private
		 */
		public function get numControls():int {
			return _numControls;
		}
	}
}