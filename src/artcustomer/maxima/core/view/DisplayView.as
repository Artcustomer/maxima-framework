/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core.view {
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.core.AbstractEngineDisplayObject;
	
	
	/**
	 * DisplayView
	 * 
	 * @author David Massenot
	 */
	public class DisplayView extends AbstractEngineDisplayObject {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.core.view::DisplayView';
		
		
		/**
		 * Constructor
		 * 
		 * @param	aName : Name of the object, used as key in NavigationSystem. Required !
		 */
		public function DisplayView(aName:String) {
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
	}
}