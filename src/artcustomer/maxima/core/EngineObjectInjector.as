/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core {
	import artcustomer.maxima.base.IDestroyable;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.engine.inputs.controls.*;
	import artcustomer.maxima.data.IViewData;
	
	
	/**
	 * EngineObjectInjector : Injector for EngineObject.
	 * 
	 * @author David Massenot
	 */
	public class EngineObjectInjector implements IDestroyable {
		private static var __instance:EngineObjectInjector;
		private static var __allowInstantiation:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function EngineObjectInjector() {
			if (!__allowInstantiation) {
				throw new GameError(GameError.E_ENGINEOBJECTMANAGER_CREATE);
				
				return;
			}
		}
		
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			__instance = null;
			__allowInstantiation = false;
		}
		
		/**
		 * Inject control in current interactive object.
		 * 
		 * @param	control
		 * @param	eventType
		 */
		public function injectControl(engineObject:AbstractEngineObject, control:IGameControl, eventType:String):void {
			if (engineObject is AbstractEngineInteractiveObject) (engineObject as AbstractEngineInteractiveObject).injectControl(eventType, control);
		}
		
		/**
		 * Inject back input on object.
		 * 
		 * @param	engineObject
		 */
		public function onBack(engineObject:AbstractEngineObject):void {
			engineObject.onBack();
		}
		
		/**
		 * Enable focus on interactive object.
		 * 
		 * @param	engineObject
		 */
		public function enableFocus(engineObject:AbstractEngineObject):void {
			if (engineObject is AbstractEngineInteractiveObject) (engineObject as AbstractEngineInteractiveObject).focus = true;
		}
		
		/**
		 * Disable focus on interactive object.
		 * 
		 * @param	engineObject
		 */
		public function disableFocus(engineObject:AbstractEngineObject):void {
			if (engineObject is AbstractEngineInteractiveObject) (engineObject as AbstractEngineInteractiveObject).focus = false;
		}
		
		/**
		 * Call onEntry method on core object.
		 * 
		 * @param	engineObject
		 */
		public function entryObject(engineObject:AbstractEngineObject):void {
			engineObject.callEntry();
		}
		
		/**
		 * Call onExit method on core object.
		 * 
		 * @param	engineObject
		 */
		public function exitObject(engineObject:AbstractEngineObject):void {
			engineObject.callExit();
		}
		
		/**
		 * Call destroy method on core object.
		 * 
		 * @param	engineObject
		 */
		public function destroyObject(engineObject:AbstractEngineObject):void {
			engineObject.callDestroy();
		}
		
		/**
		 * Call resize method on core object.
		 * 
		 * @param	engineObject
		 */
		public function resizeObject(engineObject:AbstractEngineObject):void {
			engineObject.callResize();
		}
		
		/**
		 * Call render method on core object.
		 * 
		 * @param	engineObject
		 */
		public function renderObject(engineObject:AbstractEngineObject):void {
			engineObject.callRender();
		}
		
		/**
		 * Call update method on core object.
		 * 
		 * @param	engineObject
		 * @param	id
		 * @param	data
		 * @param	type
		 */
		public function updateObject(engineObject:AbstractEngineObject, id:String, data:IViewData, type:String):void {
			engineObject.callUpdate(id, data, type);
		}
		
		
		/**
		 * Instantiate EngineObjectInjector.
		 */
		public static function getInstance():EngineObjectInjector {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new EngineObjectInjector();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
	}
}