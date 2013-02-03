/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine.inputs.controls {
	import artcustomer.maxima.utils.consts.ControlType;
	
	
	/**
	 * KeyboardControl
	 * 
	 * @author David Massenot
	 */
	public class KeyboardControl extends AbstractGameControl {
		
		
		/**
		 * Constructor
		 */
		public function KeyboardControl() {
			super();
			
			_type = ControlType.KEYBOARD;
		}
	}
}