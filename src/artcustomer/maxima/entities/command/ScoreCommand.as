package artcustomer.maxima.entities.command {
	import artcustomer.maxima.core.command.*;
	import flash.events.Event;
	
	
	/**
	 * ScoreCommand
	 * 
	 * @author David Massenot
	 */
	public class ScoreCommand extends AbstractCommand implements ICommand {
		public static const ID:String = 'ScoreCommand';
		
		
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
			// 
		}
		
		/**
		 * Destroy Command.
		 */
		override public function destroy():void {
			// 
			
			super.destroy();
		}
		
		/**
		 * Execute Command.
		 * 
		 * @param	event
		 */
		override public function execute(event:Event):void {
			
		}
	}
}