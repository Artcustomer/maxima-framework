/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core.view {
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.core.AbstractEngineStarlingDisplayObject;
	
	
	/**
	 * StarlingDisplayView
	 * 
	 * @author David Massenot
	 */
	public class StarlingDisplayView extends AbstractEngineStarlingDisplayObject {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.core.view::StarlingDisplayView';
		
		
		/**
		 * Constructor
		 * 
		 * @param	aName : Name of the object, used as key in NavigationSystem. Required !
		 */
		public function StarlingDisplayView(aName:String) {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_ABSTRACT_CLASS);
			if (!aName) throw new GameError(GameError.E_NULL_CORE_NAME);
			
			this.name = aName;
		}
	}
}