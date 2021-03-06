/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.entities.command {
	import flash.events.Event;
	
	import artcustomer.maxima.core.command.*;
	import artcustomer.maxima.entities.model.ScoreModel;
	import artcustomer.maxima.events.ScoreCommandEvent;
	
	
	/**
	 * ScoreCommand
	 * 
	 * @author David Massenot
	 */
	public class ScoreCommand extends AbstractCommand implements ICommand {
		public static const ID:String = 'ScoreCommand';
		
		private var _model:ScoreModel;
		
		
		/**
		 * Constructor
		 */
		public function ScoreCommand() {
			super(ID);
		}
		
		
		/**
		 * Setup Command.
		 */
		override public function setup():void {
			_model = this.getModel(ScoreModel.ID) as ScoreModel;
		}
		
		/**
		 * Destroy Command.
		 */
		override public function destroy():void {
			_model = null;
			
			super.destroy();
		}
		
		/**
		 * Execute Command.
		 * 
		 * @param	event
		 */
		override public function execute(event:Event):void {
			var e:ScoreCommandEvent = event as ScoreCommandEvent;
			
			switch (e.type) {
				case(ScoreCommandEvent.UPDATE_SCORE):
					_model.updateScore(e.scoreID, e.value, e.playerID);
					break;
					
				case(ScoreCommandEvent.GET_SCORE):
					_model.getScore(e.scoreID, e.playerID);
					break;
					
				default:
					break;
			}
		}
	}
}