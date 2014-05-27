/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.utils.net {
	import air.net.URLMonitor;
	
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	
	import artcustomer.maxima.utils.net.events.InternetConnectionCheckerEvent;
	
	[Event(name = "onServiceAvailable", type = "artcustomer.maxima.utils.net.events.InternetConnectionCheckerEvent")]
	[Event(name = "onServiceUnavailable", type = "artcustomer.maxima.utils.net.events.InternetConnectionCheckerEvent")]
	
	
	/**
	 * InternetConnectionChecker
	 * 
	 * @author David Massenot
	 */
	public class InternetConnectionChecker extends EventDispatcher {
		private var _serverURL:String;
		private var _monitor:URLMonitor;
		
		private var _isAvailable:Boolean;
		
		
		/**
		 * Constructor
		 * 
		 * @param	serverURL
		 */
		public function InternetConnectionChecker(serverURL:String = 'http://google.com/') {
			_serverURL = serverURL;
			
			_monitor = new URLMonitor(new URLRequest(_serverURL));
			_monitor.addEventListener(StatusEvent.STATUS, handleMonitor); 
			_monitor.start();
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleMonitor(e:StatusEvent):void {
			switch (e.type) {
				case(StatusEvent.STATUS):
					_isAvailable = _monitor.available;
					
					var eventType:String = _isAvailable == true ? InternetConnectionCheckerEvent.ON_SERVICE_AVAILABLE : InternetConnectionCheckerEvent.ON_SERVICE_UNAVAILABLE;
					
					this.dispatchEvent(new InternetConnectionCheckerEvent(eventType, false, false, _isAvailable, e.code, e.level));
					break;
					
				default:
					break;
			}
		}
		
		
		/**
		 * Destructor
		 */
		public function destroy():void {
			_monitor.stop();
			_monitor.removeEventListener(StatusEvent.STATUS, handleMonitor); 
			_monitor = null;
		}
		
		
		/**
		 * @private
		 */
		public function get available():Boolean {
			return _isAvailable;
		}
	}
}