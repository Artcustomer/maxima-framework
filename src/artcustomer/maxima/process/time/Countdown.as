/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.process.time {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Event(name = "onStartCountdown", type = "artcustomer.game.rezult.process.countdown.CountdownEvent")]
	[Event(name = "onStopCountdown", type = "artcustomer.game.rezult.process.countdown.CountdownEvent")]
	[Event(name = "onEndCountdown", type = "artcustomer.game.rezult.process.countdown.CountdownEvent")]
	[Event(name = "onTimerCountdown", type = "artcustomer.game.rezult.process.countdown.CountdownEvent")]
	
	
	/**
	 * Countdown
	 * 
	 * @author David Massenot
	 */
	public class Countdown extends EventDispatcher {
		private static const TIMER_DELAY:int = 1000;
		private static const NUM_SECONDS:int = 60;
		private static const NUM_MINUTES:int = 60;
		private static const NUM_HOURS:int = 24;
		
		private var _startDate:Date;
		private var _endDate:Date;
		
		private var _days:String;
		private var _hours:String;
		private var _minutes:String;
		private var _seconds:String;
		private var _totalSeconds:Number;
		private var _percent:Number;
		
		private var _timer:Timer;
		
		private var _isStarted:Boolean;
		private var _isPaused:Boolean;
		private var _isComplete:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function Countdown() {
			_isStarted = false;
			_isPaused = false;
			
			setupTimer();
		}
		
		//---------------------------------------------------------------------
		//  Timer
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupTimer():void {
			_timer = new Timer(TIMER_DELAY, 0);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function destroyTimer():void {
			_timer.reset();
			_timer.removeEventListener(TimerEvent.TIMER, handleTimer);
			_timer = null;
		}
		
		/**
		 * @private
		 */
		private function startTimer():void {
			_timer.start();
		}
		
		/**
		 * @private
		 */
		private function stopTimer():void {
			_timer.stop();
		}
		
		/**
		 * @private
		 */
		private function handleTimer(e:TimerEvent):void {
			switch (e.type) {
				case(TimerEvent.TIMER):
					computeTime();
					
					if (_isComplete) {
						this.dispatchEvent(new CountdownEvent(CountdownEvent.ON_END_COUNTDOWN, false, false, _days, _hours, _minutes, _seconds, _percent));
						this.stop();
					} else {
						this.dispatchEvent(new CountdownEvent(CountdownEvent.ON_TIMER_COUNTDOWN, false, false, _days, _hours, _minutes, _seconds, _percent));
					}
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  Computing
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function computeTime():void {
			var nowDate:Date = new Date();
			var timeLeft:Number = _endDate.getTime() - (_startDate.getTime() + (nowDate.getTime() - _startDate.getTime()));
			var seconds:Number;
			var minutes:Number;
			var hours:Number;
			var days:Number;
			
			_percent = 1 - (timeLeft / (_endDate.getTime() - _startDate.getTime()));
			
			if (timeLeft <= 0) _isComplete = true;
			
			seconds = _totalSeconds = Math.ceil(timeLeft / TIMER_DELAY);
			minutes = Math.floor(_totalSeconds / NUM_SECONDS);
			hours = Math.floor(minutes / NUM_MINUTES);
			days = Math.floor(hours / NUM_HOURS);
			
			seconds %= NUM_SECONDS;
			minutes %= NUM_MINUTES;
			hours %= NUM_HOURS;
			
			_seconds = formatValue(seconds);
			_minutes = formatValue(minutes);
			_hours = formatValue(hours);
			_days = days.toString();
		}
		
		/**
		 * @private
		 */
		private function formatValue(value:int):String {
			var stringValue:String = value.toString();
			
			return stringValue.length < 2 ? '0' + stringValue : stringValue;
		}
		
		
		/**
		 * Start Countdown with dates
		 * 
		 * @param	startDate
		 * @param	endDate
		 */
		public function start(startDate:Date, endDate:Date):void {
			if (!_isStarted) {
				_isStarted = true;
				_isComplete = false;
				_startDate = startDate;
				_endDate = endDate;
				
				computeTime();
				
				this.dispatchEvent(new CountdownEvent(CountdownEvent.ON_START_COUNTDOWN, false, false, _days, _hours, _minutes, _seconds, _percent));
				
				startTimer();
			}
		}
		
		/**
		 * Start Countdown with time
		 * 
		 * @param	time (in seconds)
		 */
		public function startTime(time:int):void {
			if (!_isStarted) {
				_isStarted = true;
				_isComplete = false;
				_startDate = new Date();
				_endDate = new Date();
				_endDate.seconds += time;
				
				computeTime();
				
				this.dispatchEvent(new CountdownEvent(CountdownEvent.ON_START_COUNTDOWN, false, false, _days, _hours, _minutes, _seconds, _percent));
				
				startTimer();
			}
		}
		
		/**
		 * Stop Countdown
		 */
		public function stop():void {
			if (_isStarted) {
				_isStarted = false;
				
				stopTimer();
				
				this.dispatchEvent(new CountdownEvent(CountdownEvent.ON_STOP_COUNTDOWN, false, false, _days, _hours, _minutes, _seconds, _percent));
				
				_totalSeconds = 0;
				_percent = 0;
			}
		}
		
		/**
		 * Pause Countdown
		 */
		public function pause():void {
			if (_isStarted && !_isPaused) {
				
				
				_isPaused = true;
			}
		}
		
		/**
		 * Resume Countdown
		 */
		public function resume():void {
			if (_isPaused) {
				
				
				_isPaused = false;
			}
		}
		
		/**
		 * Append time.
		 * 
		 * @param	time
		 */
		public function appendTime(time:int):void {
			if (_isStarted) _endDate.seconds += time;
		}
		
		/**
		 * Append time.
		 * 
		 * @param	time
		 */
		public function setTime(time:int):void {
			if (_isStarted) {
				_endDate = new Date();
				_endDate.seconds += time;
			}
		}
		
		/**
		 * Destructor
		 */
		public function destroy():void {
			destroyTimer();
			
			_startDate = null;
			_endDate = null;
			_days = null;
			_hours = null;
			_minutes = null;
			_seconds = null;
			_isStarted = false;
			_isComplete = false;
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
		public function get totalSeconds():int {
			return _totalSeconds;
		}
		
		/**
		 * @private
		 */
		public function get isStarted():Boolean {
			return _isStarted;
		}
	}
}