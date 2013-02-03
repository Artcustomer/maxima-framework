/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core.display {
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.context.IGameContext;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.base.IDestroyable;
	
	
	/**
	 * AbstractUIDisplayObject
	 * 
	 * @author David Massenot
	 */
	public class AbstractUIDisplayObject extends Sprite implements IDestroyable {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.core.display::AbstractUIDisplayObject';
		
		private var _context:IGameContext;
		
		private var _allowSetContext:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractUIDisplayObject() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_ABSTRACT_CLASS);
			
			_allowSetContext = true;
		}
		
		
		/**
		 * Entry point. Override it and call at begin !
		 */
		public function setup():void {
			
		}
		
		/**
		 * Destructor. Override it and call at end !
		 */
		public function destroy():void {
			_context = null;
			_allowSetContext = false;
		}
		
		
		/**
		 * @private
		 */
		public function get context():IGameContext {
			return _context;
		}
		
		/**
		 * @private
		 */
		public function set context(value:IGameContext):void {
			if (_allowSetContext) {
				_context = value;
				
				_allowSetContext = false;
			}
		}
	}
}