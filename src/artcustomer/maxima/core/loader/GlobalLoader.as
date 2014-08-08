/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core.loader {
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.core.AbstractEngineDisplayObject;
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.events.AssetsLoaderEvent;
	import artcustomer.maxima.engine.AssetsLoader;
	import artcustomer.maxima.engine.assets.*;
	
	
	/**
	 * GlobalLoader
	 * 
	 * @author David Massenot
	 */
	public class GlobalLoader extends AbstractEngineDisplayObject {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.core.loader::GlobalLoader';
		
		private var _assetsLoader:AssetsLoader;
		
		
		/**
		 * Constructor
		 * 
		 * @param	aName : Name of the object, used as key in NavigationSystem. Required !
		 */
		public function GlobalLoader(aName:String) {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_ABSTRACT_CLASS);
			if (!aName) throw new GameError(GameError.E_NULL_CORE_NAME);
			
			this.name = aName;
		}
		
		//---------------------------------------------------------------------
		//  AssetsLoader
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleAssetsLoader(e:AssetsLoaderEvent):void {
			switch (e.type) {
				case(AssetsLoaderEvent.LOADING_START):
					onStartLoading(e);
					break;
					
				case(AssetsLoaderEvent.LOADING_CLOSE):
					onCloseLoading(e);
					break;
					
				case(AssetsLoaderEvent.LOADING_PROGRESS):
					onProgressLoading(e);
					break;
					
				case(AssetsLoaderEvent.LOADING_ERROR):
					onErrorLoading(e);
					break;
					
				case(AssetsLoaderEvent.LOADING_COMPLETE):
					onCompleteLoading(e);
					break;
					
				default:
					break;
			}
			
			e.stopPropagation();
		}
		
		
		/**
		 * AssetsLoaderEvent.LOADING_START Callback. Override it !
		 * 
		 * @param	e
		 */
		protected function onStartLoading(e:AssetsLoaderEvent):void {
			
		}
		
		/**
		 * AssetsLoaderEvent.LOADING_CLOSE Callback. Override it !
		 * 
		 * @param	e
		 */
		protected function onCloseLoading(e:AssetsLoaderEvent):void {
			
		}
		
		/**
		 * AssetsLoaderEvent.LOADING_PROGRESS Callback. Override it !
		 * 
		 * @param	e
		 */
		protected function onProgressLoading(e:AssetsLoaderEvent):void {
			
		}
		
		/**
		 * AssetsLoaderEvent.LOADING_ERROR Callback. Override it !
		 * 
		 * @param	e
		 */
		protected function onErrorLoading(e:AssetsLoaderEvent):void {
			
		}
		
		/**
		 * AssetsLoaderEvent.LOADING_PROGRESS Callback. Override it !
		 * 
		 * @param	e
		 */
		protected function onCompleteLoading(e:AssetsLoaderEvent):void {
			
		}
		
		/**
		 * Entry point. Override it and call at begin !
		 */
		override protected function onEntry():void {
			_assetsLoader = this.context.instance.assetsLoader;
			_assetsLoader.addEventListener(AssetsLoaderEvent.LOADING_START, handleAssetsLoader, false, 0, true);
			_assetsLoader.addEventListener(AssetsLoaderEvent.LOADING_CLOSE, handleAssetsLoader, false, 0, true);
			_assetsLoader.addEventListener(AssetsLoaderEvent.LOADING_PROGRESS, handleAssetsLoader, false, 0, true);
			_assetsLoader.addEventListener(AssetsLoaderEvent.LOADING_ERROR, handleAssetsLoader, false, 0, true);
			_assetsLoader.addEventListener(AssetsLoaderEvent.LOADING_COMPLETE, handleAssetsLoader, false, 0, true);
			
			super.onEntry();
		}
		
		/**
		 * Exit point. Override it and call at end !
		 */
		override protected function onExit():void {
			super.onExit();
		}
		
		/**
		 * Destructor. Override it and call at end !
		 */
		override protected function destroy():void {
			_assetsLoader.removeEventListener(AssetsLoaderEvent.LOADING_START, handleAssetsLoader);
			_assetsLoader.removeEventListener(AssetsLoaderEvent.LOADING_CLOSE, handleAssetsLoader);
			_assetsLoader.removeEventListener(AssetsLoaderEvent.LOADING_PROGRESS, handleAssetsLoader);
			_assetsLoader.removeEventListener(AssetsLoaderEvent.LOADING_ERROR, handleAssetsLoader);
			_assetsLoader.removeEventListener(AssetsLoaderEvent.LOADING_COMPLETE, handleAssetsLoader);
			_assetsLoader = null;
			
			super.destroy();
		}
		
		/**
		 * Add file in queue.
		 * 
		 * @param	source : File
		 * @param	name : Name (id)
		 * @param	group : Useful to group some assets
		 */
		public final function queueAsset(source:String, name:String, group:String = 'assets'):void {
			_assetsLoader.queueAsset(source, name, group);
		}
		
		/**
		 * Load queue on AssetsLoader.
		 * 
		 * @param	description
		 */
		public final function load(id:String = 'loading', description:String = 'loading assets'):void {
			_assetsLoader.loadQueue(id, description);
		}
		
		/**
		 * Load queue on AssetsLoader
		 */
		public final function unload():void {
			_assetsLoader.unloadQueue();
		}
		
		
		/**
		 * @private
		 */
		public function get assetsLoader():AssetsLoader {
			return _assetsLoader;
		}
	}
}