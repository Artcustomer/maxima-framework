/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.proxies.threads {
	//import flash.system.WorkerDomain;
	//import flash.system.Worker;
	//import flash.system.MessageChannel;
	
	import artcustomer.maxima.base.*;
	import artcustomer.maxima.errors.*;
	
	
	/**
	 * MultiThreadProxy : TODO...
	 * 
	 * @author David Massenot
	 */
	public class MultiThreadProxy implements IDestroyable {
		private static var __instance:MultiThreadProxy;
		private static var __allowInstantiation:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function MultiThreadProxy() {
			if (!__allowInstantiation) {
				throw new GameError(GameError.E_MULTITHREADPROXY_CREATE);
				
				return;
			}
		}
		
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			__instance = null;
			__allowInstantiation = false;
		}
		
		/**
		 * Get current Worker.
		 */
		/*public function getCurrentThread():Worker {
			return Worker.current;
		}*/
		
		/**
		 * Get new Worker.
		 */
		/*public function getThread():Worker {
			return null;
		}*/
		
		
		/**
		 * Instantiate MultiThreadProxy.
		 */
		public static function getInstance():MultiThreadProxy {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new MultiThreadProxy();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
		
		
		/**
		 * @private
		 */
		public function get isSupported():Boolean {
			//return Worker.isSupported;
			return false;
		}
	}
}