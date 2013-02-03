/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core.score.data {
	import flash.utils.Dictionary;
	
	import artcustomer.maxima.base.IDestroyable;
	import artcustomer.maxima.core.score.data.ScoreEntry;
	import artcustomer.maxima.utils.consts.GameUniverse;
	import artcustomer.maxima.utils.tools.StringTools;
	
	
	/**
	 * ScoreDataBase : Framework local database.
	 * 
	 * @author David Massenot
	 */
	public class ScoreDataBase implements IDestroyable {
		private var _dataBase:Dictionary;
		
		private var _lastEntry:ScoreEntry;
		
		private var _numEntries:int;
		
		
		/**
		 * Constructor
		 */
		public function ScoreDataBase() {
			setupDataBase();
		}
		
		//---------------------------------------------------------------------
		//  DataBase
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupDataBase():void {
			_dataBase = new Dictionary();
		}
		
		/**
		 * @private
		 */
		private function disposeDataBase():void {
			var id:String;
			var entry:ScoreEntry;
			
			for (id in _dataBase) {
				entry = _dataBase[id] as ScoreEntry;
				
				if (entry) {
					entry.destroy();
					entry = null;
				}
				
				_dataBase[id] = undefined;
				delete _dataBase[id];
			}
		}
		
		/**
		 * @private
		 */
		private function destroyDataBase():void {
			_dataBase = null;
		}
		
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			disposeDataBase();
			destroyDataBase();
			
			_lastEntry = null;
			_numEntries = 0;
		}
		
		/**
		 * Get String format of object.
		 * 
		 * @return
		 */
		public function toString():String {
			return StringTools.formatToString(this, 'ScoreDataBase', 'numEntries', 'lastEntry');
		}
		
		/**
		 * Add entry in database.
		 * 
		 * @param	scoreID
		 * @param	scoreValue
		 * @param	playerID
		 */
		public function addEntry(scoreID:String, scoreValue:Object, playerID:String = GameUniverse.DEFAULT_PLAYER_NAME):void {
			if (!this.hasEntry(scoreID, playerID)) {
				_lastEntry = new ScoreEntry();
				_lastEntry.id = scoreID;
				_lastEntry.value = scoreValue;
				_lastEntry.player = playerID;
				
				_dataBase[scoreID] = _lastEntry;
				
				_numEntries++;
			}
		}
		
		/**
		 * Delete entry in database.
		 * 
		 * @param	scoreID
		 * @param	playerID
		 */
		public function deleteEntry(scoreID:String, playerID:String = GameUniverse.DEFAULT_PLAYER_NAME):void {
			var entry:ScoreEntry;
			
			if (this.hasEntry(scoreID, playerID)) {
				entry = _dataBase[scoreID] as ScoreEntry;
				entry.destroy();
				entry = null;
				
				_dataBase[scoreID] = undefined;
				delete _dataBase[scoreID];
				
				_numEntries--;
			}
		}
		
		/**
		 * Update entry in database.
		 * 
		 * @param	scoreID
		 * @param	scoreValue
		 * @param	playerID
		 */
		public function updateEntry(scoreID:String, scoreValue:Object, playerID:String = GameUniverse.DEFAULT_PLAYER_NAME):void {
			if (this.hasEntry(scoreID, playerID)) {
				_lastEntry = _dataBase[scoreID] as ScoreEntry;
				_lastEntry.value = scoreValue;
			}
		}
		
		/**
		 * Test entry in database.
		 * 
		 * @param	scoreID
		 * @param	playerID
		 * @return
		 */
		public function hasEntry(scoreID:String, playerID:String = GameUniverse.DEFAULT_PLAYER_NAME):Boolean {
			return _dataBase[scoreID] != undefined;
		}
		
		/**
		 * Get entry in database
		 * 
		 * @param	scoreID
		 * @param	playerID
		 * @return
		 */
		public function getEntry(scoreID:String, playerID:String = null):Object {
			var id:String;
			var entry:ScoreEntry;
			
			for (id in _dataBase) {
				entry = _dataBase[id] as ScoreEntry;
				
				if (entry) return entry.value;
			}
			
			return null;
		}
		
		
		/**
		 * @private
		 */
		public function get numEntries():int {
			return _numEntries;
		}
		
		/**
		 * @private
		 */
		public function get lastEntry():ScoreEntry {
			return _lastEntry;
		}
	}
}