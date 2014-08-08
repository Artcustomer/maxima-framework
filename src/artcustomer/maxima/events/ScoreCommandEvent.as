package artcustomer.maxima.events {
	import flash.events.Event;
	
	import artcustomer.maxima.utils.consts.GameUniverse;
	
	
	/**
	 * RezultAPICommandEvent
	 * 
	 * @author David Massenot
	 */
	public class ScoreCommandEvent extends Event {
		public static const UPDATE_SCORE:String = 'updateScore';
		public static const GET_SCORE:String = 'getScore';
		public static const SAVE_SCORE_IN_LOCALSTORAGE:String = 'saveScoreInLocalStorage';
		public static const GET_SCORE_FROM_LOCALSTORAGE:String = 'getScoreFromLocalStorage';
		
		private var _scoreID:String;
		private var _playerID:String;
		private var _value:Object;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	scoreID
		 * @param	value
		 * @param	playerID
		 */
		public function ScoreCommandEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, scoreID:String = null, value:Object = null, playerID:String = GameUniverse.DEFAULT_PLAYER_NAME) {
			super(type, bubbles, cancelable);
			
			_scoreID = scoreID;
			_value = value;
			_playerID = playerID;
		} 
		
		/**
		 * Clone RezultAPICommandEvent.
		 * 
		 * @return
		 */
		public override function clone():Event { 
			return new ScoreCommandEvent(type, bubbles, cancelable, _scoreID, _value, _playerID);
		}
		
		/**
		 * Get String format of RezultAPICommandEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("RezultAPICommandEvent", "type", "bubbles", "cancelable", "eventPhase", "scoreID", "value", "playerID");
		}
		
		
		/**
		 * @private
		 */
		public function get scoreID():String {
			return _scoreID;
		}
		
		/**
		 * @private
		 */
		public function get value():Object {
			return _value;
		}
		
		/**
		 * @private
		 */
		public function get playerID():String {
			return _playerID;
		}
	}
}