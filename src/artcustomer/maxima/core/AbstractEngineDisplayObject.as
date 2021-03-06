/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core {
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.core.display.AbstractUIDisplayObject;
	
	
	/**
	 * AbstractEngineDisplayObject
	 * 
	 * @author David Massenot
	 */
	public class AbstractEngineDisplayObject extends AbstractEngineInteractiveObject {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.core::AbstractEngineDisplayObject';
		
		private var _displayContainer:Sprite;
		
		private var _parent:DisplayObjectContainer;
		
		private var _allowSetParent:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractEngineDisplayObject() {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_ABSTRACT_CLASS);
			
			_displayContainer = new Sprite();
			_allowSetParent = true;
		}
		
		
		/**
		 * Internal entry point.
		 */
		override protected function onPreEntry():void {
			if (_parent && !_parent.contains(_displayContainer)) _parent.addChild(_displayContainer);
			
			super.onPreEntry();
		}
		
		/**
		 * Internal exit point.
		 */
		override protected function onPostExit():void {
			if (_parent && _parent.contains(_displayContainer)) _parent.removeChild(_displayContainer);
			
			super.onPostExit();
		}
		
		/**
		 * Destructor. Must be overrided and called at end !
		 */
		override protected function destroy():void {
			_displayContainer = null;
			
			_parent = null;
			_allowSetParent = false;
			
			super.destroy();
		}
		
		/**
		 * Adds a child AbstractUIDisplayObject instance to this AbstractEngineDisplayObject instance.
		 * Setup method of child is called.
		 * 
		 * @param	uiChild
		 * @return
		 */
		public function addUIChild(uiChild:AbstractUIDisplayObject):AbstractUIDisplayObject {
			if (!uiChild) throw new Error();
			
			uiChild.context = this.context;
			uiChild.setup();
			
			_displayContainer.addChild(uiChild);
			
			return uiChild;
		}
		
		/**
		 * Removes a child AbstractUIDisplayObject from the specified index position in the child list of the AbstractEngineDisplayObject.
		 * 
		 * @param	uiChild
		 * @return
		 */
		public function removeUIChild(uiChild:AbstractUIDisplayObject):AbstractUIDisplayObject {
			if (!uiChild) throw new Error();
			
			_displayContainer.removeChild(uiChild);
			
			uiChild.destroy();
			
			return uiChild;
		}
		
		
		/**
		 * @private
		 */
		public function get displayContainer():Sprite {
			return _displayContainer;
		}
		
		/**
		 * @private
		 */
		public function set parent(value:DisplayObjectContainer):void {
			if (_allowSetParent) {
				_parent = value;
				_allowSetParent = false;
			}
		}
	}
}