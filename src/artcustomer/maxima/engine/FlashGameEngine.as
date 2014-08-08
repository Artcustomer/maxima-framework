/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine {
	import flash.display.Sprite;
	
	import artcustomer.maxima.context.*;
	import artcustomer.maxima.core.*;
	import artcustomer.maxima.core.game.*;
	import artcustomer.maxima.core.loader.*;
	import artcustomer.maxima.core.view.*;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.events.*;
	
	
	/**
	 * FlashGameEngine
	 * 
	 * @author David Massenot
	 */
	public class FlashGameEngine extends GameEngine {
		private var _engineDisplayContainer:Sprite;
		
		
		/**
		 * Constructor
		 */
		public function FlashGameEngine() {
			super();
		}
		
		
		/**
		 * Add display object to stage.
		 */
		override protected function addCurrentObjectToStage():void {
			if (_currentEngineObject is AbstractEngineDisplayObject) (_currentEngineObject as AbstractEngineDisplayObject).parent = _engineDisplayContainer;
		}
		
		/**
		 * Entry point.
		 */
		override internal function setup():void {
			super.setup();
			
			_engineDisplayContainer = new Sprite();
			this.context.instance.viewPortContainer.addChild(_engineDisplayContainer);
		}
		
		/**
		 * Destructor
		 */
		override internal function destroy():void {
			if (_engineDisplayContainer) {
				if (_engineDisplayContainer.parent && _engineDisplayContainer.parent.contains(_engineDisplayContainer)) _engineDisplayContainer.parent.removeChild(_engineDisplayContainer);
				_engineDisplayContainer = null;
			}
			
			super.destroy();
		}
		
		/**
		 * Set global loader for the game.
		 * Would be called at first !
		 * 
		 * @param	engineClass : Class extends GlobalLoader
		 * @param	name : Name of the object (the key)
		 */
		public function setGlobalLoader(engineClass:Class, name:String):void {
			if (!engineClass || !engineClass is GlobalLoader) {
				throw new GameError(GameError.E_CORE_GLOBALLOADER);
				
				return;
			}
			
			_navigationSystem.addInMap(name, engineClass);
		}
		
		/**
		 * Set the game in the engine.
		 * 
		 * @param	engineClass : Class extends DisplayGame
		 * @param	name : Name of the object (the key)
		 */
		public function setGame(engineClass:Class, name:String):void {
			if (!engineClass || !engineClass is DisplayGame) {
				throw new GameError(GameError.E_CORE_DISPLAYGAME);
				
				return;
			}
			
			_navigationSystem.addInMap(name, engineClass);
		}
		
		/**
		 * Add single view in the engine.
		 * 
		 * @param	engineClass : Class extends DisplayView
		 * @param	name : Name of the object (the key)
		 */
		public function addView(engineClass:Class, name:String):void {
			if (!engineClass || !engineClass is DisplayView) {
				throw new GameError(GameError.E_CORE_DISPLAYVIEW);
				
				return;
			}
			
			_navigationSystem.addInMap(name, engineClass);
		}
	}
}