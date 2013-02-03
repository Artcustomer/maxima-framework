/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.core.score.data {
	import artcustomer.maxima.base.IDestroyable;
	import artcustomer.maxima.utils.tools.StringTools;
	
	
	/**
	 * ScoreEntry
	 * 
	 * @author David Massenot
	 */
	public class ScoreEntry implements IDestroyable {
		private var _id:String;
		private var _value:Object;
		private var _player:String;
		
		
		/**
		 * Constructor
		 */
		public function ScoreEntry() {
			
		}
		
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			_id = null;
			_value = null;
			_player = null;
		}
		
		/**
		 * Get String format of object.
		 * 
		 * @return
		 */
		public function toString():String {
			return StringTools.formatToString(this, 'ScoreEntry', 'id', 'value', 'player');
		}
		
		/**
		 * Clone object.
		 * 
		 * @return
		 */
		public function clone():ScoreEntry {
			var scoreEntry:ScoreEntry = new ScoreEntry();
			scoreEntry.id = _id;
			scoreEntry.value = _value;
			scoreEntry.player = _player;
			
			return scoreEntry;
		}
		
		
		/**
		 * @private
		 */
		public function set id(value:String):void {
			_id = value;
		}
		
		/**
		 * @private
		 */
		public function get id():String {
			return _id;
		}
		
		/**
		 * @private
		 */
		public function set value(value:Object):void {
			_value = value;
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
		public function set player(value:String):void {
			_player = value;
		}
		
		/**
		 * @private
		 */
		public function get player():String {
			return _player;
		}
	}
}