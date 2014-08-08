/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.errors {
	
	
	/**
	 * GameError
	 * 
	 * @author David Massenot
	 */
	public class GameError extends Error {
		public static const ERROR_ID:int = 10000;
		
		public static const E_CONTEXT_SETUP_FALSE:String = "Call setup method first !";
		public static const E_CONTEXT_SETUP_TRUE:String = "Context is already Setup !";
		public static const E_CONTEXT_SETUP:String = "Root Container isn't defined to setup Context !";
		public static const E_CONTEXT_RESET:String = "Root Container isn't defined to reset Context !";
		public static const E_CONTEXT_DESTROY:String = "Root Container isn't defined to destroy Context !";
		
		public static const E_MULTITHREADPROXY_CREATE:String = "MultiThreadProxy is singleton ! Use static method to get it !";
		public static const E_ENGINEMANAGER_CREATE:String = "EngineManager is singleton ! Use static method to get it !";
		public static const E_ENGINEOBJECTMANAGER_CREATE:String = "EngineObjectManager is singleton ! Use static method to get it !";
		public static const E_SHORE_CREATE:String = "Shore is singleton ! Use static method to get it !";
		public static const E_RENDERENGINE_CREATE:String = "RenderEngine is singleton ! Use static method to get it !";
		public static const E_GAMEENGINE_CREATE:String = "GameEngine is singleton ! Use static method to get it !";
		public static const E_SCOREENGINE_CREATE:String = "ScoreEngine is singleton ! Use static method to get it !";
		public static const E_SFXENGINE_CREATE:String = "SFXEngine is singleton ! Use static method to get it !";
		public static const E_DIRECTINPUTENGINE_CREATE:String = "DirectInputEngine is singleton ! Use static method to get it !";
		public static const E_ASSETSLOADER_CREATE:String = "AssetsLoader is singleton ! Use static method to get it !";
		public static const E_NAVIGATIONSYSTEM_CREATE:String = "NavigationSystem is singleton ! Use static method to get it !";
		
		public static const E_NULL_CURRENTOBJECT:String = "Current object cannot be null !";
		public static const E_NULL_CORE_NAME:String = "Name of AbstractEngineObject cannot be null !";
		public static const E_NULL_MODEL_ID:String = "ID of AbstractModel cannot be null !";
		public static const E_NULL_COMMAND_ID:String = "ID of AbstractCommand cannot be null !";
		
		public static const E_MODEL_CLASS:String = "Model is not a value of AbstractModel !";
		public static const E_MODEL_EXISTS:String = " Model already exists !";
		
		public static const E_COMMAND_CLASS:String = "Command is not a value of AbstractCommand !";
		public static const E_COMMAND_EXISTS:String = " Command already exists !";
		
		public static const E_CORE_GLOBALLOADER:String = "Class must extends GlobalLoader !";
		public static const E_CORE_DISPLAYVIEW:String = "Class must extends DisplayView !";
		public static const E_CORE_DISPLAYVIEWGROUP:String = "Class must extends DisplayViewGroup !";
		public static const E_CORE_DISPLAYGAME:String = "Class must extends DisplayGame !";
		
		public static const E_EXISTING_KEY:String = " already exist in navigation map !";
		public static const E_EMPTY_MAP:String = "Navigation map cannot be empty !";
		public static const E_NAVIGATION_ERROR:String = "Error on NavigationSystem !";
		
		public static const E_SFX_OVERFLOW:String = "Channel index is out of bounds !";
		public static const E_SFX_MAX_CHANNELS:String = "FlashPlayer doesn't support more of 32 channels !";
		public static const E_SFX_DISPOSE_MASTER:String = "Can't dispose master channel !";
		
		public static const E_FILE_FORMAT:String = "Can't load asset because of invalid format !";
		public static const E_ASSETSLOADER_EMPTY:String = "Can't load files with empty stack !";
		public static const E_ASSETSLOADER_ONLOAD:String = "AssetsLoader is already on load !";
		public static const E_ASSETSLOADER_UNLOAD:String = "AssetsLoader isn't on load !";
		
		
		/**
		 * Throw a GameError.
		 * 
		 * @param	message
		 * @param	id
		 */
		public function GameError(message:String = "", id:int = 0) {
			super(message, ERROR_ID + id);
		}
	}
}