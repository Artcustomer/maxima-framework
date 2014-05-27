/*
 * Cartcustomer.maxima.process.timettp://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.process.time {
	import flash.events.Event;
	
	
	/**
	 * CountdownEvent
	 * 
	 * @author David Massenot
	 */
	public class CountdownEvent extends Event {
		public static const ON_START_COUNTDOWN:String = 'onStartCountdown';
		public static const ON_STOP_COUNTDOWN:String = 'onStopCountdown';
		public static const ON_END_COUNTDOWN:String = 'onEndCountdown';
		public static const ON_TIMER_COUNTDOWN:String = 'onTimerCountdown';
		
		private var _days:String;
		private var _hours:String;
		private var _minutes:String;
		private var _seconds:String;
		private var _percent:Number;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	days
		 * @param	hours
		 * @param	minutes
		 * @param	seconds
		 * @param	percent
		 */
		public function CountdownEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, days:String = null, hours:String = null, minutes:String = null, seconds:String = null, percent:Number = 0) {
			_days = days;
			_hours = hours;
			_minutes = minutes;
			_seconds = seconds;
			_percent = percent;
			
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clone CountdownEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new CountdownEvent(type, bubbles, cancelable, _days, _hours, _minutes, _seconds, _percent);
		}
		
		/**
		 * Get String format of CountdownEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("CountdownEvent", "type", "bubbles", "cancelable", "eventPhase", "days", "hours", "minutes", "seconds", "percent"); 
		}
		
		
		/**
		 * @private
		 */
		public function get days():String {
			return _days;
		}
		
		/**
		 * @private
		 */
		public function get hours():String {
			return _hours;
		}
		
		/**
		 * @private
		 */
		public function get minutes():String {
			return _minutes;
		}
		
		/**
		 * @private
		 */
		public function get seconds():String {
			return _seconds;
		}
		
		/**
		 * @private
		 */
		public function get percent():Number {
			return _percent;
		}
	}
}