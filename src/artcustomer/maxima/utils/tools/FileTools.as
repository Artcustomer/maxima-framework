/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.utils.tools {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.net.FileFilter;
	
	
	/**
	 * FileTools : Tools for files.
	 * 
	 * @author David Massenot
	 */
	public class FileTools {
		private static const SIZE_LEVELS:Array = ['octet(s)', 'Ko', 'Mo', 'Go', 'To', 'Po', 'Eo', 'Zo', 'Yo'];
		
		
		/**
		 * Get a file extension.
		 * 
		 * @param file
		 * @return String extension
		 */
		public static function getExtension(file:String):String {
			return file.substring(file.lastIndexOf('.') + 1, file.length);
		}
		
		/**
		 * Get a file in a path
		 * 
		 * @param path
		 * @return String file
		 */
		public static function resolveFileInPath(path:String):String {
			return path.substr(path.lastIndexOf('/') + 1);
		}
		
		/**
		 * Get file name without extension
		 * 
		 * @param file
		 * @return String file
		 */
		public static function resolveFileName(file:String):String {
			return file.substr(0, file.lastIndexOf('.'));
		}
		
		/**
		 * Escape scale and rename file.
		 * 
		 * @param	file
		 * @param	scale
		 * @return
		 */
		public static function escapeScaleFromFileName(file:String, scale:Number):String {
			if (file.indexOf('{0}') != -1) file = file.split('{0}').join(scale.toString());
			
			return file;
		}
		
		/**
		 * Escape lang and rename file.
		 * 
		 * @param	file
		 * @param	lang
		 * @return
		 */
		public static function escapeLangFromFileName(file:String, lang:String):String {
			if (file.indexOf('{lang}') != -1) file = file.split('{lang}').join(lang);
			
			return file;
		}
		
		/**
		 * Convert bytes to String format.
		 * 
		 * @param	bytes
		 * @return
		 */
		public static function bytesToString(bytes:Number):String {
			var index:uint = Math.floor(Math.log(bytes) / Math.log(1024));
			return (bytes / Math.pow(1024, index)).toFixed(2) + ' ' + SIZE_LEVELS[index];
		}
		
		
		/**
		 * @private
		 */
		public static function get imagesFilter():FileFilter {
			return new FileFilter("Images", "*.jpg; *.gif; *.png");
		}
		
		/**
		 * @private
		 */
		public static function get docsFilter():FileFilter {
			return new FileFilter("Documents", "*.pdf; *.doc; *.txt");
		}
	}
}