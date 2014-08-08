/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.context {
	import flash.display.Stage;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.NativeMenu;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import flash.system.Capabilities;
	
	import artcustomer.maxima.context.logo.*;
	import artcustomer.maxima.context.menu.*;
	import artcustomer.maxima.events.*;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.utils.consts.*;
	import artcustomer.maxima.utils.tools.*;
	
	[Event(name = "gameResize", type = "artcustomer.maxima.events.GameEvent")]
	[Event(name = "gameNormalScreen", type = "artcustomer.maxima.events.GameEvent")]
	[Event(name = "gameFullScreen", type = "artcustomer.maxima.events.GameEvent")]
	[Event(name = "gameFocusIn", type = "artcustomer.maxima.events.GameEvent")]
	[Event(name = "gameFocusOut", type = "artcustomer.maxima.events.GameEvent")]
	[Event(name = "error", type = "artcustomer.maxima.events.GameErrorEvent")]
	[Event(name = "gameError", type = "artcustomer.maxima.events.GameErrorEvent")]
	[Event(name = "illegalError", type = "artcustomer.maxima.events.GameErrorEvent")]
	
	
	/**
	 * InteractiveContext
	 * 
	 * @author David Massenot
	 */
	public class InteractiveContext extends EventContext implements IGameContext {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.context::InteractiveContext';
		private static const CONTEXT_DEFAULT_WIDTH:int = 960;
		private static const CONTEXT_DEFAULT_HEIGHT:int = 540;
		
		private var _contextView:DisplayObjectContainer;
		private var _contextWidth:int;
		private var _contextHeight:int;
		private var _fullScreenWidth:int;
		private var _fullScreenHeight:int;
		private var _stageWidth:int;
		private var _stageHeight:int;
		private var _sceneWidth:int;
		private var _sceneHeight:int;
		private var _scaleFactorConfiguration:int;
		private var _safeContentBounds:Rectangle;
		private var _contextPosition:String;
		private var _scaleToStage:Boolean;
		private var _screenOrientation:String;
		private var _scaleFactor:Number;
		
		private var _viewPortContainer:Sprite;
		private var _headUpContainer:Sprite;
		
		private var _logo:GameContextLogo;
		private var _menu:GameContextMenu;
		
		private var _logoAlign:String;
		private var _logoVerticalMargin:int;
		private var _logoHorizontalMargin:int;
		
		private var _allowSetContextView:Boolean;
		private var _isLogoShow:Boolean;
		private var _isMenuShow:Boolean;
		private var _isFocusOnStage:Boolean;
		private var _isFullScreen:Boolean;
		
		protected var _isHD:Boolean;
		protected var _isMobile:Boolean;
		protected var _isTablet:Boolean;
		protected var _isDesktop:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function InteractiveContext() {
			_allowSetContextView = true;
			
			_contextView = null;
			_contextWidth = CONTEXT_DEFAULT_WIDTH;
			_contextHeight = CONTEXT_DEFAULT_HEIGHT;
			_scaleFactorConfiguration = StageTools.SCALEFACTOR_CONFIGURATION_1;
			_contextPosition = ContextPosition.TOP_LEFT;
			_scaleToStage = true;
			_screenOrientation = ScreenOrientation.LANDSCAPE;
			_safeContentBounds = new Rectangle();
			
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_INTERACTIVECONTEXT_CONSTRUCTOR);
		}
		
		//---------------------------------------------------------------------
		//  StageEvents
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function listenStageEvents():void {
			_contextView.stage.addEventListener(Event.ACTIVATE, handleStage, false, 0, true);
			_contextView.stage.addEventListener(Event.DEACTIVATE, handleStage, false, 0, true);
			_contextView.stage.addEventListener(Event.RESIZE, handleStage, false, 0, true);
			_contextView.stage.addEventListener(Event.FULLSCREEN, handleStage, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function unlistenStageEvents():void {
			_contextView.stage.removeEventListener(Event.ACTIVATE, handleStage);
			_contextView.stage.removeEventListener(Event.DEACTIVATE, handleStage);
			_contextView.stage.removeEventListener(Event.RESIZE, handleStage);
			_contextView.stage.removeEventListener(Event.FULLSCREEN, handleStage);
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleStage(e:Event):void {
			if (!_contextView) return;
			
			var stageWidth:int = _contextView.stage.stageWidth;
			var stageHeight:int = _contextView.stage.stageHeight;
			
			e.preventDefault();
			
			switch (e.type) {
				case(Event.ACTIVATE):
					if (!_isFocusOnStage) {
						_isFocusOnStage = true;
						
						this.dispatchEvent(new GameEvent(GameEvent.GAME_FOCUS_IN, false, false, this, contextWidth, contextHeight, stageWidth, stageHeight));
						if (this.instance) this.instance.focus();
					}
					break;
					
				case(Event.DEACTIVATE):
					if (_isFocusOnStage) {
						_isFocusOnStage = false;
						
						this.dispatchEvent(new GameEvent(GameEvent.GAME_FOCUS_OUT, false, false, this, contextWidth, contextHeight, stageWidth, stageHeight));
						if (this.instance) this.instance.unfocus();
					}
					break;
					
				case(Event.RESIZE):
					if (!_contextView) return;
					
					updateSize();
					updateSceneSize();
					setLogoPosition();
					
					this.refreshView();
					
					if (this.instance) this.instance.resize();
					if (_scaleToStage) this.dispatchEvent(new GameEvent(GameEvent.GAME_RESIZE, false, false, this, contextWidth, contextHeight, stageWidth, stageHeight));
					break;
					
				case(Event.FULLSCREEN):
					if (_contextView.stage.displayState == StageDisplayState.NORMAL) {
						this.dispatchEvent(new GameEvent(GameEvent.GAME_NORMAL_SCREEN, false, false, this, contextWidth, contextHeight, stageWidth, stageHeight));
					} else if (_contextView.stage.displayState == StageDisplayState.FULL_SCREEN) {
						this.dispatchEvent(new GameEvent(GameEvent.GAME_FULL_SCREEN, false, false, this, contextWidth, contextHeight, stageWidth, stageHeight));
					}
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleUncaughtError(e:UncaughtErrorEvent):void {
			e.preventDefault();
			
			var error:Error = e.error as Error;
			var errorID:int = error.errorID;
			var errorName:String = ErrorName.FLASH_ERROR;
			var gameError:int = errorID / IllegalGameError.ERROR_ID;
			var illegalError:int = errorID / IllegalGameError.ERROR_ID;
			var eventType:String = GameErrorEvent.ERROR;
			
			if (gameError == 1) {
				eventType = GameErrorEvent.GAME_ERROR;
				errorName = ErrorName.GAME_ERROR;
			}
			
			if (illegalError == 1) {
				eventType = GameErrorEvent.ILLEGAL_ERROR;
				errorName = ErrorName.ILLEGAL_ERROR;
			}
			
			this.dispatchEvent(new GameErrorEvent(eventType, true, false, error, errorName))
		}
		
		//---------------------------------------------------------------------
		//  Logo
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setLogoPosition():void {
			if (_logo) {
				if (_logoAlign == LogoPosition.TOP_LEFT || _logoAlign == LogoPosition.LEFT || _logoAlign == LogoPosition.BOTTOM_LEFT) _logo.x = _logoHorizontalMargin;
				if (_logoAlign == LogoPosition.TOP || _logoAlign == LogoPosition.BOTTOM) _logo.x = (_contextWidth - _logo.width) >> 1;
				if (_logoAlign == LogoPosition.TOP_RIGHT || _logoAlign == LogoPosition.RIGHT || _logoAlign == LogoPosition.BOTTOM_RIGHT) _logo.x = _contextWidth - _logoHorizontalMargin - _logo.width;
				if (_logoAlign == LogoPosition.TOP_LEFT || _logoAlign == LogoPosition.TOP || _logoAlign == LogoPosition.TOP_RIGHT) _logo.y = _logoVerticalMargin;
				if (_logoAlign == LogoPosition.LEFT || _logoAlign == LogoPosition.RIGHT) _logo.y = (_contextHeight - _logo.height) >> 1;
				if (_logoAlign == LogoPosition.BOTTOM_LEFT || _logoAlign == LogoPosition.BOTTOM || _logoAlign == LogoPosition.BOTTOM_RIGHT) _logo.y = _contextHeight - _logoVerticalMargin - _logo.height;
			}
		}
		
		//---------------------------------------------------------------------
		//  Size
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setScaleFactor():void {
			if (_isDesktop) {
				var customScaleFactor:Number = this.defineScaleFactor();
				
				_scaleFactor = customScaleFactor > 0 ? customScaleFactor : StageTools.getScaleFactor(_contextWidth, _contextHeight, _scaleFactorConfiguration);
			} else {
				_scaleFactor = 1;
			}
		}
		
		/**
		 * @private
		 */
		private function updateSize():void {
			_fullScreenWidth = this.stageReference.fullScreenWidth;
			_fullScreenHeight = this.stageReference.fullScreenHeight;
			_stageWidth = this.stageReference.stageWidth;
			_stageHeight = this.stageReference.stageHeight;
			
			if (_scaleToStage) {
				_contextWidth = _isDesktop == true ? _fullScreenWidth : _stageWidth;
				_contextHeight = _isDesktop == true ? _fullScreenHeight : _stageHeight;
			}
			
			if (_contextWidth >= _contextHeight) {
				_screenOrientation = ScreenOrientation.LANDSCAPE;
			} else {
				_screenOrientation = ScreenOrientation.PORTRAIT;
			}
		}
		
		/**
		 * @private
		 */
		private function updateSceneSize():void {
			if (_scaleFactor > 0) {
				_sceneWidth = _contextWidth / _scaleFactor;
				_sceneHeight = _contextHeight / _scaleFactor;
			}
			
			_safeContentBounds.x = 0;
			_safeContentBounds.y = 0;
			_safeContentBounds.width = _sceneWidth;
			_safeContentBounds.height = _sceneHeight;
		}
		
		
		/**
		 * When FlashPlayer receive focus. Can be overrided.
		 */
		protected function focus():void {
			
		}
		
		/**
		 * When FlashPlayer lose focus. Can be overrided.
		 */
		protected function unfocus():void {
			
		}
		
		/**
		 * Define scalefactor. Can be overrided in order to define your own ScaleFactor.
		 * 
		 * @see StageTools
		 * @return
		 */
		protected function defineScaleFactor():Number {
			return 0;
		}
		
		/**
		 * Setup InteractiveContext.
		 */
		override public function setup():void {
			_contextView.stage.scaleMode = StageScaleMode.NO_SCALE;
			_contextView.stage.quality = StageQuality.LOW;
			_contextView.stage.align = StageAlign.TOP_LEFT;
			
			_isLogoShow = false;
			_isDesktop = Capabilities.playerType == 'Desktop' ? true : false;
			_isMobile = MobileTools.isMobile();
			_isTablet = MobileTools.isTablet(this.stageReference);
			
			super.setup();
			
			listenStageEvents();
			
			if (_contextView.loaderInfo) _contextView.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtError, false, 0, true);
			
			_viewPortContainer = new Sprite();
			_contextView.addChild(_viewPortContainer);
			
			_headUpContainer = new Sprite();
			_contextView.addChild(_headUpContainer);
			
			updateSize();
			setScaleFactor();
			updateSceneSize();
			
			this.refreshView();
			this.showLogo();
		}
		
		/**
		 * Destroy InteractiveContext.
		 */
		override public function destroy():void {
			this.hideLogo();
			
			if (_viewPortContainer) {
				_contextView.removeChild(_viewPortContainer);
				_viewPortContainer = null;
			}
			
			if (_headUpContainer) {
				_contextView.removeChild(_headUpContainer);
				_headUpContainer = null;
			}
			
			unlistenStageEvents();
			
			if (_contextView.loaderInfo) _contextView.loaderInfo.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtError);
			
			_contextView = null;
			_contextWidth = 0;
			_contextHeight = 0;
			_fullScreenWidth = 0;
			_fullScreenHeight = 0;
			_contextPosition = null;
			_scaleToStage = false;
			_screenOrientation = null;
			_scaleFactor = 0;
			_viewPortContainer = null;
			_allowSetContextView = false;
			_isLogoShow = false;
			_isMenuShow = false;
			_isFocusOnStage = false;
			_isFullScreen = false;
			_isHD = false;
			_isMobile = false;
			_isTablet = false;
			_isDesktop = false;
			
			super.destroy();
		}
		
		/**
		 * Force to terminate application. Override it !
		 * 
		 * @param	errorCode
		 */
		public function forceToExit(errorCode:int = 0):void {
			
		}
		
		/**
		 * Set safe content bounds.
		 * 
		 * @param	pX
		 * @param	pY
		 * @param	pWidth
		 * @param	pHeight
		 */
		public function setSafeContentBounds(pX:int, pY:int, pWidth:int, pHeight:int):void {
			_safeContentBounds.x = pX;
			_safeContentBounds.y = pY;
			_safeContentBounds.width = pWidth;
			_safeContentBounds.height = pHeight;
		}
		
		/**
		 * Move the context view.
		 * 
		 * @param	x
		 * @param	y
		 */
		public function move(x:int = 0, y:int = 0):void {
			if (_contextView) {
				_contextView.x = x;
				_contextView.y = y;
			}
		}
		
		/**
		 * Refresh the context view.
		 */
		public function refreshView():void {
			var xPos:int = 0;
			var yPos:int = 0;
			
			switch (_contextPosition) {
				case(ContextPosition.CENTER):
					xPos = (_contextView.stage.stageWidth - _contextWidth) >> 1;
					yPos = (_contextView.stage.stageHeight - _contextHeight) >> 1;
					break;
					
				case(ContextPosition.TOP_LEFT):
					xPos = 0;
					yPos = 0;
					break;
					
				case(ContextPosition.TOP_RIGHT):
					xPos = _contextView.stage.stageWidth - _contextWidth;
					yPos = 0;
					break;
					
				case(ContextPosition.BOTTOM_LEFT):
					xPos = 0;
					yPos = _contextView.stage.stageHeight - _contextHeight;
					break;
					
				case(ContextPosition.BOTTOM_RIGHT):
					xPos = _contextView.stage.stageWidth - _contextWidth;
					yPos = _contextView.stage.stageHeight - _contextHeight;
					break;
					
				default:
					xPos = 0;
					yPos = 0;
					break;
			}
			
			if (!_scaleToStage) move(xPos, yPos);
		}
		
		/**
		 * Show Framework logo.
		 */
		public function showLogo():void {
			if (!_isLogoShow) {
				if (!_logo) {
					_logo = new GameContextLogo();
					_logo.setup();
					
					if (_headUpContainer && _logo.bitmap) _headUpContainer.addChild(_logo.bitmap);
				}
				
				setLogoPosition();
				
				_isLogoShow = true;
			}
		}
		
		/**
		 * Hide Framework logo.
		 */
		public function hideLogo():void {
			if (_isLogoShow) {
				if (_logo) {
					if (_headUpContainer && _logo.bitmap) _headUpContainer.removeChild(_logo.bitmap);
					
					_logo.destroy();
					_logo = null;
				}
				
				_isLogoShow = false;
			}
		}
		
		/**
		 * Show Framework context menu.
		 */
		public function showMenu():void {
			if (!_isMenuShow) {
				if (!_menu) {
					_menu = new GameContextMenu();
					_menu.setup();
				}
				
				_isMenuShow = true;
			}
		}
		
		/**
		 * Hide Framework context menu.
		 */
		public function hideMenu():void {
			if (_isMenuShow) {
				if (_menu) {
					_menu.destroy();
					_menu = null;
				}
				
				_isMenuShow = false;
			}
		}
		
		/**
		 * Move Framework logo.
		 * 
		 * @param	align : Use consts of LogoPosition
		 * @param	verticalMargin
		 * @param	horizontalMargin
		 */
		public function moveLogo(align:String, verticalMargin:int = 0, horizontalMargin:int = 0):void {
			if (_isLogoShow) {
				_logoAlign = align;
				_logoVerticalMargin = verticalMargin;
				_logoHorizontalMargin = horizontalMargin;
				
				setLogoPosition();
			}
		}
		
		/**
		 * Switch Normal / FullScreen mode
		 */
		public function toggleFullScreen():void {
			if (_isFullScreen) {
				_isFullScreen = false;
				
				this.stageReference.displayState = StageDisplayState.NORMAL;
			} else {
				_isFullScreen = true;
				
				this.stageReference.displayState = StageDisplayState.FULL_SCREEN;
			}
		}
		
		/**
		 * Test if context is on debug mode
		 * 
		 * @return
		 */
		public function isDebugMode():Boolean {
			return false;
		}
		
		
		/**
		 * @private
		 */
		public function set contextView(value:DisplayObjectContainer):void {
			if (_allowSetContextView) {
				_contextView = value;
				
				_allowSetContextView = false;
			}
		}
		
		/**
		 * @private
		 */
		public function get contextView():DisplayObjectContainer {
			return _contextView;
		}
		
		/**
		 * @private
		 */
		public function set contextWidth(value:int):void {
			_contextWidth = value;
		}
		
		/**
		 * @private
		 */
		public function get contextWidth():int {
			return _contextWidth;
		}
		
		/**
		 * @private
		 */
		public function set contextHeight(value:int):void {
			_contextHeight = value;
		}
		
		/**
		 * @private
		 */
		public function get contextHeight():int {
			return _contextHeight;
		}
		
		/**
		 * @private
		 */
		public function set scaleFactorConfiguration(value:int):void {
			_scaleFactorConfiguration = value;
		}
		
		/**
		 * @private
		 */
		public function get scaleFactorConfiguration():int {
			return _scaleFactorConfiguration;
		}
		
		/**
		 * @private
		 */
		public function get fullScreenWidth():int {
			return _fullScreenWidth;
		}
		
		/**
		 * @private
		 */
		public function get fullScreenHeight():int {
			return _fullScreenHeight;
		}
		
		/**
		 * @private
		 */
		public function get stageWidth():int {
			return _stageWidth;
		}
		
		/**
		 * @private
		 */
		public function get stageHeight():int {
			return _stageHeight;
		}
		
		/**
		 * @private
		 */
		public function get sceneWidth():int {
			return _sceneWidth;
		}
		
		/**
		 * @private
		 */
		public function get sceneHeight():int {
			return _sceneHeight;
		}
		
		/**
		 * @private
		 */
		public function get safeContentBounds():Rectangle {
			return _safeContentBounds;
		}
		
		/**
		 * @private
		 */
		public function set contextPosition(value:String):void {
			_contextPosition = value;
		}
		
		/**
		 * @private
		 */
		public function get contextPosition():String {
			return _contextPosition;
		}
		
		/**
		 * @private
		 */
		public function set scaleToStage(value:Boolean):void {
			_scaleToStage = value;
		}
		
		/**
		 * @private
		 */
		public function get scaleToStage():Boolean {
			return _scaleToStage;
		}
		
		/**
		 * @private
		 */
		public function get stageReference():Stage {
			return _contextView.stage;
		}
		
		/**
		 * @private
		 */
		public function get viewPortContainer():Sprite {
			return _viewPortContainer;
		}
		
		/**
		 * @private
		 */
		public function get headUpContainer():Sprite {
			return _headUpContainer;
		}
		
		/**
		 * @private
		 */
		public function get isFocusOnStage():Boolean {
			return _isFocusOnStage;
		}
		
		/**
		 * @private
		 */
		public function get isFullScreen():Boolean {
			return _isFullScreen;
		}
		
		/**
		 * @private
		 */
		public function get screenOrientation():String {
			return _screenOrientation;
		}
		
		/**
		 * @private
		 */
		public function get scaleFactor():Number {
			return _scaleFactor;
		}
		
		/**
		 * @private
		 */
		public function get isHD():Boolean {
			return _isHD;
		}
		
		/**
		 * @private
		 */
		public function get isDesktop():Boolean {
			return _isDesktop;
		}
		
		/**
		 * @private
		 */
		public function get isMobile():Boolean {
			return _isMobile;
		}
		
		/**
		 * @private
		 */
		public function get isTablet():Boolean {
			return _isTablet;
		}
	}
}