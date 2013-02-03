/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core.score {
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.core.AbstractEngineObject;
	import artcustomer.maxima.core.score.data.ScoreEntry;
	
	
	/**
	 * ScoreManager
	 * 
	 * @author David Massenot
	 */
	public class ScoreManager extends AbstractEngineObject {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.core.score::ScoreManager';
		
		
		/**
		 * Constructor
		 * 
		 * @param	aName : Name of the object, used as key in NavigationSystem. Required !
		 */
		public function ScoreManager(aName:String) {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_ABSTRACT_CLASS);
			if (!aName) throw new GameError(GameError.E_NULL_CORE_NAME);
			
			this.name = aName;
		}
		
		
		/**
		 * Entry point. Override it !
		 */
		override protected function onEntry():void {
			super.onEntry();
		}
		
		/**
		 * Exit point. Override it !
		 */
		override protected function onExit():void {
			super.onExit();
		}
		
		/**
		 * Destructor. Override it and call at end !
		 */
		override protected function destroy():void {
			super.destroy();
		}
		
		/**
		 * Called when score is saved in framework database. Override it !
		 * 
		 * @param	lastEntry
		 */
		public function onSaveScore(lastEntry:ScoreEntry):void {
			
		}
	}
}