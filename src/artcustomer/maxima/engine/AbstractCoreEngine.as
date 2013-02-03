/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.context.*;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.core.EngineObjectInjector;
	
	
	/**
	 * AbstractCoreEngine
	 * 
	 * @author David Massenot
	 */
	public class AbstractCoreEngine extends EventDispatcher {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.engine::AbstractCoreEngine';
		
		protected var _injector:EngineObjectInjector;
		
		private var _context:IGameContext;
		
		private var _allowSetContext:Boolean;
		private var _allowSetInjector:Boolean;
		private var _isSetup:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractCoreEngine() {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_ABSTRACT_CLASS);
			
			_allowSetContext = true;
			_allowSetInjector = true;
			_isSetup = false;
		}
		
		
		/**
		 * Entry point.
		 */
		internal function setup():void {
			_isSetup = true;
		}
		
		/**
		 * Destructor
		 */
		internal function destroy():void {
			_context = null;
			_injector = null;
			_allowSetContext = false;
			_allowSetInjector = false;
			_isSetup = false;
		}
		
		
		/**
		 * @private
		 */
		public function set context(value:IGameContext):void {
			if (_allowSetContext) {
				_context = value;
				
				_allowSetContext = false;
			} else {
				// THROW ERROR
			}
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
		public function set injector(value:EngineObjectInjector):void {
			if (_allowSetInjector) {
				_injector = value;
				
				_allowSetInjector = false;
			} else {
				// THROW ERROR
			}
		}
		
		/**
		 * @private
		 */
		protected function get isSetup():Boolean {
			return _isSetup;
		}
	}
}