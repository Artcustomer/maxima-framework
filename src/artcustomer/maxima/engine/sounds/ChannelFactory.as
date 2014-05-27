/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine.sounds {
	import flash.utils.Dictionary;
	
	import artcustomer.maxima.base.*;
	import artcustomer.maxima.errors.*;
	
	
	/**
	 * ChannelFactory
	 * 
	 * @author David Massenot
	 */
	public class ChannelFactory implements IDestroyable {
		private static var __instance:ChannelFactory;
		private static var __allowInstantiation:Boolean;
		
		private var _pool:Vector.<SingleChannel>;
		private var _stack:Vector.<SingleChannel>;
		
		private var _numChannels:int;
		private var _numChannelsInPool:int;
		
		private var _tempMasterVolume:Number;
		
		
		/**
		 * Constructor
		 */
		public function ChannelFactory() {
			if (!__allowInstantiation) {
				throw new IllegalGameError(IllegalGameError.E_SINGLETON_CLASS);
				
				return;
			}
			
			_numChannels = 0;
			_numChannelsInPool = 0;
			_tempMasterVolume = 1;
			
			_stack = new Vector.<SingleChannel>();
			_pool = new Vector.<SingleChannel>();
		}
		
		//---------------------------------------------------------------------
		//  Stack
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function disposeStack():void {
			while (_stack.length > 0) {
				_stack.shift().destroy();
			}
			
			_stack.length = 0;
		}
		
		//---------------------------------------------------------------------
		//  Pool
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function disposePool():void {
			while (_pool.length > 0) {
				_pool.shift().destroy();
			}
			
			_pool.length = 0;
		}
		
		//---------------------------------------------------------------------
		//  Channels
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function recycleChannel():SingleChannel {
			if (_pool.length > 0) {
				_numChannelsInPool--;
				
				return _pool.pop();
			}
			
			return null;
		}
		
		/**
		 * @private
		 */
		private function storeChannel(channel:SingleChannel):void {
			_pool.push(channel);
			_stack.splice(channel.index, 1);
		}
		
		/**
		 * @private
		 */
		private function updateChannelIndexes():void {
			var channel:SingleChannel;
			var i:int = 0;
			
			for each (channel in _stack) {
				channel.setIndex(i);
				
				i++;
			}
		}
		
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			disposeStack();
			disposePool();
			
			_stack = null;
			_pool = null;
			
			__instance = null;
			__allowInstantiation = false;
			
			_numChannels = 0;
			_numChannelsInPool = 0;
			_tempMasterVolume = 0;
		}
		
		
		/**
		 * Add new channel at highest index.
		 * 
		 * @param	completeCallback
		 * @return
		 */
		public function addChannel(completeCallback:Function):SingleChannel {
			var channel:SingleChannel;
			
			if (_pool.length > 0) {
				channel = recycleChannel()
			} else {
				channel = new SingleChannel();
			}
			
			channel.setup(completeCallback);
			channel.setIndex(_numChannels);
			channel.setMasterVolume(_tempMasterVolume);
			
			_stack.push(channel);
			_numChannels++;
			
			return channel;
		}
		
		/**
		 * Get channel at index.
		 * 
		 * @param	index
		 * @return
		 */
		public function getChannel(index:int):SingleChannel {
			if (this.hasChannel(index)) {
				return _stack[index];
			} else {
				throw new GameError(GameError.E_SFX_OVERFLOW);
			}
			
			return null;
		}
		
		/**
		 * Test channel at index.
		 * 
		 * @param	index
		 * @return
		 */
		public function hasChannel(index:int):Boolean {
			return _stack[index] != null;
		}
		
		/**
		 * Remove channel at index.
		 * 
		 * @param	index
		 * @return
		 */
		public function disposeChannel(index:int):Boolean {
			var channel:SingleChannel;
			
			if (index == 0) {
				throw new GameError(GameError.E_SFX_DISPOSE_MASTER);
				
				return false;
			}
			
			if (this.hasChannel(index)) {
				channel = this.getChannel(index);
				channel.dispose();
				
				storeChannel(channel);
				
				_numChannels--;
				_numChannelsInPool++;
				
				updateChannelIndexes();
			} else {
				throw new GameError(GameError.E_SFX_OVERFLOW);
			}
			
			return false;
		}
		
		/**
		 * Clear pool.
		 */
		public function clearPool():void {
			disposePool();
			
			_numChannelsInPool = 0;
		}
		
		/**
		 * Update all channels volume with master volume.
		 * 
		 * @param	masterVolume
		 */
		public function applyMasterVolume(masterVolume:Number):void {
			_tempMasterVolume = masterVolume;
			
			var channel:SingleChannel;
			
			for each (channel in _stack) {
				channel.setMasterVolume(_tempMasterVolume);
			}
		}
		
		
		/**
		 * @private
		 */
		public function get channels():Vector.<SingleChannel> {
			return _stack;
		}
		
		/**
		 * @private
		 */
		public function get numChannels():int {
			return _numChannels;
		}
		
		/**
		 * @private
		 */
		public function get numChannelsInPool():int {
			return _numChannelsInPool;
		}
		
		
		/**
		 * Instantiate ChannelFactory.
		 */
		public static function getInstance():ChannelFactory {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new ChannelFactory();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
	}
}