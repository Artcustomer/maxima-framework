/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine.inputs.controls.map {
	import flash.utils.Dictionary;
	
	import artcustomer.maxima.base.IDestroyable;
	import artcustomer.maxima.engine.inputs.controls.table.ControlTable;
	
	
	/**
	 * GameControlsMap
	 * 
	 * @author David Massenot
	 */
	public class GameControlsMap implements IDestroyable {
		private var _map:Dictionary;
		
		private var _numControls:int;
		
		
		/**
		 * Constructor
		 */
		public function GameControlsMap() {
			_map = new Dictionary();
			
			_numControls = 0;
		}
		
		//---------------------------------------------------------------------
		//  Map
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function disposeMap():void {
			var id:String;
			
			for (id in _map) {
				if ((_map[id] as ControlTable) != null) (_map[id] as ControlTable).destroy();
				
				_map[id] = undefined;
				delete _map[id];
			}
		}
		
		
		/**
		 * Destructor
		 */
		public function destroy():void {
			disposeMap();
			
			_map = null;
			_numControls = 0;
		}
		
		/**
		 * Remove all controls.
		 */
		public function clear():void {
			disposeMap();
		}
		
		/**
		 * Add control in map.
		 * 
		 * @param	action
		 * @param	table
		 */
		public function addControl(action:String, table:ControlTable):void {
			if (!this.hasControl(action)) {
				_map[action] = table;
				
				_numControls++;
			}
		}
		
		/**
		 * Remove control in map.
		 * 
		 * @param	action
		 */
		public function removeControl(action:String):void {
			var table:ControlTable;
			
			if (this.hasControl(action)) {
				table = _map[action] as ControlTable;
				table.destroy();
				table = null;
				
				_map[action] = undefined;
				delete _map[action];
				
				_numControls--;
			}
		}
		
		/**
		 * Test control in map.
		 * 
		 * @param	action
		 * @return
		 */
		public function hasControl(action:String):Boolean {
			return _map[action] != undefined;
		}
		
		/**
		 * Get control by key code.
		 * 
		 * @param	keyCode
		 * @param	controlType
		 * @return
		 */
		public function getControlByKey(keyCode:String, controlType:String):String {
			var id:String;
			var table:ControlTable;
			
			for (id in _map) {
				table = _map[id] as ControlTable;
				
				if (table && table.hasControl(keyCode, controlType)) return id;
			}
			
			return null;
		}
		
		
		/**
		 * @private
		 */
		public function get numControls():int {
			return _numControls;
		}
	}
}