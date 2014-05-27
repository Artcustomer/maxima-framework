/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.context{
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.system.ApplicationDomain;
	import flash.system.System;
	import flash.system.Security;
	import flash.net.URLVariables;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.maxima.errors.*;
	import artcustomer.maxima.utils.consts.*;
	
	
	/**
	 * ServiceContext
	 * 
	 * @author David Massenot
	 */
	public class ServiceContext extends CrossPlatformInputsContext {
		private static const FULL_CLASS_NAME:String = 'artcustomer.maxima.context::ServiceContext';
		
		private var _name:String;
		private var _version:String;
		private var _mode:String;
		private var _device:String;
		private var _assetsPath:String;
		private var _storagePath:String;
		
		private var _runtime:String;
		private var _flashVersion:String;
		private var _operatingSystem:String;
		private var _bitsProcessesSupported:String;
		private var _cpuArchitecture:String;
		private var _defaultLanguage:String;
		private var _appLanguage:String;
		private var _framerate:Number;
		private var _parameters:Object;
		private var _manufacturer:String;
		private var _screenDPI:int;
		private var _screenInches:Number;
		
		private var _isPlayerPaused:Boolean;
		private var _isiOS:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function ServiceContext() {
			var w:Number = Capabilities.screenResolutionX;
			var h:Number = Capabilities.screenResolutionY;
			var dpi:Number = Capabilities.screenDPI;
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.decode(Capabilities.serverString);
			
			_screenInches = Math.round(Math.sqrt(Math.pow(w / dpi, 2) + Math.pow(h / dpi, 2)) * 100) / 100;
			_screenDPI = parseInt(urlVariables.DP, 10);
			_runtime = RuntimePlatform.FLASH_PLAYER;
			_flashVersion = Capabilities.version;
			_operatingSystem = Capabilities.os;
			_bitsProcessesSupported = BitProcesses.UNKNOWN_SUPPORT;
			_cpuArchitecture = Capabilities.cpuArchitecture;
			_defaultLanguage = Capabilities.language;
			_appLanguage = ApplicationLanguages.FRENCH;
			_parameters = new Object();
			_name = GameName.DEFAULT_NAME;
			_mode = GameMode.RELEASE;
			_version = '0.0.0.0';
			_assetsPath = '';
			
			if (Capabilities.supports32BitProcesses) _bitsProcessesSupported = BitProcesses.SUPPORT_32_BIT;
			if (Capabilities.supports64BitProcesses) _bitsProcessesSupported = BitProcesses.SUPPORT_64_BIT;
			
			setManufacturer();
			
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalGameError(IllegalGameError.E_SERVICECONTEXT_CONSTRUCTOR);
		}
		
		//---------------------------------------------------------------------
		//  Manufacturer
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setManufacturer():void {
			var manufacturer:String = Capabilities.manufacturer;
			
			if (manufacturer.indexOf(DevicesManufacturers.WINDOWS) != -1) _manufacturer = DevicesManufacturers.WINDOWS;
			if (manufacturer.indexOf(DevicesManufacturers.MAC) != -1) _manufacturer = DevicesManufacturers.MAC;
			if (manufacturer.indexOf(DevicesManufacturers.LINUX) != -1) _manufacturer = DevicesManufacturers.LINUX;
			if (manufacturer.indexOf(DevicesManufacturers.ANDROID) != -1) _manufacturer = DevicesManufacturers.ANDROID;
			if (manufacturer.indexOf(DevicesManufacturers.IOS) != -1) {
				_manufacturer = DevicesManufacturers.IOS;
				_isiOS = true;
			}
		}
		
		
		/**
		 * Setup ServiceContext.
		 */
		override public function setup():void {
			super.setup();
			
			if (this.contextView.loaderInfo) _parameters = this.contextView.loaderInfo.parameters;
		}
		
		/**
		 * Destroy ServiceContext.
		 */
		override public function destroy():void {
			_name = null;
			_mode = null;
			_version = null;
			_assetsPath = null;
			_flashVersion = null;
			_operatingSystem = null;
			_cpuArchitecture = null;
			_defaultLanguage = null
			_appLanguage = null
			_framerate = 0;
			_screenDPI = 0;
			_screenInches = 0;
			_parameters = null;
			_isPlayerPaused = false;
			
			super.destroy();
		}
		
		/**
		 * Get Flash parameter by name.
		 * 
		 * @param	name
		 * @return
		 */
		public function getParameter(name:String):Object {
			if (!_parameters) return null;
			
			return _parameters[name];
		}
		
		/**
		 * Get properties and values of Flash parameters in String format.
		 * 
		 * @return
		 */
		public function dumpParameters():String {
			if (!_parameters) return '';
			
			var dump:String = '';
			var parameter:Object = null;
			var value:Object = null;
			
			for (var o:* in _parameters) {
				parameter = o;
				value = _parameters[o];
				
				dump += '{' + String(parameter) + ' : ' + String(value) + '}\n';
			}
			
			return dump;
		}
		
		/**
		 * Force the garbage collection process.
		 */
		public function releaseMemory():void {
			System.gc();
		}
		
		/**
		 * Exit Flash Player.
		 * 
		 * @param	code : A value to pass to the operating system.
		 */
		public function exitPlayer(code:uint = 0):void {
			System.exit(code);
		}
		
		/**
		 * Pause Flash Player
		 */
		public function pausePlayer():void {
			if (!_isPlayerPaused) {
				_isPlayerPaused = true;
				
				System.pause();
			}
		}
		
		/**
		 * Resume Flash Player
		 */
		public function resumePlayer():void {
			if (_isPlayerPaused) {
				_isPlayerPaused = false;
				
				System.resume();
			}
		}
		
		/**
		 * Allow a domain in application.
		 * 
		 * @param	rest
		 */
		public function allowDomain(...rest):void {
			if (rest && rest.length != 0) Security.allowDomain(rest);
		}
		
		/**
		 * Allow an insecure domain in application.
		 * 
		 * @param	rest
		 */
		public function allowInsecureDomain(...rest):void {
			if (rest && rest.length != 0) Security.allowInsecureDomain(rest);
		}
		
		/**
		 * Load policy file (XML Crossdomain).
		 * 
		 * @param	url
		 */
		public function loadPolicyFile(url:String):void {
			if (url) Security.loadPolicyFile(url);
		}
		
		/**
		 * Get Debug version of Player.
		 * 
		 * @return
		 */
		public function infos():String {
			var t:String = '';
			
			t += '[[ DEBUG PLAYER ]]';
			t += '\n';
			t += 'Runtime : ' + _runtime;
			t += '\n';
			t += 'Version : ' + _flashVersion;
			t += '\n';
			t += 'Framerate : ' + this.framerate;
			t += '\n';
			t += 'Operating system : ' + _operatingSystem;
			t += '\n';
			t += 'Manufacturer : ' + _manufacturer;
			t += '\n';
			t += 'Bits processes supported : ' + _bitsProcessesSupported;
			t += '\n';
			t += 'CPU : ' + _cpuArchitecture;
			t += '\n';
			t += '[[ END DEBUG PLAYER ]]';
			
			return t;
		}
		
		
		/**
		 * @private
		 */
		public function set name(value:String):void {
			_name = value;
		}
		
		/**
		 * @private
		 */
		public function get name():String {
			return _name;
		}
		
		/**
		 * @private
		 */
		public function set version(value:String):void {
			_version = value;
		}
		
		/**
		 * @private
		 */
		public function get version():String {
			return _version;
		}
		
		/**
		 * @private
		 */
		public function set mode(value:String):void {
			_mode = value;
		}
		
		/**
		 * @private
		 */
		public function get mode():String {
			return _mode;
		}
		
		/**
		 * @private
		 */
		public function set assetsPath(value:String):void {
			_assetsPath = value;
		}
		
		/**
		 * @private
		 */
		public function get assetsPath():String {
			return _assetsPath;
		}
		
		/**
		 * @private
		 */
		public function set appLanguage(value:String):void {
			_appLanguage = value;
		}
		
		/**
		 * @private
		 */
		public function get appLanguage():String {
			return _appLanguage;
		}
		
		/**
		 * @private
		 */
		public function get applicationDomain():ApplicationDomain {
			return this.contextView.loaderInfo.applicationDomain;
		}
		
		/**
		 * @private
		 */
		public function get runtime():String {
			return _runtime;
		}
		
		/**
		 * @private
		 */
		public function get flashVersion():String {
			return _flashVersion;
		}
		
		/**
		 * @private
		 */
		public function get operatingSystem():String {
			return _operatingSystem;
		}
		
		/**
		 * @private
		 */
		public function get bitsProcessesSupported():String {
			return _bitsProcessesSupported;
		}
		
		/**
		 * @private
		 */
		public function get cpuArchitecture():String {
			return _cpuArchitecture;
		}
		
		/**
		 * @private
		 */
		public function get defaultLanguage():String {
			return _defaultLanguage;
		}
		
		/**
		 * @private
		 */
		public function get manufacturer():String {
			return _manufacturer;
		}
		
		/**
		 * @private
		 */
		public function get framerate():Number {
			_framerate = this.stageReference.frameRate;
			
			return _framerate;
		}
		
		/**
		 * @private
		 */
		public function get screenDPI():int {
			return _screenDPI;
		}
		
		/**
		 * @private
		 */
		public function get screenInches():Number {
			return _screenInches;
		}
		
		/**
		 * @private
		 */
		public function get parameters():Object {
			return _parameters;
		}
		
		/**
		 * @private
		 */
		public function get isPlayerPaused():Boolean {
			return _isPlayerPaused;
		}
		
		/**
		 * @private
		 */
		public function get isiOS():Boolean {
			return _isiOS;
		}
	}
}