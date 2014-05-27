/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.entities.model {
	import artcustomer.maxima.core.model.*;
	import artcustomer.maxima.core.score.*;
	import artcustomer.maxima.core.score.data.*;
	import artcustomer.maxima.utils.consts.*;
	
	
	/**
	 * ScoreModel
	 * 
	 * @author David Massenot
	 */
	public class ScoreModel extends AbstractModel implements IModel {
		public static const ID:String = 'ScoreModel';
		
		private var _scoreDataBase:ScoreDataBase;
		
		
		/**
		 * Constructor
		 */
		public function ScoreModel() {
			super(ID);
		}
		
		
		/**
		 * Setup Model.
		 */
		override public function setup():void {
			_scoreDataBase = new ScoreDataBase();
		}
		
		/**
		 * Destroy Model.
		 */
		override public function destroy():void {
			_scoreDataBase.destroy();
			_scoreDataBase = null;
			
			super.destroy();
		}
		
		
		/**
		 * Save score
		 * 
		 * @param	scoreID
		 * @param	scoreValue
		 * @param	playerID
		 */
		public function saveScore(scoreID:String, scoreValue:Object, playerID:String = GameUniverse.DEFAULT_PLAYER_NAME):void {
			if (_scoreDataBase.hasEntry(scoreID, playerID)) {
				_scoreDataBase.updateEntry(scoreID, scoreValue, playerID);
			} else {
				_scoreDataBase.addEntry(scoreID, scoreValue, playerID);
			}
			
			// TODO : Send update
			//if (_scoreManager) _scoreManager.onSaveScore(_scoreDataBase.lastEntry);
		}
		
		/**
		 * Get score
		 * 
		 * @param	scoreID
		 * @param	playerID
		 * @return
		 */
		public function getScore(scoreID:String, playerID:String = GameUniverse.DEFAULT_PLAYER_NAME):Object {
			return _scoreDataBase.getEntry(scoreID, playerID);
		}
	}
}