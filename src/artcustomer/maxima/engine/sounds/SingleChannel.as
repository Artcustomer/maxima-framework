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
	
	import artcustomer.maxima.events.SingleChannelEvent;
	
	[Event(name="onPlaySound", type="artcustomer.maxima.events.SingleChannelEvent")]
	[Event(name="onStopSound", type="artcustomer.maxima.events.SingleChannelEvent")]
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
		
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		private var _soundLoaderContext:SoundLoaderContext;
		private var _soundTransform:SoundTransform;
		
		private var _tempStream:String;
		private var _loadedStream:String;
		
		private var _volume:Number;
		private var _channelVolume:Number;
		private var _masterVolume:Number;
		private var _pan:Number;
		
		private var _lastSoundPosition:Number;
		
		private var _isMaster:Boolean;
		private var _isPlaying:Boolean;
		private var _isMute:Boolean;
		private var _isOnPlay:Boolean;
		private var _isOnPause:Boolean;
		
		
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
		private function setupSound():void {
			if (!_sound) _sound = new Sound();
			if (!_sound.hasEventListener(Event.ID3)) _sound.addEventListener(Event.ID3, handleSound, false, 0, true);
			if (!_sound.hasEventListener(Event.COMPLETE)) _sound.addEventListener(Event.COMPLETE, handleSound, false, 0, true);
			if (!_sound.hasEventListener(IOErrorEvent.IO_ERROR)) _sound.addEventListener(IOErrorEvent.IO_ERROR, handleSoundError, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function resetSound(sound:Sound):void {
			if (!sound) return;
			
			_sound = sound;
			_sound.addEventListener(Event.ID3, handleSound, false, 0, true);
			_sound.addEventListener(IOErrorEvent.IO_ERROR, handleSoundError, false, 0, true);
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
		private function loadSound():void {
			if (_sound) {
				_sound.load(new URLRequest(_tempStream), _soundLoaderContext);
				
				_tempStream = null;
			}
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
					
					dispatchSingleChannelEvent(SingleChannelEvent.ON_SOUND_COMPLETE);
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
			this.dispatchEvent(new SingleChannelEvent(type, false, false, _index, _tempStream, _isMaster, error));
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
			_isOnPlay = false;
			_isOnPause = false;
			
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
			_tempStream = null;
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
		 */
		public function playSound(sound:Sound, begin:int = 0, loops:int = 0):void {
			if (!sound) return;
			
			_lastSoundPosition = 0;
			
			destroySound();
			resetSound(sound);
			destroySoundChannel();
			setupSoundChannel(begin, loops);
			applySoundTransform();
			
			_tempStream = _sound.url;
			_isPlaying = true;
		}
		
		/**
		 * Play sound with stream URL.
		 * 
		 * @param	stream
		 * @param	begin
		 * @param	loops
		 */
		public function playStream(stream:String, begin:int = 0, loops:int = 0):void {
			if (!stream) return;
			
			_tempStream = stream;
			_loadedStream = stream;
			_lastSoundPosition = 0;
			
			destroySound();
			setupSound();
			loadSound();
			destroySoundChannel();
			setupSoundChannel(begin, loops);
			applySoundTransform();
			
			_isPlaying = true;
		}
		
		/**
		 * Play sound.
		 */
		public function play():void {
			_isOnPlay = true;
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
		 * Pause sound.
		 */
		public function resume():void {
			if (_isOnPause) {
				_isOnPause = false;
				
				setupSoundChannel(_lastSoundPosition, 0);
			}
		}
		
		/**
		 * Pause sound.
		 */
		public function stop():void {
			if (_isOnPlay) {
				_isOnPlay = false;
				_lastSoundPosition = 0;
				
				destroySoundChannel();
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
		public function get isOnPlay():Boolean {
			return _isOnPlay;
		}
		
		/**
		 * @private
		 */
		public function get isOnPause():Boolean {
			return _isOnPause;
		}
	}
}