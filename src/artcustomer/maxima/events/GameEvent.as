/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.events {
	import flash.events.Event;
	
	import artcustomer.maxima.context.IGameContext;
	
	
	/**
	 * GameEvent
	 * 
	 * @author David Massenot
	 */
	public class GameEvent extends Event {
		public static const GAME_SETUP:String = 'gameSetup';
		public static const GAME_RESET:String = 'gameReset';
		public static const GAME_PAUSE:String = 'gamePause';
		public static const GAME_RESUME:String = 'gameResume';
		public static const GAME_DESTROY:String = 'gameDestroy';
		public static const GAME_RESIZE:String = 'gameResize';
		public static const GAME_NORMAL_SCREEN:String = 'gameNormalScreen';
		public static const GAME_FULL_SCREEN:String = 'gameFullScreen';
		public static const GAME_FOCUS_IN:String = 'gameFocusIn';
		public static const GAME_FOCUS_OUT:String = 'gameFocusOut';
		
		private var _context:IGameContext;
		private var _contextWidth:int;
		private var _contextHeight:int;
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	context
		 * @param	contextWidth
		 * @param	contextHeight
		 * @param	stageWidth
		 * @param	stageHeight
		 */
		public function GameEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, context:IGameContext = null, contextWidth:int = 0, contextHeight:int = 0, stageWidth:int = 0, stageHeight:int = 0) {
			_context = context;
			_contextWidth = contextWidth;
			_contextHeight = contextHeight;
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone GameEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new GameEvent(type, bubbles, cancelable, _context, _contextWidth, _contextHeight, _stageWidth, _stageHeight);
		}
		
		/**
		 * Get String value of GameEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("GameEvent", "type", "bubbles", "cancelable", "eventPhase", "context", "contextWidth", "contextHeight", "stageWidth", "stageHeight"); 
		}
		
		
		/**
		 * @private
		 */
		public function get context():IGameContext {
			return _context;
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
		public function get contextHeight():int {
			return _contextHeight;
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
	}
}