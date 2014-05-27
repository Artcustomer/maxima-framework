/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core.view.screens {
	import feathers.controls.Screen;
	
	import artcustomer.maxima.base.IDestroyable;
	import artcustomer.maxima.engines.component.IComponent;
	import artcustomer.maxima.data.IViewData;
	
	
	/**
	 * AbstractViewScreen
	 * 
	 * @author David Massenot
	 */
	public class AbstractViewScreen extends Screen implements IDestroyable {
		protected var _component:IComponent;
		protected var _isFirstTransitionComplete:Boolean;
		protected var _availableForHistory:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractViewScreen() {
			super();
		}
		
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			_component = null;
			_isFirstTransitionComplete = false;
			_availableForHistory = false;
		}
		
		/**
		 * Called when back action in fired. Override it !
		 * 
		 * @return
		 */
		public function onBack():Boolean {
			return false;
		}
		
		/**
		 * Called when the screen is active. Override it !
		 */
		public function onEntry():void {
			
		}
		
		/**
		 * Called when the screen is unactive. Override it !
		 */
		public function onExit():void {
			
		}
		
		/**
		 * Called when the screen is active and transition is complete. Override it !
		 */
		public function onTransitionComplete():void {
			_isFirstTransitionComplete = true;
		}
		
		/**
		 * Update Screen. Override it !
		 * 
		 * @param	data
		 */
		public function update(data:IViewData):void {
			
		}
		
		
		/**
		 * @private
		 */
		public function set component(value:IComponent):void {
			_component = value;
		}
		
		/**
		 * @private
		 */
		public function get availableForHistory():Boolean {
			return _availableForHistory;
		}
	}
}