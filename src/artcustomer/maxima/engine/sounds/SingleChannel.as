/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine.sounds {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	
	import artcustomer.maxima.engine.sounds.SoundsCache;
	import artcustomer.maxima.events.SingleChannelEvent;
	import artcustomer.maxima.utils.tools.ArrayTools;
	
	[Event(name="onPlaySound", type="artcustomer.maxima.events.SingleChannelEvent")]
	[Event(name="onStopSound", type="artcustomer.maxima.events.SingleChannelEvent")]
	[Event(name="onSoundPlaying", type="artcustomer.maxima.events.SingleChannelEvent")]
	[Event(name="onSoundError", type="artcustomer.maxima.events.SingleChannelEvent")]
	[Event(name="onSoundComplete", type="artcustomer.maxima.events.SingleChannelEvent")]
	[Event(name="onSoundID3", type="artcustomer.maxima.events.SingleChannelEvent")]
	
	
	/**
	 * SingleChannel
	 * 
	 * @author David Massenot
	 */
	public class SingleChannel extends EventDispatcher {
		private static const BUFFER_TIME:int = 5000;
		
		private var _index:int;
		private var _loadedCallback:Function;
		private var _onCompleteCallback:Function;
		
		private var _soundsCache:SoundsCache;
		
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		private var _soundLoaderContext:SoundLoaderContext;
		private var _soundTransform:SoundTransform;
		
		private var _volume:Number;
		private var _channelVolume:Number;
		private var _masterVolume:Number;
		private var _pan:Number;
		
		private var _queue:Array;
		private var _loadedStream:String;
		private var _lastSoundPosition:Number;
		
		private var _isMaster:Boolean;
		private var _isPlaying:Boolean;
		private var _isOnPause:Boolean;
		private var _isMute:Boolean;
		private var _isOnQueue:Boolean;
		private var _isPlayingEventEnable:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function SingleChannel() {
			_isMaster = false;
		}
		
		//---------------------------------------------------------------------
		//  SoundChannel
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupSoundChannel(startTime:Number = 0, loops:int = 0):void {
			if (!_sound) return;
			
			_soundChannel = _sound.play(startTime, loops);
			_soundChannel.addEventListener(Event.SOUND_COMPLETE, handleSound, false, 0, true);
			
			dispatchSingleChannelEvent(SingleChannelEvent.ON_PLAY_SOUND);
		}
		
		/**
		 * @private
		 */
		private function destroySoundChannel():void {
			if (_soundChannel) {
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, handleSound);
				_soundChannel.stop();
				_soundChannel = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  Sound
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupSound(sound:Sound = null):void {
			_sound = sound || new Sound();
			if (!_sound.hasEventListener(Event.ID3)) _sound.addEventListener(Event.ID3, handleSound, false, 0, true);
			if (!_sound.hasEventListener(Event.COMPLETE)) _sound.addEventListener(Event.COMPLETE, handleSound, false, 0, true);
			if (!_sound.hasEventListener(IOErrorEvent.IO_ERROR)) _sound.addEventListener(IOErrorEvent.IO_ERROR, handleSoundError, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function destroySound():void {
			if (_sound) {
				_sound.removeEventListener(Event.ID3, handleSound);
				_sound.removeEventListener(Event.COMPLETE, handleSound);
				_sound.removeEventListener(IOErrorEvent.IO_ERROR, handleSoundError);
				
				try {
					_sound.close();
				} catch (er:Error) {
					
				}
				
				_sound = null;
			}
		}
		
		/**
		 * @private
		 */
		private function loadSound(stream:String):void {
			if (_sound && !_sound.url) _sound.load(new URLRequest(stream), _soundLoaderContext);
		}
		
		//---------------------------------------------------------------------
		//  SoundLoaderContext
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupSoundLoaderContext():void {
			_soundLoaderContext = new SoundLoaderContext(BUFFER_TIME, true);
		}
		
		/**
		 * @private
		 */
		private function destroySoundLoaderContext():void {
			_soundLoaderContext = null;
		}
		
		//---------------------------------------------------------------------
		//  SoundTransform
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function applySoundTransform():void {
			if (!_soundTransform || !_soundChannel) return;
			
			_soundTransform.volume = _channelVolume;
			_soundTransform.pan = _pan;
			_soundChannel.soundTransform = _soundTransform;
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleSound(e:Event):void {
			switch (e.type) {
				case(Event.ID3):
					dispatchSingleChannelEvent(SingleChannelEvent.ON_SOUND_ID3);
					break;
					
				case(Event.COMPLETE):
					if (_loadedCallback != null) _loadedCallback.call(null, _loadedStream, _sound);
					break;
					
				case(Event.SOUND_COMPLETE):
					_isPlaying = false;
					if (_onCompleteCallback != null) _onCompleteCallback.call(null);
					
					dispatchSingleChannelEvent(SingleChannelEvent.ON_SOUND_COMPLETE);
					
					if (_queue.length > 0) playFromQueue();
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleSoundError(e:IOErrorEvent):void {
			switch (e.type) {
				case(IOErrorEvent.IO_ERROR):
					trace('Sound not found :', _loadedStream);
					
					_isPlaying = false;
					
					dispatchSingleChannelEvent(SingleChannelEvent.ON_SOUND_ERROR, e.text);
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  Event Dispatching
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function dispatchSingleChannelEvent(type:String, error:String = null):void {
			this.dispatchEvent(new SingleChannelEvent(type, false, false, _index, _loadedStream, _isMaster, error));
		}
		
		//---------------------------------------------------------------------
		//  Queue
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function playFromQueue(begin:int = 0, loops:int = 0):void {
			if (_queue.length == 0) {
				_isPlaying = false;
				
				return;
			}
			
			var tmpSoundObject:Object = _queue.shift();
			
			destroySound();
			setupSound(tmpSoundObject as Sound);
			if (tmpSoundObject is String) loadSound(String(tmpSoundObject));
			destroySoundChannel();
			setupSoundChannel(begin, loops);
			applySoundTransform();
			
			_loadedStream = _sound.url || String(tmpSoundObject);
			_isPlaying = true;
		}
		
		
		/**
		 * Setup / Recycle.
		 * 
		 * @param	loadedCallback
		 */
		internal function setup(loadedCallback:Function):void {
			_loadedCallback = loadedCallback;
			_volume = 1;
			_channelVolume = 1;
			_masterVolume = 1;
			_pan = 0;
			_isPlaying = false;
			_isMute = false;
			_isOnPause = false;
			_isOnQueue = false;
			_queue = new Array();
			
			_soundsCache = SoundsCache.getInstance();
			
			if (!_soundTransform) _soundTransform = new SoundTransform();
		}
		
		/**
		 * Dispose channel.
		 */
		internal function dispose():void {
			_lastSoundPosition = 0;
		}
		
		/**
		 * Destructor.
		 */
		internal function destroy():void {
			_soundTransform = null;
			_loadedStream = null;
			_index = 0;
			_volume = 0;
			_channelVolume = 0;
			_masterVolume = 0;
			_pan = 0;
			_lastSoundPosition = 0;
			_isMaster = false;
			_isPlaying = false;
			_isMute = false;
			_isOnQueue = false;
			_queue.length = 0;
			_queue = null;
			_soundsCache = null;
		}
		
		/**
		 * @private
		 */
		internal function setIndex(value:int):void {
			_index = value;
			
			if (_index == 0) _isMaster = true;
		}
		
		/**
		 * Update channel volume with master volume.
		 * 
		 * @param	masterVolume
		 */
		internal function setMasterVolume(masterVolume:Number):void {
			_masterVolume = masterVolume;
			_channelVolume = _volume * _masterVolume;
			
			applySoundTransform();
		}
		
		/**
		 * Play sound with Sound object.
		 * 
		 * @param	sound
		 * @param	begin
		 * @param	loops
		 * @param	onComplete
		 */
		public function playSound(sound:Sound, begin:int = 0, loops:int = 0, onComplete:Function = null):void {
			if (!sound) return;
			
			_lastSoundPosition = 0;
			_onCompleteCallback = onComplete;
			_queue.length = 0;
			_queue.push(sound);
			
			playFromQueue();
		}
		
		/**
		 * Play sound with stream URL.
		 * 
		 * @param	stream
		 * @param	begin
		 * @param	loops
		 * @param	onComplete
		 */
		public function playStream(stream:String, begin:int = 0, loops:int = 0, onComplete:Function = null):void {
			if (!stream) return;
			
			_lastSoundPosition = 0;
			_onCompleteCallback = onComplete;
			_loadedStream = stream;
			_queue.length = 0;
			
			if (_soundsCache.hasSound(stream)) {
				_queue.push(_soundsCache.getSound(stream));
			} else {
				_queue.push(stream);
			}
			
			playFromQueue();
		}
		
		/**
		 * Queue sounds with stream URL or Sound object.
		 * 
		 * @param	streams : Array of streams (String format or Sound format)
		 * @param	resetLastQueue : Clear or add in last queue.
		 */
		public function queueStreams(streams:Array, resetLastQueue:Boolean = false):void {
			if (resetLastQueue) _queue.length = 0;
			_queue = ArrayTools.add(_queue, streams);
			
			if (!_isPlaying) playFromQueue();
		}
		
		/**
		 * Play sound.
		 */
		public function play():void {
			_isPlaying = true;
			_lastSoundPosition = 0;
			
			setupSoundChannel();
		}
		
		/**
		 * Pause sound.
		 */
		public function pause():void {
			if (!_isOnPause) {
				_isOnPause = true;
				_lastSoundPosition = _soundChannel.position;
				
				destroySoundChannel();
			}
		}
		
		/**
		 * Resume sound.
		 * 
		 * @param	resetPosition : True to reset sound position / False to play at last sound position
		 */
		public function resume(resetPosition:Boolean = false):void {
			if (_isOnPause) {
				_isOnPause = false;
				
				setupSoundChannel(resetPosition == true ? 0 : _lastSoundPosition, 0);
			}
		}
		
		/**
		 * Pause sound.
		 */
		public function stop():void {
			if (_isPlaying) {
				_isPlaying = false;
				_lastSoundPosition = 0;
				
				destroySoundChannel();
				dispatchSingleChannelEvent(SingleChannelEvent.ON_STOP_SOUND);
			}
		}
		
		/**
		 * Set volume on sound.
		 * 
		 * @param	volume : [0, 1]
		 */
		public function setVolume(volume:Number):void {
			if (volume < 0) volume = 0;
			if (volume > 1) volume = 1;
			
			_volume = volume;
			_channelVolume = _volume;
			
			applySoundTransform();
		}
		
		/**
		 * Set pan on sound.
		 * 
		 * @param	pan
		 */
		public function setPan(pan:Number):void {
			_pan = pan;
			
			applySoundTransform();
		}
		
		/**
		 * Mute sound.
		 */
		public function mute():void {
			if (!_isMute) {
				_isMute = true;
				_channelVolume = 0;
				
				applySoundTransform();
			}
		}
		
		/**
		 * Unmute sound.
		 */
		public function unMute():void {
			if (_isMute) {
				_isMute = false;
				_channelVolume = _volume * _masterVolume;
				
				applySoundTransform();
			}
		}
		
		/**
		 * Call this method to enable ON_SOUND_PLAYING event dispatching.
		 */
		public function enablePlayingEvent():void {
			if (!_isPlayingEventEnable) {
				_isPlayingEventEnable = true;
				
				// TODO
			}
		}
		
		/**
		 * Call this method to disable ON_SOUND_PLAYING event dispatching.
		 */
		public function disablePlayingEvent():void {
			if (_isPlayingEventEnable) {
				_isPlayingEventEnable = false;
				
				// TODO
			}
		}
		
		
		/**
		 * @private
		 */
		public function get index():int {
			return _index;
		}
		
		/**
		 * @private
		 */
		public function get volume():Number {
			return _volume;
		}
		
		/**
		 * @private
		 */
		public function get pan():Number {
			return _pan;
		}
		
		/**
		 * @private
		 */
		public function get position():Number {
			if (_soundChannel) return _soundChannel.position;
			return 0;
		}
		
		/**
		 * @private
		 */
		public function get lastPosition():Number {
			return _lastSoundPosition;
		}
		
		/**
		 * @private
		 */
		public function get isMaster():Boolean {
			return _isMaster;
		}
		
		/**
		 * @private
		 */
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		/**
		 * @private
		 */
		public function get isMute():Boolean {
			return _isMute;
		}
		
		/**
		 * @private
		 */
		public function get isOnPause():Boolean {
			return _isOnPause;
		}
	}
}