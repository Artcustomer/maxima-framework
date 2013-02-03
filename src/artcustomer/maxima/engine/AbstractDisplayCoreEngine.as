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
		private var _headupDisplayContainer:Sprite;
		
		
		/**
		 * Constructor
		 */
		public function AbstractDisplayCoreEngine() {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_ABSTRACT_CLASS);
		}
		
		//---------------------------------------------------------------------
		//  Engine Container
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupEngineContainer():void {
			_engineDisplayContainer = new Sprite();
			
			this.context.contextView.addChild(_engineDisplayContainer);
		}
		
		/**
		 * @private
		 */
		private function destroyEngineContainer():void {
			if (_engineDisplayContainer) {
				if (_engineDisplayContainer.parent && _engineDisplayContainer.parent.contains(_engineDisplayContainer)) _engineDisplayContainer.parent.removeChild(_engineDisplayContainer);
				
				_engineDisplayContainer = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  HeadUp Container
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupHeadUpContainer():void {
			_headupDisplayContainer = new Sprite();
			
			this.context.contextView.addChild(_headupDisplayContainer);
		}
		
		/**
		 * @private
		 */
		private function destroyHeadUpContainer():void {
			if (_headupDisplayContainer) {
				if (_headupDisplayContainer.parent && _headupDisplayContainer.parent.contains(_headupDisplayContainer)) _headupDisplayContainer.parent.removeChild(_headupDisplayContainer);
				
				_headupDisplayContainer = null;
			}
		}
		
		
		/**
		 * Entry point.
		 */
		override internal function setup():void {
			setupEngineContainer();
			setupHeadUpContainer();
			
			super.setup();
		}
		
		/**
		 * Destructor.
		 */
		override internal function destroy():void {
			destroyEngineContainer();
			destroyHeadUpContainer();
			
			super.destroy();
		}
		
		
		/**
		 * @private
		 */
		internal function get engineDisplayContainer():Sprite {
			return _engineDisplayContainer;
		}
		
		/**
		 * @private
		 */
		public function get headupDisplayContainer():Sprite {
			return _headupDisplayContainer;
		}
	}
}