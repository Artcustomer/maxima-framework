/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.context {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	
	/**
	 * IGameContext
	 * 
	 * @author David Massenot
	 */
	public interface IGameContext{
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		function hasEventListener(type:String):Boolean
		function dispatchEvent(e:Event):Boolean;
		function get eventDispatcher():IEventDispatcher;
		function get contextView():DisplayObjectContainer;
		function get contextWidth():int;
		function get contextHeight():int;
		function get instance():GameContext;
	}
}