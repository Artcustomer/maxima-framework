package artcustomer.maxima.engine {
	import flash.display.Bitmap;
	
	import artcustomer.maxima.engine.AssetsLoader;
	import artcustomer.maxima.engine.AbstractStarlingDisplayCoreEngine;
	import artcustomer.maxima.utils.tools.BitmapTools;
	
	import starling.display.*;
	
	
	/**
	 * StarlingUIEngine
	 * 
	 * @author David Massenot
	 */
	public class StarlingUIEngine extends AbstractStarlingDisplayCoreEngine {
		
		
		/**
		 * Constructor
		 */
		public function StarlingUIEngine() {
			super();
		}
		
		
		/**
		 * Destructor
		 */
		override internal function destroy():void {
			if (this.engineDisplayContainer.numChildren > 0) this.engineDisplayContainer.removeChildren(0, -1, true);
			
			super.destroy();
		}
		
		
		/**
		 * Add child.
		 * 
		 * @param	child
		 * @return
		 */
		public function addChild(child:DisplayObject):DisplayObject {
			return this.engineDisplayContainer.addChild(child);
		}
		
		/**
		 * Add child at index.
		 * 
		 * @param	child
		 * @param	index
		 * @return
		 */
		public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			return this.engineDisplayContainer.addChildAt(child, index);
		}
		
		/**
		 * Remove child.
		 * 
		 * @param	child
		 * @param	dispose
		 */
		public function removeChild(child:DisplayObject, dispose:Boolean = false):DisplayObject {
			return this.engineDisplayContainer.removeChild(child, dispose);
		}
		
		/**
		 * Remove child at index.
		 * 
		 * @param	index
		 * @param	dispose
		 * @return
		 */
		public function removeChildAt(index:int, dispose:Boolean = false):DisplayObject {
			return this.engineDisplayContainer.removeChildAt(index, dispose);
		}
		
		/**
		 * Removes a range of children from the container (endIndex included). 
         * If no arguments are given, all children will be removed.
		 * 
		 * @param	beginIndex
		 * @param	endIndex
		 * @param	dispose
		 */
		public function removeChildren(beginIndex:int = 0, endIndex:int = -1, dispose:Boolean = false):void {
			this.engineDisplayContainer.removeChildren(beginIndex, endIndex, dispose);
		}
		
		/**
		 * Get child at index.
		 * 
		 * @param	index
		 * @return
		 */
		public function getChildAt(index:int):DisplayObject {
			return this.engineDisplayContainer.getChildAt(index);
		}
		
		/**
		 * Get child by name.
		 * 
		 * @param	index
		 * @return
		 */
		public function getChildByName(name:String):DisplayObject {
			return this.engineDisplayContainer.getChildByName(name);
		}
		
		/**
		 * Get Starling Image from asset file name in AssetsLoader.
		 * You can resize (width OR height) oand/or rescale bitmap source before create the image. 
		 * 
		 * @param	assetsFileName
		 * @param	scaleFactor
		 * @param	assetsScale
		 * @param	maxWidth
		 * @param	maxHeight
		 * @param	generateMipMaps
		 * @return
		 */
		public function getImageFromAssetsLoader(assetsFileName:String, scaleFactor:Number = 1, assetsScale:Number = 1, maxWidth:int = 0, maxHeight:int = 0, generateMipMaps:Boolean = false):Image {
			var bitmap:Bitmap = this.context.instance.assetsLoader.getAssetByFile(assetsFileName).data as Bitmap;
			if (maxWidth > 0) bitmap = BitmapTools.resize(bitmap, maxWidth);
			if (maxHeight > 0) bitmap = BitmapTools.resize(bitmap, maxHeight, BitmapTools.RESIZE_FROM_HEIGHT);
			if (assetsScale != 1) bitmap = BitmapTools.scale(bitmap.bitmapData, assetsScale);
			
			return Image.fromBitmap(bitmap, generateMipMaps, scaleFactor);
		}
	}
}