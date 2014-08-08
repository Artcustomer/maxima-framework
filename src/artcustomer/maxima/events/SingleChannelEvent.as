/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.events {
	import flash.events.Event;
	
	
	/**
	 * SingleChannelEvent
	 * 
	 * @author David Massenot
	 */
	public class SingleChannelEvent extends Event {
		public static const ON_PLAY_SOUND:String = 'onPlaySound';
		public static const ON_STOP_SOUND:String = 'onStopSound';
		public static const ON_SOUND_PLAYING:String = 'onSoundPlaying';
		public static const ON_SOUND_ERROR:String = 'onSoundError';
		public static const ON_SOUND_COMPLETE:String = 'onSoundComplete';
		public static const ON_SOUND_ID3:String = 'onSoundID3';
		
		private var _channelIndex:int;
		private var _soundURL:String;
		private var _isMasterChannel:Boolean;
		private var _soundIndex:int;
		private var _numSounds:int;
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
		public function SingleChannelEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, channelIndex:int = 0, soundURL:String = null, isMasterChannel:Boolean = false, error:String = null) {
			_channelIndex = channelIndex;
			_soundURL = soundURL;
			_isMasterChannel = isMasterChannel;
			_error = error;
			
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clone SingleChannelEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new SingleChannelEvent(type, bubbles, cancelable, _channelIndex, _soundURL, _isMasterChannel, _error);
		}
		
		/**
		 * Get String format of SingleChannelEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("SingleChannelEvent", "type", "bubbles", "cancelable", "eventPhase", "channelIndex", "soundURL", "isMasterChannel", "error"); 
		}
		
		
		/**
		 * @private
		 */
		public function get channelIndex():int {
			return _channelIndex;
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
		public function get isMasterChannel():Boolean {
			return _isMasterChannel;
		}
		
		/**
		 * @private
		 */
		public function get error():String {
			return _error;
		}
	}
}