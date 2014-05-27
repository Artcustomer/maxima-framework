/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core.command {
	import flash.events.Event;
	
	
	/**
	 * IMacroCommand
	 * 
	 * @author David Massenot
	 */
	public interface ICommand {
		function setup():void
		function destroy():void
		function execute(event:Event):void
	}
}