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
			_dataBase = new Dictionary();
		}
		
		//---------------------------------------------------------------------
		//  DataBase
		//---------------------------------------------------------------------
		
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
		private function createEntryID(scoreID:String, playerID:String):String {
			return scoreID + '_' + playerID;
		}
		
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			disposeDataBase();
			
			_dataBase = null;
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
			var tmpEntryID:String = createEntryID(scoreID, playerID);
			
			if (!this.hasEntry(scoreID, playerID)) {
				_lastEntry = new ScoreEntry();
				_lastEntry.id = tmpEntryID;
				_lastEntry.scoreID = scoreID;
				_lastEntry.value = scoreValue;
				_lastEntry.player = playerID;
				
				_dataBase[tmpEntryID] = _lastEntry;
				
				++_numEntries;
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
			var tmpEntryID:String = createEntryID(scoreID, playerID);
			
			if (this.hasEntry(scoreID, playerID)) {
				entry = _dataBase[tmpEntryID] as ScoreEntry;
				entry.destroy();
				entry = null;
				
				_dataBase[tmpEntryID] = undefined;
				delete _dataBase[tmpEntryID];
				
				--_numEntries;
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
			var tmpEntryID:String = createEntryID(scoreID, playerID);
			
			if (this.hasEntry(scoreID, playerID)) {
				(_dataBase[tmpEntryID] as ScoreEntry).value = scoreValue;
				
				_lastEntry = _dataBase[tmpEntryID] as ScoreEntry;
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
			return _dataBase[createEntryID(scoreID, playerID)] != undefined;
		}
		
		/**
		 * Get entry value in database.
		 * 
		 * @param	scoreID
		 * @param	playerID
		 * @return
		 */
		public function getEntryValue(scoreID:String, playerID:String = GameUniverse.DEFAULT_PLAYER_NAME):Object {
			var id:String;
			var entry:ScoreEntry;
			var tmpEntryID:String = createEntryID(scoreID, playerID);
			
			entry = _dataBase[tmpEntryID] as ScoreEntry;
			
			if (entry) return entry.value;
			
			return null;
		}
		
		/**
		 * Get valid entry id.
		 * 
		 * @param	scoreID
		 * @param	playerID
		 * @return
		 */
		public function getEntryID(scoreID:String, playerID:String = GameUniverse.DEFAULT_PLAYER_NAME):String {
			return createEntryID(scoreID, playerID);
		}
		
		/**
		 * Set data with existing dictionary.
		 * Careful ! This method rewrite all existing data !
		 * 
		 * @param	data
		 */
		public function setData(data:Dictionary):void {
			_dataBase = data;
		}
		
		
		/**
		 * @private
		 */
		public function get dataBase():Dictionary {
			return _dataBase;
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