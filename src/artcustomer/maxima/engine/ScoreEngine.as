/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine {
	import artcustomer.maxima.context.*;
	import artcustomer.maxima.core.*;
	import artcustomer.maxima.core.score.*;
	import artcustomer.maxima.core.score.data.*;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.utils.consts.*;
	
	
	/**
	 * ScoreEngine
	 * 
	 * @author David Massenot
	 */
	public class ScoreEngine extends AbstractCoreEngine {
		private var _scoreDataBase:ScoreDataBase;
		private var _scoreManager:ScoreManager;
		
		
		/**
		 * Constructor
		 */
		public function ScoreEngine() {
			super();
		}
		
		
		/**
		 * Entry point.
		 */
		override internal function setup():void {
			if (this.isSetup) return;
			
			super.setup();
			
			_scoreDataBase = new ScoreDataBase();
		}
		
		/**
		 * Destructor
		 */
		override internal function destroy():void {
			if (_scoreManager) {
				_injector.destroyObject(_scoreManager);
				_scoreManager = null;
			}
			
			_scoreDataBase.destroy();
			_scoreDataBase = null;
			
			super.destroy();
		}
		
		/**
		 * Set score manager in the engine.
		 * 
		 * @param	engineClass : Class extends ScoreManager
		 */
		public function setManager(managerClass:Class):void {
			if (!managerClass || !managerClass is ScoreManager) {
				// THROW ERROR
				
				return;
			}
			
			_scoreManager = new managerClass();
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
			
			if (_scoreManager) _scoreManager.onSaveScore(_scoreDataBase.lastEntry);
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