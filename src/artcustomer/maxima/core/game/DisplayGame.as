/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core.game {
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.events.*;
	import artcustomer.maxima.core.AbstractEngineDisplayObject;
	
	
	/**
	 * DisplayGame
	 * 
	 * @author David Massenot
	 */
	public class DisplayGame extends AbstractEngineDisplayObject {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.core.game::DisplayGame';
		
		private var _isOnPause:Boolean;
		
		
		/**
		 * Constructor
		 * 
		 * @param	aName : Name of the object, used as key in NavigationSystem. Required !
		 */
		public function DisplayGame(aName:String) {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_ABSTRACT_CLASS);
			if (!aName) throw new GameError(GameError.E_NULL_CORE_NAME);
			
			this.name = aName;
		}
		
		//---------------------------------------------------------------------
		//  Event Dispatching
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function dispatchGameEvent(type:String):void {
			this.context.dispatchEvent(new GameEvent(type, false, false, this.context, this.context.contextWidth, this.context.contextHeight, this.context.instance.stageReference.stageWidth, this.context.instance.stageReference.stageHeight));
		}
		
		
		/**
		 * Entry point. Override it and call it at begin !
		 */
		override protected function onEntry():void {
			_isOnPause = false;
			
			this.context.instance.renderEngine.start();
			
			super.onEntry();
		}
		
		/**
		 * Exit point. Override it and call it at end !
		 */
		override protected function onExit():void {
			super.onExit();
		}
		
		/**
		 * Destructor. Override it and call at end !
		 */
		override protected function destroy():void {
			_isOnPause = false;
			
			super.destroy();
		}
		
		/**
		 * Start Game, call this method when game is ready. Override it !
		 */
		protected function start():void {
			
		}
		
		/**
		 * Pause game.
		 */
		protected function pause():void {
			if (!_isOnPause) {
				_isOnPause = true;
				
				dispatchGameEvent(GameEvent.GAME_PAUSE);
			}
		}
		
		/**
		 * Resume game.
		 */
		protected function resume():void {
			if (_isOnPause) {
				_isOnPause = false;
				
				dispatchGameEvent(GameEvent.GAME_RESUME);
			}
		}
		
		
		/**
		 * @private
		 */
		public function get isOnPause():Boolean {
			return _isOnPause;
		}
	}
}