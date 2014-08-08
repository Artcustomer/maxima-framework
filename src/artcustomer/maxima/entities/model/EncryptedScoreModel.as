/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.entities.model {
	import flash.utils.Dictionary;
	
	import artcustomer.maxima.core.model.*;
	import artcustomer.maxima.core.score.data.*;
	import artcustomer.maxima.entities.model.data.GameScoreData;
	import artcustomer.maxima.context.platform.storage.LocalStorage;
	import artcustomer.maxima.utils.consts.*;
	
	
	/**
	 * EncryptedScoreModel
	 * 
	 * @author David Massenot
	 */
	public class EncryptedScoreModel extends AbstractModel implements IModel {
		public static const ID:String = 'EncryptedScoreModel';
		public static const STORAGE_ID:String = 'SCORE_DB';
		public static const UPDATE_TYPE:String = 'score';
		public static const UPDATE_TYPE_UPDATE:String = 'updateScore';
		public static const UPDATE_TYPE_GET:String = 'getScore';
		public static const UPDATE_TYPE_SAVE_IN_LOCALSTORAGE:String = 'saveScoreInLocalStorage';
		public static const UPDATE_TYPE_GET_FROM_LOCALSTORAGE:String = 'getScoreFromLocalStorage';
		
		private var _scoreDataBase:ScoreDataBase;
		private var _data:GameScoreData;
		private var _storage:LocalStorage;
		
		
		/**
		 * Constructor
		 */
		public function EncryptedScoreModel() {
			super(ID);
		}
		
		//---------------------------------------------------------------------
		//  Data
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function unserializeLocalData():void {
			if (!_storage.isSupported) {
				if (_storage.has(STORAGE_ID)) _scoreDataBase.setData(_storage.get(STORAGE_ID) as Dictionary);
			}
		}
		
		
		/**
		 * Setup Model.
		 */
		override public function setup():void {
			_scoreDataBase = new ScoreDataBase();
			_data = new GameScoreData();
			_storage = LocalStorage.getInstance();
			
			if (!_storage.isSupported) {
				if (_storage.has(STORAGE_ID)) _scoreDataBase.setData(_storage.get(STORAGE_ID) as Dictionary);
			} else {
				// WARNING ! EncryptedLocalStore is not supported !
			}
		}
		
		/**
		 * Destroy Model.
		 */
		override public function destroy():void {
			_scoreDataBase.destroy();
			_scoreDataBase = null;
			
			_data.destroy();
			_data = null;
			
			_storage = null;
			
			super.destroy();
		}
		
		
		/**
		 * Update score.
		 * 
		 * @param	scoreID
		 * @param	scoreValue
		 * @param	playerID
		 */
		public function updateScore(scoreID:String, scoreValue:Object, playerID:String = GameUniverse.DEFAULT_PLAYER_NAME):void {
			if (_scoreDataBase.hasEntry(scoreID, playerID)) {
				_scoreDataBase.updateEntry(scoreID, scoreValue, playerID);
			} else {
				_scoreDataBase.addEntry(scoreID, scoreValue, playerID);
			}
			
			_data.error = null;
			_data.data = null;
			_data.type = UPDATE_TYPE_UPDATE;
			_data.lastEntry = _scoreDataBase.lastEntry;
			
			this.update(UPDATE_TYPE, _data);
		}
		
		/**
		 * Get score.
		 * 
		 * @param	scoreID
		 * @param	playerID
		 * @return
		 */
		public function getScore(scoreID:String, playerID:String = GameUniverse.DEFAULT_PLAYER_NAME):void {
			_data.error = null;
			_data.type = UPDATE_TYPE_GET;
			_data.data = _scoreDataBase.getEntryValue(scoreID, playerID);
			
			this.update(UPDATE_TYPE, _data);
			
			
		}
		
		/**
		 * Save score in local storage.
		 * 
		 * @param	scoreID
		 * @param	scoreValue
		 * @param	playerID
		 */
		public function saveScoreInLocalStorage(scoreID:String, scoreValue:Object, playerID:String = GameUniverse.DEFAULT_PLAYER_NAME):void {
			_storage.set(_scoreDataBase.getEntryID(scoreID, playerID), scoreValue);
			
			//_data.error = null;
			//_data.type = UPDATE_TYPE_SAVE_IN_LOCALSTORAGE;
			//this.update(UPDATE_TYPE, _data);
		}
		
		/**
		 * Get score from local storage.
		 * 
		 * @param	scoreID
		 * @param	scoreValue
		 * @param	playerID
		 */
		public function getScoreInLocalStorage(scoreID:String, playerID:String = GameUniverse.DEFAULT_PLAYER_NAME):void {
			_data.error = null;
			_data.type = UPDATE_TYPE_GET_FROM_LOCALSTORAGE;
			_data.data = _storage.get(_scoreDataBase.getEntryID(scoreID, playerID));
			
			this.update(UPDATE_TYPE, _data);
		}
	}
}