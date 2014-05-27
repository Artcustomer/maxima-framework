/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.context {
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.engine.*;
	import artcustomer.maxima.utils.consts.*;
	
	
	/**
	 * FlashGameContext : Context for simple Flash game.
	 * 
	 * @author David Massenot
	 */
	public class FlashGameContext extends GameContext {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.context::FlashGameContext';
		
		
		/**
		 * Constructor
		 */
		public function FlashGameContext() {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_CONTEXT_CONSTRUCTOR);
		}
		
		
		/**
		 * Setup the context. Must be overrided and called at first.
		 */
		override public function setup():void {
			super.setup();
			
			this.onReady();
		}
		
		/**
		 * Create Flash game engine.
		 */
		override protected function createGameEngine():void {
			this.engineManager.createGameEngine(FlashGameEngine);
		}
		
		
		/**
		 * @private
		 */
		public function get flashGameEngine():FlashGameEngine {
			return this.engineManager.gameEngine as FlashGameEngine;
		}
	}
}