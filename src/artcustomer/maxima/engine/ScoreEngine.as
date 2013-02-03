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
		private static var __instance:ScoreEngine;
		private static var __allowInstantiation:Boolean;
		
		private var _scoreDataBase:ScoreDataBase;
		private var _scoreManager:ScoreManager;
		
		
		/**
		 * Constructor
		 */
		public function ScoreEngine() {
			super();
			
			if (!__allowInstantiation) {
				throw new GameError(GameError.E_SCOREENGINE_CREATE);
				
				return;
			}
		}
		
		//---------------------------------------------------------------------
		//  ScoreDataBase
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupScoreDataBase():void {
			_scoreDataBase = new ScoreDataBase();
		}
		
		/**
		 * @private
		 */
		private function destroyScoreDataBase():void {
			_scoreDataBase.destroy();
			_scoreDataBase = null;
		}
		
		//---------------------------------------------------------------------
		//  ScoreManager
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function destroyScoreManager():void {
			if (_scoreManager) {
				_injector.destroyObject(_scoreManager);
				_scoreManager = null;
			}
		}
		
		
		/**
		 * Entry point.
		 */
		override internal function setup():void {
			if (this.isSetup) return;
			
			super.setup();
			
			setupScoreDataBase();
		}
		
		/**
		 * Destructor
		 */
		override internal function destroy():void {
			destroyScoreManager();
			destroyScoreDataBase();
			
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
		 * Save score.
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
		 */
		public function getScore(scoreID:String, playerID:String = GameUniverse.DEFAULT_PLAYER_NAME):Object {
			return _scoreDataBase.getEntry(scoreID, playerID);
		}
		
		
		/**
		 * Instantiate ScoreEngine.
		 */
		public static function getInstance():ScoreEngine {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new ScoreEngine();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
	}
}