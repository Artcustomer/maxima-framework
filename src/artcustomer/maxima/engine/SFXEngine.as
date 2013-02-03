/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.events.*;
	
	[Event(name="onPlaySound", type="artcustomer.maxima.events.SFXEngineEvent")]
	[Event(name="onStopSound", type="artcustomer.maxima.events.SFXEngineEvent")]
	[Event(name="onSoundError", type="artcustomer.maxima.events.SFXEngineEvent")]
	[Event(name="onSoundComplete", type="artcustomer.maxima.events.SFXEngineEvent")]
	[Event(name="onSoundID3", type="artcustomer.maxima.events.SFXEngineEvent")]
	
	
	/**
	 * SFXEngine
	 * 
	 * @author David Massenot
	 */
	public class SFXEngine extends AbstractCoreEngine {
		private static const BUFFER_TIME:int = 5000;
		
		private static var __instance:SFXEngine;
		private static var __allowInstantiation:Boolean;
		
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		private var _soundLoaderContext:SoundLoaderContext;
		private var _soundTransform:SoundTransform;
		
		private var _tempStream:String;
		
		private var _volume:Number;
		private var _pan:Number;
		
		private var _isPlaying:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function SFXEngine() {
			super();
			
			if (!__allowInstantiation) {
				throw new GameError(GameError.E_SFXENGINE_CREATE);
				
				return;
			}
		}
		
		//---------------------------------------------------------------------
		//  Initialize
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function init():void {
			_volume = 1;
			_pan = 0;
			_isPlaying = false;
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
			
			dispatchPlayEvent();
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
		private function setupSoundTransform():void {
			_soundTransform = new SoundTransform();
		}
		
		/**
		 * @private
		 */
		private function destroySoundTransform():void {
			_soundTransform = null;
		}
		
		/**
		 * @private
		 */
		private function applySoundTransform():void {
			if (!_soundTransform || !_soundChannel) return;
			
			_soundTransform.volume = _volume;
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
				case('id3'):
					dispatchID3Event();
					break;
					
				case('soundComplete'):
					_isPlaying = false;
					
					dispatchCompleteEvent();
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
				case('ioError'):
					_isPlaying = false;
					
					dispatchErrorEvent(e.text);
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
		private function dispatchPlayEvent():void {
			this.dispatchEvent(new SFXEngineEvent(SFXEngineEvent.ON_PLAY_SOUND, false, false, _tempStream));
		}
		
		/**
		 * @private
		 */
		private function dispatchStopEvent():void {
			this.dispatchEvent(new SFXEngineEvent(SFXEngineEvent.ON_STOP_SOUND, false, false, _tempStream));
		}
		
		/**
		 * @private
		 */
		private function dispatchErrorEvent(error:String):void {
			this.dispatchEvent(new SFXEngineEvent(SFXEngineEvent.ON_SOUND_ERROR, false, false, _tempStream, error));
		}
		
		/**
		 * @private
		 */
		private function dispatchCompleteEvent():void {
			this.dispatchEvent(new SFXEngineEvent(SFXEngineEvent.ON_SOUND_COMPLETE, false, false, _tempStream));
		}
		
		/**
		 * @private
		 */
		private function dispatchID3Event():void {
			this.dispatchEvent(new SFXEngineEvent(SFXEngineEvent.ON_SOUND_ID3, false, false, _tempStream));
		}
		
		
		/**
		 * Entry point.
		 */
		override internal function setup():void {
			if (this.isSetup) return;
			
			super.setup();
			
			init();
			setupSoundLoaderContext();
			setupSoundTransform();
		}
		
		/**
		 * Destructor
		 */
		override internal function destroy():void {
			destroySound();
			destroySoundChannel();
			destroySoundLoaderContext();
			destroySoundTransform();
			
			_tempStream = null;
			_volume = 0;
			_pan = 0;
			_isPlaying = false;
			
			super.destroy();
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
			
			destroySound();
			setupSound();
			loadSound();
			destroySoundChannel();
			setupSoundChannel(begin, loops);
			applySoundTransform();
			
			_isPlaying = true;
		}
		
		/**
		 * Set volume on sound.
		 * 
		 * @param	volume : 0, volume, 1
		 */
		public function setVolume(volume:Number):void {
			if (volume < 0) volume = 0;
			if (volume > 1) volume = 1;
			
			_volume = volume;
			
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
		 * Instantiate SFXEngine.
		 */
		public static function getInstance():SFXEngine {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new SFXEngine();
				__allowInstantiation = false;
			}
			
			return __instance;
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
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
	}
}