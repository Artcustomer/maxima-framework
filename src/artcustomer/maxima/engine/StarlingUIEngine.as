package artcustomer.maxima.engine {
	import artcustomer.maxima.engine.AbstractStarlingDisplayCoreEngine;
	
	import starling.display.DisplayObject;
	
	
	/**
	 * StarlingUIEngine
	 * 
	 * @author David Massenot
	 */
	public class StarlingUIEngine extends AbstractStarlingDisplayCoreEngine {
		
		
		/**
		 * Constructor
		 */
		public function StarlingUIEngine() {
			super();
		}
		
		
		/**
		 * Entry point.
		 */
		override internal function setup():void {
			super.setup();
			
			//
		}
		
		/**
		 * Destructor
		 */
		override internal function destroy():void {
			if (this.engineDisplayContainer.numChildren > 0) this.engineDisplayContainer.removeChildren(0, -1, true);
			
			super.destroy();
		}
		
		
		/**
		 * Add child.
		 * 
		 * @param	child
		 * @return
		 */
		public function addChild(child:DisplayObject):DisplayObject {
			return this.engineDisplayContainer.addChild(child);
		}
		
		/**
		 * Add child at index.
		 * 
		 * @param	child
		 * @param	index
		 * @return
		 */
		public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			return this.engineDisplayContainer.addChildAt(child, index);
		}
		
		/**
		 * Remove child.
		 * 
		 * @param	child
		 * @param	dispose
		 */
		public function removeChild(child:DisplayObject, dispose:Boolean = false):DisplayObject {
			return this.engineDisplayContainer.removeChild(child, dispose);
		}
		
		/**
		 * Remove child at index.
		 * 
		 * @param	index
		 * @param	dispose
		 * @return
		 */
		public function removeChildAt(index:int, dispose:Boolean = false):DisplayObject {
			return this.engineDisplayContainer.removeChildAt(index, dispose);
		}
		
		/**
		 * Removes a range of children from the container (endIndex included). 
         * If no arguments are given, all children will be removed.
		 * 
		 * @param	beginIndex
		 * @param	endIndex
		 * @param	dispose
		 */
		public function removeChildren(beginIndex:int = 0, endIndex:int = -1, dispose:Boolean = false):void {
			this.engineDisplayContainer.removeChildren(beginIndex, endIndex, dispose);
		}
		
		/**
		 * Get child at index.
		 * 
		 * @param	index
		 * @return
		 */
		public function getChildAt(index:int):DisplayObject {
			return this.engineDisplayContainer.getChildAt(index);
		}
		
		/**
		 * Get child by name.
		 * 
		 * @param	index
		 * @return
		 */
		public function getChildByName(name:String):DisplayObject {
			return this.engineDisplayContainer.getChildByName(name);
		}
	}
}