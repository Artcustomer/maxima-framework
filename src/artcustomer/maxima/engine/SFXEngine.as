/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine {
	import flash.events.Event;
	import flash.media.Sound;
	
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.events.*;
	import artcustomer.maxima.engine.sounds.*;
	
	
	/**
	 * SFXEngine
	 * 
	 * @author David Massenot
	 */
	public class SFXEngine extends AbstractCoreEngine {
		private static const BUFFER_TIME:int = 5000;
		
		private var _channelFactory:ChannelFactory;
		private var _soundsCache:SoundsCache;
		
		private var _volume:Number;
		private var _pan:Number;
		
		private var _isMute:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function SFXEngine() {
			super();
		}
		
		//---------------------------------------------------------------------
		//  Channels
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function onLoadedChannel(stream:String, sound:Sound):void {
			_soundsCache.addSound(stream, sound);
		}
		
		
		/**
		 * Entry point.
		 */
		override internal function setup():void {
			if (this.isSetup) return;
			
			super.setup();
			
			_volume = 1;
			_pan = 0;
			_isMute = false;
			
			_channelFactory = ChannelFactory.getInstance();
			_soundsCache = SoundsCache.getInstance();
			
			this.addChannel();
		}
		
		/**
		 * Destructor
		 */
		override internal function destroy():void {
			_channelFactory.destroy();
			_channelFactory = null;
			
			_soundsCache.destroy();
			_soundsCache = null;
			
			_volume = 0;
			_pan = 0;
			_isMute = false;
			
			super.destroy();
		}
		
		
		/**
		 * Add new channel at highest index.
		 * 
		 * @return
		 */
		public function addChannel():SingleChannel {
			var channel:SingleChannel = _channelFactory.addChannel(onLoadedChannel);
			
			channel.setVolume(channel.volume * _volume);
			channel.setPan(_pan);
			
			return channel;
		}
		
		/**
		 * Get channel at index.
		 * 
		 * @param	index
		 * @return
		 */
		public function getChannelAt(index:int):SingleChannel {
			return _channelFactory.getChannel(index);
		}
		
		/**
		 * Test channel at index.
		 * 
		 * @param	index
		 * @return
		 */
		public function hasChannelAt(index:int):Boolean {
			return _channelFactory.hasChannel(index);
		}
		
		/**
		 * Remove channel at index.
		 * 
		 * @param	index
		 * @return
		 */
		public function disposeChannelAt(index:int):Boolean {
			return _channelFactory.disposeChannel(index);
		}
		
		/**
		 * Play sound on channel.
		 * 
		 * @param	sound
		 * @param	index : 0 is the master channel.
		 * @param	begin
		 * @param	loops
		 */
		public function playSoundOnChannel(sound:Sound, index:int = 0, begin:int = 0, loops:int = 0):void {
			if (index < _channelFactory.numChannels) {
				_channelFactory.getChannel(index).playSound(sound, begin, loops);
			} else {
				throw new GameError(GameError.E_SFX_OVERFLOW);
			}
		}
		
		/**
		 * Play sound by stream on channel.
		 * 
		 * @param	stream
		 * @param	index : 0 is the master channel.
		 * @param	begin
		 * @param	loops
		 */
		public function playStreamOnChannel(stream:String, index:int = 0, begin:int = 0, loops:int = 0):void {
			if (index < _channelFactory.numChannels) {
				if (_soundsCache.hasSound(stream)) {
					_channelFactory.getChannel(index).playSound(_soundsCache.getSound(stream), begin, loops);
				} else {
					_channelFactory.getChannel(index).playStream(stream, begin, loops);
				}
			} else {
				throw new GameError(GameError.E_SFX_OVERFLOW);
			}
		}
		
		/**
		 * Pause channel.
		 * 
		 * @param	index
		 */
		public function pauseChannel(index:int = 0):void {
			if (index < _channelFactory.numChannels) {
				_channelFactory.getChannel(index).pause();
			} else {
				throw new GameError(GameError.E_SFX_OVERFLOW);
			}
		}
		
		/**
		 * Resume channel.
		 * 
		 * @param	index
		 */
		public function resumeChannel(index:int = 0):void {
			if (index < _channelFactory.numChannels) {
				_channelFactory.getChannel(index).resume();
			} else {
				throw new GameError(GameError.E_SFX_OVERFLOW);
			}
		}
		
		/**
		 * Stop channel.
		 * 
		 * @param	index
		 */
		public function stopChannel(index:int = 0):void {
			if (index < _channelFactory.numChannels) {
				_channelFactory.getChannel(index).stop();
			} else {
				throw new GameError(GameError.E_SFX_OVERFLOW);
			}
		}
		
		/**
		 * Remove all channels stored in the pool.
		 */
		public function clearChannelsPool():void {
			_channelFactory.clearPool();
		}
		
		/**
		 * Set volume on master sound.
		 * 
		 * @param	volume : 0, volume, 1
		 */
		public function setVolume(volume:Number):void {
			if (_volume == volume) return;
			if (volume < 0) volume = 0;
			if (volume > 1) volume = 1;
			
			_volume = volume;
			
			_channelFactory.applyMasterVolume(_volume);
		}
		
		/**
		 * Set pan on sound.
		 * 
		 * @param	pan
		 */
		public function setPan(pan:Number):void {
			if (_pan == pan) return;
			
			_pan = pan;
			
			var channel:SingleChannel;
			
			for each (channel in _channelFactory.channels) {
				channel.setPan(_pan);
			}
		}
		
		/**
		 * Mute all channels.
		 */
		public function muteAll():void {
			if (_isMute) return;
			
			_isMute = true;
			
			var channel:SingleChannel;
			
			for each (channel in _channelFactory.channels) {
				channel.mute();
			}
		}
		
		/**
		 * Unmute all channels.
		 */
		public function unMuteAll():void {
			if (!_isMute) return;
			
			_isMute = false;
			
			var channel:SingleChannel;
			
			for each (channel in _channelFactory.channels) {
				channel.unMute();
			}
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
		public function get isMute():Boolean {
			return _isMute;
		}
	}
}