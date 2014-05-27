/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine {
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.errors.*;
	
	
	/**
	 * AbstractDisplayCoreEngine
	 * 
	 * @author David Massenot
	 */
	public class AbstractDisplayCoreEngine extends AbstractCoreEngine {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.engine::AbstractDisplayCoreEngine';
		
		private var _engineDisplayContainer:Sprite;
		
		
		/**
		 * Constructor
		 */
		public function AbstractDisplayCoreEngine() {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_ABSTRACT_CLASS);
		}
		
		
		/**
		 * Entry point.
		 */
		override internal function setup():void {
			_engineDisplayContainer = new Sprite();
			this.context.instance.viewPortContainer.addChild(_engineDisplayContainer);
			
			super.setup();
		}
		
		/**
		 * Destructor.
		 */
		override internal function destroy():void {
			if (_engineDisplayContainer) {
				if (_engineDisplayContainer.parent && _engineDisplayContainer.parent.contains(_engineDisplayContainer)) _engineDisplayContainer.parent.removeChild(_engineDisplayContainer);
				_engineDisplayContainer = null;
			}
			
			super.destroy();
		}
		
		
		/**
		 * @private
		 */
		internal function get engineDisplayContainer():Sprite {
			return _engineDisplayContainer;
		}
	}
}