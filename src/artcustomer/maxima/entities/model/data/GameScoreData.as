/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.entities.model.data {
	import artcustomer.maxima.data.IViewData;
	import artcustomer.maxima.core.score.data.ScoreEntry;
	
	
	/**
	 * GameCoreData
	 * 
	 * @author David Massenot
	 */
	public class GameScoreData implements IViewData {
		private var _lastEntry:ScoreEntry;
		private var _data:Object;
		private var _type:String;
		private var _error:String;
		
		
		/**
		 * Constructor
		 */
		public function GameScoreData() {
			
		}
		
		/**
		 * Destructor
		 */
		public function destroy():void {
			_lastEntry = null;
			_data = null;
			_type = null;
			_error = null;
		}
		
		
		/**
		 * @private
		 */
		public function get lastEntry():ScoreEntry {
			return _lastEntry;
		}
		
		/**
		 * @private
		 */
		public function set lastEntry(value:ScoreEntry):void {
			_lastEntry = value;
		}
		
		/**
		 * @private
		 */
		public function get data():Object {
			return _data;
		}
		
		/**
		 * @private
		 */
		public function set data(value:Object):void {
			_data = value;
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
		public function set type(value:String):void {
			_type = value;
		}
		
		/**
		 * @private
		 */
		public function get error():String {
			return _error;
		}
		
		/**
		 * @private
		 */
		public function set error(value:String):void {
			_error = value;
		}
	}
}