/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core.view {
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.core.AbstractEngineStarlingDisplayObject;
	
	import starling.events.Event;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.events.FeathersEventType;
	
	
	/**
	 * FeathersNavigatorView
	 * 
	 * @author David Massenot
	 */
	public class FeathersNavigatorView extends AbstractEngineStarlingDisplayObject {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.core.view::FeathersNavigatorView';
		
		public static const DEFAULT_TRANSITION_DURATION:Number = 1;
		
		protected var _screenNavigator:ScreenNavigator;
		protected var _currentScreenID:String;
		
		private var _transitionManager:ScreenSlidingStackTransitionManager;
		
		
		/**
		 * Constructor
		 * 
		 * @param	aName : Name of the object, used as key in NavigationSystem. Required !
		 */
		public function FeathersNavigatorView(aName:String) {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_ABSTRACT_CLASS);
			if (!aName) throw new GameError(GameError.E_NULL_CORE_NAME);
			
			this.name = aName;
		}
		
		//---------------------------------------------------------------------
		//  ScreenNavigator
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleScreenNavigator(e:Event):void {
			/*var screen:AbstractViewScreen;
			
			switch (e.type) {
				case(Event.CHANGE):
					if (_currentScreenID) {
						screen = _screenNavigator.getScreen(_currentScreenID).screen as AbstractViewScreen;
						screen.onExit();
					}
					
					_currentScreenID = _screenNavigator.activeScreenID;
					
					screen = _screenNavigator.getScreen(_currentScreenID).screen as AbstractViewScreen
					screen.onEntry();
					break;
					
				case(FeathersEventType.TRANSITION_COMPLETE):
					(_screenNavigator.getScreen(_screenNavigator.activeScreenID).screen as AbstractViewScreen).onTransitionComplete();
					break;
					
				default:
					break;
			}*/
		}
		
		
		/**
		 * Add Screen. Screen must be instance of artcustomer.maxima.core.view.screens::AbstractViewScreen
		 * 
		 * @param	id
		 * @param	item
		 */
		protected function addScreen(id:String, item:ScreenNavigatorItem):void {
			_screenNavigator.addScreen(id, item);
		}
		
		/**
		 * Internal entry point.
		 */
		final override protected function onPreEntry():void {
			super.onPreEntry();
			
			_screenNavigator = new ScreenNavigator();
			_screenNavigator.addEventListener(Event.CHANGE, handleScreenNavigator);
			_screenNavigator.addEventListener(FeathersEventType.TRANSITION_COMPLETE, handleScreenNavigator);
			this.displayContainer.addChild(_screenNavigator);
			
			_transitionManager = new ScreenSlidingStackTransitionManager(_screenNavigator);
			_transitionManager.duration = DEFAULT_TRANSITION_DURATION;
		}
		
		/**
		 * Internal exit point.
		 */
		final override protected function onPostExit():void {
			_screenNavigator.removeEventListener(Event.CHANGE, handleScreenNavigator);
			_screenNavigator.removeEventListener(FeathersEventType.TRANSITION_COMPLETE, handleScreenNavigator);
			this.displayContainer.removeChild(_screenNavigator, true);
			_screenNavigator = null;
			
			super.onPostExit();
		}
		
		/**
		 * Destructor. Override it and call at end !
		 */
		override protected function destroy():void {
			super.destroy();
		}
	}
}