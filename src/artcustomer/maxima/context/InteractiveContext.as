/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.context {
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.context.logo.*;
	import artcustomer.maxima.context.menu.*;
	import artcustomer.maxima.events.*;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.utils.consts.*;
	
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
		
		private var _contextView:DisplayObjectContainer;
		private var _contextWidth:int;
		private var _contextHeight:int;
		private var _contextMinWidth:int;
		private var _contextMinHeight:int;
		private var _contextPosition:String;
		private var _scaleToStage:Boolean;
		
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
		
		
		/**
		 * Constructor
		 */
		public function InteractiveContext() {
			_allowSetContextView = true;
			
			_contextView = null;
			_contextWidth = 1280;
			_contextHeight = 800;
			_contextMinWidth = 800;
			_contextMinHeight = 600;
			_contextPosition = ContextPosition.TOP_LEFT;
			_scaleToStage = true;
			_isFullScreen = true;
			
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_INTERACTIVECONTEXT_CONSTRUCTOR);
		}
		
		//---------------------------------------------------------------------
		//  Initialize
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function init():void {
			_logoAlign = LogoPosition.TOP_LEFT;
			_logoVerticalMargin = 10;
			_logoHorizontalMargin = 10;
			_isLogoShow = false;
			_isMenuShow = false;
		}
		
		//---------------------------------------------------------------------
		//  LoaderInfo
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupLoaderInfo():void {
			if (_contextView.loaderInfo) _contextView.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtError, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function destroyLoaderInfo():void {
			if (_contextView.loaderInfo) _contextView.loaderInfo.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtError);
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
			var contextWidth:int = Math.max(_contextMinWidth, stageWidth);
			var contextHeight:int = Math.max(_contextMinHeight, stageHeight);
			
			e.preventDefault();
			
			switch (e.type) {
				case('activate'):
					if (!_isFocusOnStage) {
						_isFocusOnStage = true;
						
						this.dispatchEvent(new GameEvent(GameEvent.GAME_FOCUS_IN, false, false, this, contextWidth, contextHeight, stageWidth, stageHeight));
					}
					break;
					
				case('deactivate'):
					if (_isFocusOnStage) {
						_isFocusOnStage = false;
						
						this.dispatchEvent(new GameEvent(GameEvent.GAME_FOCUS_OUT, false, false, this, contextWidth, contextHeight, stageWidth, stageHeight));
					}
					break;
					
				case('resize'):
					setupSize(contextWidth, contextHeight);
					refreshView();
					setLogoPosition();
					
					if (this.instance) this.instance.resize();
					if (_scaleToStage) this.dispatchEvent(new GameEvent(GameEvent.GAME_RESIZE, false, false, this, contextWidth, contextHeight, stageWidth, stageHeight));
					break;
					
				case('fullScreen'):
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
			var frameworkError:int = errorID / GameError.ERROR_ID;
			var illegalError:int = errorID / IllegalGameError.ERROR_ID;
			var eventType:String = GameErrorEvent.ERROR;
			
			if (frameworkError == 1) {
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
		//  ViewPortContainer
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupViewPortContainer():void {
			_viewPortContainer = new Sprite();
			
			_contextView.addChild(_viewPortContainer);
		}
		
		/**
		 * @private
		 */
		private function destroyViewPortContainer():void {
			if (_viewPortContainer) {
				_contextView.removeChild(_viewPortContainer);
				
				_viewPortContainer = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  HeadUpContainer
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupHeadUpContainer():void {
			_headUpContainer = new Sprite();
			
			_contextView.addChild(_headUpContainer);
		}
		
		/**
		 * @private
		 */
		private function destroyHeadUpContainer():void {
			if (_headUpContainer) {
				_contextView.removeChild(_headUpContainer);
				
				_headUpContainer = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  Logo
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupLogo():void {
			if (!_logo) {
				_logo = new GameContextLogo();
				_logo.setup();
				
				if (_headUpContainer && _logo.bitmap) _headUpContainer.addChild(_logo.bitmap);
			}
		}
		
		/**
		 * @private
		 */
		private function destroyLogo():void {
			if (_logo) {
				if (_headUpContainer && _logo.bitmap) _headUpContainer.removeChild(_logo.bitmap);
				
				_logo.destroy();
				_logo = null;
			}
		}
		
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
		//  Menu
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupMenu():void {
			if (!_menu) {
				_menu = new GameContextMenu();
				_menu.setup();
			}
		}
		
		/**
		 * @private
		 */
		private function destroyMenu():void {
			if (_menu) {
				_menu.destroy();
				_menu = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  Size
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function initSize():void {
			if (_scaleToStage) {
				if (_contextView) {
					_contextWidth = _contextView.stage.stageWidth;
					_contextHeight = _contextView.stage.stageHeight;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function setupSize(width:int, height:int):void {
			if (_scaleToStage) {
				if (_contextView) {
					_contextWidth = width;
					_contextHeight = height;
				}
			}
		}
		
		
		/**
		 * Setup InteractiveContext.
		 */
		override public function setup():void {
			init();
			
			super.setup();
			
			listenStageEvents();
			setupLoaderInfo();
			setupViewPortContainer();
			setupHeadUpContainer();
			initSize();
			refreshView();
			showLogo();
		}
		
		/**
		 * Destroy InteractiveContext.
		 */
		override public function destroy():void {
			unlistenStageEvents();
			hideLogo();
			destroyViewPortContainer();
			destroyHeadUpContainer();
			destroyLoaderInfo();
			
			_contextView = null;
			_contextWidth = 0;
			_contextHeight = 0;
			_contextMinWidth = 0;
			_contextMinHeight = 0;
			_contextPosition = null;
			_scaleToStage = false;
			_viewPortContainer = null;
			_logoAlign = null;
			_logoVerticalMargin = 0;
			_logoHorizontalMargin = 0;
			_allowSetContextView = false;
			_isLogoShow = false;
			_isMenuShow = false;
			_isFocusOnStage = false;
			
			super.destroy();
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
				setupLogo();
				setLogoPosition();
				
				_isLogoShow = true;
			}
		}
		
		/**
		 * Hide Framework logo.
		 */
		public function hideLogo():void {
			if (_isLogoShow) {
				destroyLogo();
				
				_isLogoShow = false;
			}
		}
		
		/**
		 * Show Framework context menu.
		 */
		public function showMenu():void {
			if (!_isMenuShow) {
				setupMenu();
				
				_isMenuShow = true;
			}
		}
		
		/**
		 * Hide Framework context menu.
		 */
		public function hideMenu():void {
			if (_isMenuShow) {
				destroyMenu();
				
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
		public function set contextMinWidth(value:int):void {
			_contextMinWidth = value;
		}
		
		/**
		 * @private
		 */
		public function get contextMinWidth():int {
			return _contextMinWidth;
		}
		
		/**
		 * @private
		 */
		public function set contextMinHeight(value:int):void {
			_contextMinHeight = value;
		}
		
		/**
		 * @private
		 */
		public function get contextMinHeight():int {
			return _contextMinHeight;
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
	}
}