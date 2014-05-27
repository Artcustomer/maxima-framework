/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core.model {
	import artcustomer.maxima.data.IViewData;
	
	
	/**
	 * IMacroModel
	 * 
	 * @author David Massenot
	 */
	public interface IModel{
		function setup():void
		function update(type:String, data:IViewData = null):void
		function destroy():void
	}
}