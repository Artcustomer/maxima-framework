/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine.inputs.controls {
	
	/**
	 * IGameControl
	 * 
	 * @author David Massenot
	 */
	public interface IGameControl {
		function get type():String
		function get action():String
		function get inputCode():String
	}
}