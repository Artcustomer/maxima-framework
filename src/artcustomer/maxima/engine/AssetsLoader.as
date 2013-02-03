/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine {
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import artcustomer.maxima.context.*;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.events.*;
	import artcustomer.maxima.engine.assets.*;
	import artcustomer.maxima.engine.assets.medias.AbstractLoadableAsset;
	import artcustomer.maxima.engine.assets.data.*;
	import artcustomer.maxima.utils.consts.AssetLoadingStatus;
	
	[Event(name = "loadingStart", type = "artcustomer.maxima.events.AssetsLoaderEvent")]
	[Event(name = "loadingClose", type = "artcustomer.maxima.events.AssetsLoaderEvent")]
	[Event(name = "loadingProgress", type = "artcustomer.maxima.events.AssetsLoaderEvent")]
	[Event(name = "loadingError", type = "artcustomer.maxima.events.AssetsLoaderEvent")]
	[Event(name = "loadingComplete", type = "artcustomer.maxima.events.AssetsLoaderEvent")]
	
	
	/**
	 * AssetsLoader
	 * 
	 * @author David Massenot
	 */
	public class AssetsLoader extends AbstractCoreEngine {
		private static var __instance:AssetsLoader;
		private static var __allowInstantiation:Boolean;
		
		private var _assetsFactory:AssetsFactory;
		private var _assetsCache:AssetsCache;
		
		private var _description:String;
		
		private var _queue:Vector.<AbstractLoadableAsset>;
		
		private var _loadedAssets:int;
		private var _totalAssets:int;
		
		private var _bytesLoaded:Number;
		private var _bytesTotal:Number;
		private var _progress:Number;
		private var _error:String;
		
		private var _onLoad:Boolean;
		private var _isLoaded:Boolean;
		private var _isUnLoaded:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AssetsLoader() {
			if (!__allowInstantiation) {
				throw new GameError(GameError.E_ASSETSLOADER_CREATE);
				
				return;
			}
			
			init();
		}
		
		//---------------------------------------------------------------------
		//  Loading
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function init():void {
			_loadedAssets = 0;
			_totalAssets = 0;
			_bytesLoaded = 0;
			_bytesTotal = 0;
			_progress = 0;
			_description = '';
			_onLoad = false;
			_isLoaded = false;
			_isUnLoaded = false;
		}
		
		/**
		 * @private
		 */
		private function reset():void {
			_loadedAssets = 0;
			_totalAssets = _queue.length;
			_bytesLoaded = 0;
			_bytesTotal = 0;
			_progress = 0;
			_onLoad = false;
			_isLoaded = false;
			_isUnLoaded = false;
		}
		
		/**
		 * @private
		 */
		private function start():void {
			var loadableAsset:AbstractLoadableAsset;
			
			for each (loadableAsset in _queue) {
				loadableAsset.addEventListener(ProgressEvent.PROGRESS, handleProgressLoadableFile, false, 0, true);
				loadableAsset.addEventListener(LoadableAssetEvent.ASSET_LOADING_ERROR, handleLoadableAsset, false, 0, true);
				loadableAsset.addEventListener(LoadableAssetEvent.ASSET_LOADING_COMPLETE, handleLoadableAsset, false, 0, true);
				
				if (loadableAsset.status == AssetLoadingStatus.WAITING) loadableAsset.load();
			}
			
			this.dispatchEvent(new AssetsLoaderEvent(AssetsLoaderEvent.LOADING_START, true, false, _description, _bytesLoaded, _bytesTotal, _progress, null));
			
			_onLoad = true;
		}
		
		/**
		 * @private
		 */
		private function close():void {
			var loadableAsset:AbstractLoadableAsset;
			
			for each (loadableAsset in _queue) {
				loadableAsset.removeEventListener(ProgressEvent.PROGRESS, handleProgressLoadableFile);
				loadableAsset.removeEventListener(LoadableAssetEvent.ASSET_LOADING_ERROR, handleLoadableAsset);
				loadableAsset.removeEventListener(LoadableAssetEvent.ASSET_LOADING_COMPLETE, handleLoadableAsset);
				loadableAsset.close();
			}
			
			this.dispatchEvent(new AssetsLoaderEvent(AssetsLoaderEvent.LOADING_CLOSE, true, false, _description, _bytesLoaded, _bytesTotal, _progress, null));
			
			_onLoad = false;
		}
		
		/**
		 * @private
		 */
		private function count():void {
			if (_loadedAssets == _totalAssets) {
				close();
				disposeQueue();
				releaseQueue();
				
				_isLoaded = true;
				_progress = 1;
				
				this.dispatchEvent(new AssetsLoaderEvent(AssetsLoaderEvent.LOADING_COMPLETE, true, false, _description, _bytesLoaded, _bytesTotal, _progress, null));
			}
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleProgressLoadableFile(e:ProgressEvent):void {
			var loadableAsset:AbstractLoadableAsset;
			var loaded:Number = 0;
			var total:Number = 0;
			var progress:Number = 0;
			
			for each (loadableAsset in _queue) {
				if (loadableAsset.status == AssetLoadingStatus.LOADING || loadableAsset.status == AssetLoadingStatus.COMPLETED) {
					loaded += loadableAsset.bytesLoaded;
					total += loadableAsset.bytesTotal;
				}
			}
			
			_bytesLoaded = loaded;
			_bytesTotal = total;
			
			progress = loaded / total;
			
			if (progress != 0) {
				_progress = progress;
				
				this.dispatchEvent(new AssetsLoaderEvent(AssetsLoaderEvent.LOADING_PROGRESS, false, false, _description, _bytesLoaded, _bytesTotal, _progress, null));
			}
		}
		
		/**
		 * @private
		 */
		private function handleLoadableAsset(e:LoadableAssetEvent):void {
			switch (e.type) {
				case('assetLoadingError'):
					this.dispatchEvent(new AssetsLoaderEvent(AssetsLoaderEvent.LOADING_ERROR, true, false, _description, _bytesLoaded, _bytesTotal, _progress, e.error));
					break;
					
				case('assetLoadingComplete'):
					addAssetInAssetsCache(e.asset);
					checkComplete();
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function checkComplete():void {
			_loadedAssets++;
			
			count();
		}
		
		//---------------------------------------------------------------------
		//  AssetsFactory
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupAssetsFactory():void {
			_assetsFactory = new AssetsFactory();
		}
		
		/**
		 * @private
		 */
		private function destroyAssetsFactory():void {
			_assetsFactory.destroy();
			_assetsFactory = null;
		}
		
		//---------------------------------------------------------------------
		//  AssetsCache
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupAssetsCache():void {
			_assetsCache = new AssetsCache();
		}
		
		/**
		 * @private
		 */
		private function destroyAssetsCache():void {
			_assetsCache.destroy();
			_assetsCache = null;
		}
		
		/**
		 * @private
		 */
		private function addAssetInAssetsCache(loadableAsset:AbstractLoadableAsset):void {
			var asset:IAsset = _assetsFactory.createAsset(loadableAsset);
			
			_assetsCache.addAsset(asset);
		}
		
		//---------------------------------------------------------------------
		//  Queue
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function createQueue():void {
			if (!_queue) _queue = new Vector.<AbstractLoadableAsset>;
		}
		
		/**
		 * @private
		 */
		private function releaseQueue():void {
			if (_queue) {
				_queue.length = 0;
				_queue = null;
			}
		}
		
		/**
		 * @private
		 */
		private function disposeQueue():void {
			if (!_queue) return;
			
			while (_queue.length > 0) {
				_queue.shift().destroy();
			}
		}
		
		
		/**
		 * Setup.
		 */
		override internal function setup():void {
			super.setup();
			
			setupAssetsCache();
			setupAssetsFactory();
		}
		
		/**
		 * Destructor
		 */
		override internal function destroy():void {
			destroyAssetsCache();
			destroyAssetsFactory();
			disposeQueue();
			releaseQueue();
			_loadedAssets = 0;
			_totalAssets = 0;
			_description = null;
			_bytesLoaded = 0;
			_bytesTotal = 0;
			_progress = 0;
			_error = null;
			_onLoad = false;
			_isLoaded = false;
			_isUnLoaded = false;
			
			super.destroy();
		}
		
		/**
		 * Add file in queue.
		 * 
		 * @param	source : File
		 * @param	name : Name (id)
		 * @param	group : Useful to group some assets
		 */
		public function queueAsset(source:String, name:String, group:String = 'assets'):void {
			if (_onLoad) throw new GameError(GameError.E_ASSETSLOADER_ONLOAD);
			
			var loadableAsset:AbstractLoadableAsset;
			
			if (!_assetsCache.hasAsset(source)) {
				loadableAsset = _assetsFactory.createLoadableAsset(source);
				
				createQueue();
				
				if (loadableAsset) {
					loadableAsset.source = source;
					loadableAsset.name = name;
					loadableAsset.group = group;
					
					_queue.push(loadableAsset);
				} else {
					throw new GameError(GameError.E_FILE_FORMAT);
				}
			}
		}
		
		/**
		 * Load queue.
		 * 
		 * @param	description
		 */
		public function loadQueue(description:String = 'loading'):void {
			if (!_queue || _queue.length == 0) throw new GameError(GameError.E_ASSETSLOADER_EMPTY);
			if (_onLoad) throw new GameError(GameError.E_ASSETSLOADER_ONLOAD);
			
			_description = description;
			_isUnLoaded = false;
			
			reset();
			start();
		}
		
		/**
		 * Unload queue.
		 */
		public function unloadQueue():void {
			if (_isUnLoaded) return;
			if (!_isLoaded && !_onLoad) throw new GameError(GameError.E_ASSETSLOADER_UNLOAD);
			
			_isUnLoaded = true;
			
			close();
			releaseQueue();
		}
		
		/**
		 * Get Asset by source
		 * 
		 * @param	source
		 * @return
		 */
		public function hasAsset(source:String):Boolean {
			return _assetsCache.hasAsset(source);
		}
		
		/**
		 * Get Asset by source
		 * 
		 * @param	source
		 * @return
		 */
		public function getAsset(source:String):IAsset {
			return _assetsCache.getAsset(source);
		}
		
		/**
		 * Get Asset by name
		 * 
		 * @param	name
		 * @return
		 */
		public function getAssetByName(name:String):IAsset {
			return _assetsCache.getAssetByName(name);
		}
		
		/**
		 * Get Asset by file
		 * 
		 * @param	file
		 * @return
		 */
		public function getAssetByFile(file:String):IAsset {
			return _assetsCache.getAssetByFile(file);
		}
		
		/**
		 * Get asset group.
		 * 
		 * @param	group
		 * @return
		 */
		public function getGroup(group:String):Vector.<IAsset> {
			return _assetsCache.getGroup(group);
		}
		
		
		/**
		 * Instantiate AssetsLoader.
		 */
		public static function getInstance():AssetsLoader {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new AssetsLoader();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
		
		
		/**
		 * @private
		 */
		public function get numAssets():int {
			return _assetsCache.numAssets;
		}
	}
}