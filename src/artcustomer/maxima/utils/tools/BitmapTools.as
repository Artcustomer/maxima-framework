/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.utils.tools {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	
	/**
	 * BitmapTools : Tools for booleans.
	 * 
	 * @author David Massenot
	 */
	public class BitmapTools {
		public static const RESIZE_FROM_WIDTH:String = 'width';
		public static const RESIZE_FROM_HEIGHT:String = 'height';
		
		
		/**
		 * Create and return a new Bitmap that fit in bounds.
		 * 
		 * @param	pBitmap
		 * @param	pWidth
		 * @param	pHeight
		 * @param	pCenter
		 * @param	pFillBox
		 * @return
		 */
		public static function fit(pBitmap:Bitmap, pWidth:Number, pHeight:Number, pCenter:Boolean = true, pFillBox:Boolean = true):Bitmap {
			var tempW:Number = pBitmap.width;
			var tempH:Number = pBitmap.height;
			
			pBitmap.width = pWidth;
			pBitmap.height = pHeight;
		 
			var scale:Number = (pFillBox) ? Math.max(pBitmap.scaleX, pBitmap.scaleY) : Math.min(pBitmap.scaleX, pBitmap.scaleY);
		 
			pBitmap.width = tempW;
			pBitmap.height = tempH;
		 
			var scaleBmpd:BitmapData = new BitmapData(pBitmap.width * scale, pBitmap.height * scale);
			var scaledBitmap:Bitmap = new Bitmap(scaleBmpd, PixelSnapping.ALWAYS, true);
			var scaleMatrix:Matrix = new Matrix();
			
			scaleMatrix.scale(scale, scale);
			scaleBmpd.draw(pBitmap, scaleMatrix);
		 
			if (scaledBitmap.width > pWidth || scaledBitmap.height > pHeight) {
				var cropMatrix:Matrix = new Matrix();
				var cropArea:Rectangle = new Rectangle(0, 0, pWidth, pHeight);
				var croppedBmpd:BitmapData = new BitmapData(pWidth, pHeight);
				var croppedBitmap:Bitmap = new Bitmap(croppedBmpd, PixelSnapping.ALWAYS, true);
				
				if (pCenter) {
					var offsetX:Number = Math.abs((pWidth - scaleBmpd.width) / 2);
					var offsetY:Number = Math.abs((pHeight - scaleBmpd.height) / 2);
					
					cropMatrix.translate(-offsetX, -offsetY);
				}
				
				croppedBmpd.draw(scaledBitmap, cropMatrix, null, null, cropArea, true);
				
				return croppedBitmap;
			} else {
				return scaledBitmap;
			}
		}
		
		/**
		 * Resize bitmap image and return new Bitmap.
		 * 
		 * @param	bmpSrc
		 * @param	maxSize
		 * @param	ratio
		 * @return
		 */
		public static function resize(bmpSrc:Bitmap, maxSize:int, ratio:String = RESIZE_FROM_WIDTH):Bitmap {
			if (!bmpSrc) return null;
			
			var width:int;
			var height:int;
			var nScaleX:Number;
			var nScaleY:Number;
			var nScale:Number;
			var matrix:Matrix = new Matrix();
			var bitmapdata:BitmapData;
			var factor:Number;
			
			switch (ratio) {
				case(RESIZE_FROM_WIDTH):
					factor = Math.min((maxSize / bmpSrc.width), 1);
					break;
					
				case(RESIZE_FROM_HEIGHT):
					factor = Math.min(1, (maxSize / bmpSrc.height));
					break;
					
				default:
					factor = Math.min(1, (maxSize / Math.max(bmpSrc.width, bmpSrc.height)));
					break;
			}
			
			bmpSrc.smoothing = true;
			
			width = bmpSrc.width * factor;
			height = bmpSrc.height * factor;
			
			nScaleX = (width / bmpSrc.width);
			nScaleY = (height / bmpSrc.height);
			nScale = Math.max(nScaleY, nScaleX);
			
			matrix.scale(nScale, nScale);
			
			bitmapdata = new BitmapData(width, height, true, 0);
			bitmapdata.draw(bmpSrc, matrix, null, null, null, true);
			
			return new Bitmap(bitmapdata, PixelSnapping.ALWAYS, true);
		}
		
		/**
		 * Get thumbnail from bitmap.
		 * 
		 * @param	bmpSrc
		 * @param	size
		 * @return
		 */
		public static function getThumbFrom(bmpSrc:Bitmap, size:int):Bitmap {
			if (!bmpSrc) return null;
			
			var thumbSize:int;
			var matrix:Matrix = new Matrix();
			var bitmapdata:BitmapData;
			var square:int = Math.min(bmpSrc.width, bmpSrc.height);
			var scale:Number = Math.min(1, (size / square));
			
			bmpSrc.smoothing = true;
			
			thumbSize = square * scale;
			
			matrix.translate(-((bmpSrc.width - square) >> 1), -((bmpSrc.height - square) >> 1));
			matrix.scale(scale, scale);
			
			bitmapdata = new BitmapData(thumbSize, thumbSize, true, 0);
			bitmapdata.draw(bmpSrc, matrix, null, null, null, true);
			
			return new Bitmap(bitmapdata, PixelSnapping.ALWAYS, true);
		}
		
		/**
		 * Rescale Bitmap.
		 * 
		 * @param	pBmpSrc
		 * @param	pScale
		 */
		public static function rescale(pBmpSrc:Bitmap, pScale:Number):void {
			if (!pBmpSrc) return;
			
			var matrix:Matrix = pBmpSrc.transform.matrix;
			matrix.scale(pScale, pScale);
			
			pBmpSrc.transform.matrix = matrix;
			
			/*scale = Math.abs(scale);
            var width:int = (bitmapData.width * scale) || 1;
            var height:int = (bitmapData.height * scale) || 1;
            var transparent:Boolean = bitmapData.transparent;
            var result:BitmapData = new BitmapData(width, height, transparent);
            var matrix:Matrix = new Matrix();
            matrix.scale(scale, scale);
            result.draw(bitmapData, matrix);
            return result;*/
		}
		
		/**
		 * Draw scaled Bitmap from BitmapData source.
		 * 
		 * @param	pBmpDataSrc
		 * @param	pScale
		 */
		public static function scale(pBmpDataSrc:BitmapData, pScale:Number):Bitmap {
			var matrix:Matrix = new Matrix();
			matrix.scale(pScale, pScale);
			
			var smallBMD:BitmapData = new BitmapData(pBmpDataSrc.width * pScale, pBmpDataSrc.height * pScale, true, 0x000000);
			smallBMD.draw(pBmpDataSrc, matrix, null, null, null, true);
			
			return new Bitmap(smallBMD, PixelSnapping.NEVER, true);
		}
		
		/**
		 * Clone Bitmap.
		 * 
		 * @param	bmpSrc
		 * @return
		 */
		public static function clone(bmpSrc:Bitmap):Bitmap {
			if (!bmpSrc) return null;
			
			return new Bitmap(bmpSrc.bitmapData.clone(), 'auto', true);
		}
	}
}