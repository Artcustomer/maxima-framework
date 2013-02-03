/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.errors {
	import flash.errors.IllegalOperationError;
	
	
	/**
	 * IllegalGameError
	 * 
	 * @author David Massenot
	 */
	public class IllegalGameError extends IllegalOperationError {
		public static const ERROR_ID:int = 20000;
		
		public static const E_ABSTRACT_CLASS:String = "Abstract class ! Don't instantiate it directly !";
		public static const E_SINGLETON_CLASS:String = "Singleton ! Use static method !";
		
		public static const E_CONTEXT_INSTANTIATION:String = "Context is already instantiated !";
		public static const E_CONTEXT_CONSTRUCTOR:String = "Context is an abstract class ! Don't instantiate it directly !";
		public static const E_SERVICECONTEXT_CONSTRUCTOR:String = "ServiceContext is an abstract class ! Don't instantiate it directly !";
		public static const E_CROSSPLATFORMINPUTSCONTEXT_CONSTRUCTOR:String = "CrossPlatformInputsContext is an abstract class ! Don't instantiate it directly !";
		public static const E_INTERACTIVECONTEXT_CONSTRUCTOR:String = "InteractiveContext is an abstract class ! Don't instantiate it directly !";
		public static const E_EVENTCONTEXT_CONSTRUCTOR:String = "EventContext is an abstract class ! Don't instantiate it directly !";
		
		public static const E_VALUEOBJECT_CONSTRUCTOR:String = "AbstractValueObject is an abstract class ! Don't instantiate it directly !";
		
		
		/**
		 * Throw an IllegalGameError.
		 * 
		 * @param	message
		 * @param	id
		 */
		public function IllegalGameError(message:String = "", id:int = 0) {
			super(message, ERROR_ID + id);
		}
	}
}