/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine {
	import artcustomer.maxima.context.StarlingGameContext;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.core.AbstractEngineStarlingDisplayObject;
	import artcustomer.maxima.core.view.*;
	
	import starling.display.Sprite;
	
	
	/**
	 * StarlingGameEngine
	 * 
	 * @author David Massenot
	 */
	public class StarlingGameEngine extends GameEngine {
		private var _engineDisplayContainer:Sprite;
		
		
		/**
		 * Constructor
		 */
		public function StarlingGameEngine() {
			super();
		}
		
		
		/**
		 * Add display object to stage.
		 */
		override protected function addCurrentObjectToStage():void {
			if (_currentEngineObject is AbstractEngineStarlingDisplayObject) {
				(_currentEngineObject as AbstractEngineStarlingDisplayObject).parent = _engineDisplayContainer;
			} else {
				this.context.instance.throwCustomError(IllegalGameError, IllegalGameError.E_CURRENTOBJECT_STARLING_INVALID, IllegalGameError.ERROR_ID);
			}
		}
		
		/**
		 * Entry point.
		 */
		override internal function setup():void {
			super.setup();
			
			_engineDisplayContainer = new Sprite();
			(this.context.instance as StarlingGameContext).starlingRoot.addChild(_engineDisplayContainer);
		}
		
		/**
		 * Destructor
		 */
		override internal function destroy():void {
			if (_engineDisplayContainer) {
				if (_engineDisplayContainer.parent && _engineDisplayContainer.parent.contains(_engineDisplayContainer)) _engineDisplayContainer.parent.removeChild(_engineDisplayContainer, true);
				_engineDisplayContainer = null;
			}
			
			super.destroy();
		}
		
		/**
		 * Add single Starling view in the engine.
		 * 
		 * @param	engineClass : Class extends StarlingDisplayView
		 * @param	name : Name of the object (the key)
		 */
		public function addStarlingView(engineClass:Class, name:String):void {
			if (!engineClass) {
				this.context.instance.throwCustomError(GameError, GameError.E_CORE_DISPLAYVIEW, GameError.ERROR_ID);
				
				return;
			}
			
			_navigationSystem.addInMap(name, engineClass);
		}
	}
}