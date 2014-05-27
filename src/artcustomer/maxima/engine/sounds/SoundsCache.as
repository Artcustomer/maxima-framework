/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine.sounds {
	import flash.utils.Dictionary;
	import flash.media.Sound;
	
	import artcustomer.maxima.base.*;
	import artcustomer.maxima.errors.*;
	
	
	/**
	 * SoundsCache
	 * 
	 * @author David Massenot
	 */
	public class SoundsCache implements IDestroyable {
		private static var __instance:SoundsCache;
		private static var __allowInstantiation:Boolean;
		
		private var _cache:Dictionary;
		
		private var _numSounds:int;
		
		
		/**
		 * Constructor
		 */
		public function SoundsCache() {
			if (!__allowInstantiation) {
				throw new IllegalGameError(IllegalGameError.E_SINGLETON_CLASS);
				
				return;
			}
			
			_cache = new Dictionary();
		}
		
		//---------------------------------------------------------------------
		//  Cache
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function disposeCache():void {
			var id:String;
			
			for (id in _cache) {
				_cache[id] = undefined;
				delete _cache[id];
			}
		}
		
		
		/**
		 * Destructor
		 */
		public function destroy():void {
			disposeCache();
			
			_cache = null;
			
			__instance = null;
			__allowInstantiation = false;
			
			_numSounds = 0;
		}
		
		/**
		 * Add control in map.
		 * 
		 * @param	url
		 * @param	sound
		 */
		public function addSound(url:String, sound:Sound):void {
			if (!this.hasSound(url)) {
				_cache[url] = sound;
				
				_numSounds++;
			}
		}
		
		/**
		 * Test url in cache.
		 * 
		 * @param	url
		 * @return
		 */
		public function hasSound(url:String):Boolean {
			return _cache[url] != undefined;
		}
		
		/**
		 * Get sound in cache.
		 * 
		 * @param	url
		 * @return
		 */
		public function getSound(url:String):Sound {
			return _cache[url] as Sound;
		}
		
		
		/**
		 * @private
		 */
		public function get numSounds():int {
			return _numSounds;
		}
		
		
		/**
		 * Instantiate SoundsCache.
		 */
		public static function getInstance():SoundsCache {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new SoundsCache();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
	}
}