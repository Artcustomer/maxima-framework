/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.events {
	import flash.events.Event;
	
	
	/**
	 * SFXEngineEvent
	 * 
	 * @author David Massenot
	 */
	public class SFXEngineEvent extends Event {
		public static const ON_PLAY_SOUND:String = 'onPlaySound';
		public static const ON_STOP_SOUND:String = 'onStopSound';
		public static const ON_SOUND_ERROR:String = 'onSoundError';
		public static const ON_SOUND_COMPLETE:String = 'onSoundComplete';
		public static const ON_SOUND_ID3:String = 'onSoundID3';
		
		private var _soundURL:String;
		private var _error:String;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	soundURL
		 * @param	error
		 */
		public function SFXEngineEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, soundURL:String = null, error:String = null) {
			_soundURL = soundURL;
			_error = error;
			
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clone SFXEngineEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new SFXEngineEvent(type, bubbles, cancelable, _soundURL, _error);
		}
		
		/**
		 * Get String format of SFXEngineEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("SFXEngineEvent", "type", "bubbles", "cancelable", "eventPhase", "soundURL", "error"); 
		}
		
		
		/**
		 * @private
		 */
		public function get soundURL():String {
			return _soundURL;
		}
		
		/**
		 * @private
		 */
		public function get error():String {
			return _error;
		}
	}
}