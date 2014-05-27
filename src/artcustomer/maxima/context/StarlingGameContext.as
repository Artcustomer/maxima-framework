/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.context {
	import flash.utils.getQualifiedClassName;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.engine.StarlingGameEngine;
	import artcustomer.maxima.utils.consts.*;
	import artcustomer.maxima.context.root.StarlingRootClass;
	import artcustomer.maxima.engine.StarlingUIEngine;
	
	import starling.core.Starling;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	
	/**
	 * StarlingGameContext : Context for Starling game.
	 * 
	 * @author David Massenot
	 */
	public class StarlingGameContext extends GameContext {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.context::StarlingGameContext';
		private static const HD_MIN_SIZE:int = 480;
		private static const EXTENDED_MIN_SIZE:int = 1536;
		private static const DEFAULT_CONTEXT3D_PROFILE:String = Context3DProfile.BASELINE;
		
		private var _starling:Starling;
		private var _starlingStage:Stage;
		private var _starlingRoot:StarlingRootClass;
		
		private var _handleLostContext:Boolean;
		private var _profile:String;
		
		private var _starlingUIEngine:StarlingUIEngine;
		
		
		/**
		 * Constructor
		 * 
		 * @param	contextView
		 */
		public function StarlingGameContext() {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_CONTEXT_CONSTRUCTOR);
			
			_handleLostContext = true;
			_profile = DEFAULT_CONTEXT3D_PROFILE;
			_delayedGameEngineCreation = true;
		}
		
		//---------------------------------------------------------------------
		//  Starling
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupStarling():void {
			var viewPort:Rectangle;
			var starlingStageWidth:int;
			var starlingStageHeight:int;
			
			if (this.scaleToStage) {
				viewPort = this.isDesktop == true ? new Rectangle(0, 0, this.fullScreenWidth, this.fullScreenHeight) : new Rectangle(0, 0, this.stageWidth, this.stageHeight);
				starlingStageWidth = viewPort.width / this.scaleFactor;
				starlingStageHeight = viewPort.height / this.scaleFactor;
			} else {
				viewPort = new Rectangle(0, 0, this.contextWidth, this.contextHeight);
				starlingStageWidth = this.contextWidth;
				starlingStageHeight = this.contextHeight;
			}
			
			var tmpMinWidth:int = Math.min(viewPort.width, viewPort.height);
			
			switch (_profile) {
				case(StarlingContext3DProfile.BASELINE_EXTENDED_ON_BIG_SIZE):
					_profile = tmpMinWidth >= EXTENDED_MIN_SIZE ? Context3DProfile.BASELINE_EXTENDED : DEFAULT_CONTEXT3D_PROFILE;
					break;
					
				case(StarlingContext3DProfile.BASELINE_EXTENDED_ON_BIG_SIZE_IOS):
					_profile = tmpMinWidth >= EXTENDED_MIN_SIZE && this.isiOS ? Context3DProfile.BASELINE_EXTENDED : DEFAULT_CONTEXT3D_PROFILE;
					break;
					
				default:
					break;
			}
			
			try {
				Starling.multitouchEnabled = true;
				Starling.handleLostContext = _handleLostContext;
				
				_starling = new Starling(StarlingRootClass, this.stageReference, viewPort, null, Context3DRenderMode.AUTO, _profile);
				_starling.addEventListener(Event.ROOT_CREATED, handleStarling);
				_starling.addEventListener(Event.CONTEXT3D_CREATE, handleStarling);
				_starling.stage.addEventListener(ResizeEvent.RESIZE, handleStarlingResize);
				_starling.simulateMultitouch = false;
				_starling.enableErrorChecking = false;
				_starling.antiAliasing = 4;
				_starling.showStats = true;
				
				_starling.stage.stageWidth = starlingStageWidth;
				_starling.stage.stageHeight = starlingStageHeight;
				
				_starlingStage = _starling.stage;
				
				this._isHD = _starling.viewPort.width > HD_MIN_SIZE;
			} catch (er:Error) {
				throw new StarlingError(er.message);
			}
		}
		
		/**
		 * @private
		 */
		private function destroyStarling():void {
			if (_starling) {
				_starling.removeEventListener(Event.ROOT_CREATED, handleStarling);
				_starling.removeEventListener(Event.CONTEXT3D_CREATE, handleStarling);
				_starling.stage.removeEventListener(ResizeEvent.RESIZE, handleStarlingResize);
				_starling.dispose();
				_starling = null;
			}
		}
		
		/**
		 * @private
		 */
		private function resizeStarling():void {
			var width:int = this.contextWidth;
			var height:int = this.contextHeight;
			var viewport:Rectangle = new Rectangle(0, 0, width, height);
			
			if (_starling) {
				_starling.viewPort = viewport;
				_starling.stage.stageWidth = width;
				_starling.stage.stageHeight = height;
			}
		}
		
		/**
		 * @private
		 */
		private function renderStarling():void {
			if (_starling) _starling.nextFrame();
		}
		
		/**
		 * @private
		 */
		private function handleStarling(e:Event):void {
			switch (e.type) {
				case(Event.ROOT_CREATED):
					if (_starling) _starlingRoot = _starling.root as StarlingRootClass;
					
					addEngines();
					
					this.createGameEngine();
					this.onReady();
					break;
					
				case(Event.CONTEXT3D_CREATE):
					if (!_starling.isStarted) _starling.start();
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleStarlingResize(e:ResizeEvent):void {
			switch (e.type) {
				case(ResizeEvent.RESIZE):
					//resizeStarling();
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  Engines
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function addEngines():void {
			_starlingUIEngine = this.engineManager.createEngine(StarlingUIEngine) as StarlingUIEngine;
		}
		
		/**
		 * @private
		 */
		private function removeEngines():void {
			this.engineManager.removeEngine(_starlingUIEngine);
			_starlingUIEngine = null;
		}
		
		
		/**
		 * Entry point.
		 */
		override public function setup():void {
			super.setup();
			
			setupStarling();
		}
		
		/**
		 * Destructor.
		 */
		override public function destroy():void {
			destroyStarling();
			removeEngines();
			
			super.destroy();
		}
		
		/**
		 * Create Starling game engine.
		 */
		override protected function createGameEngine():void {
			this.engineManager.createGameEngine(StarlingGameEngine);
		}
		
		
		/**
		 * @private
		 */
		public function get handleLostContext():Boolean {
			return _handleLostContext;
		}
		
		/**
		 * @private
		 * Set it BEFORE Starling creation, define in setup() method !
		 */
		public function set handleLostContext(value:Boolean):void {
			_handleLostContext = value;
		}
		
		/**
		 * @private
		 */
		public function get profile():String {
			return _profile;
		}
		
		/**
		 * @private
		 */
		public function set profile(value:String):void {
			_profile = value;
		}
		
		/**
		 * @private
		 */
		public function get starling():Starling {
			return _starling;
		}
		
		/**
		 * @private
		 */
		public function get starlingStage():Stage {
			return _starlingStage;
		}
		
		/**
		 * @private
		 */
		public function get starlingRoot():StarlingRootClass {
			return _starlingRoot;
		}
		
		/**
		 * @private
		 */
		public function get starlingGameEngine():StarlingGameEngine {
			return this.engineManager.gameEngine as StarlingGameEngine;
		}
		
		/**
		 * @private
		 */
		public function get starlingUIEngine():StarlingUIEngine {
			return _starlingUIEngine;
		}
	}
}