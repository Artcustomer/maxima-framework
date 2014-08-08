/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.engine {
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import artcustomer.maxima.errors.GameError;
	import artcustomer.maxima.core.command.AbstractCommand;
	import artcustomer.maxima.core.model.AbstractModel;
	import artcustomer.maxima.core.ui.IUIHelper;
	import artcustomer.maxima.data.IViewData;
	
	
	/**
	 * LogicEngine
	 * 
	 * @author David Massenot
	 */
	public class LogicEngine extends AbstractCoreEngine {
		private var _uiHelper:IUIHelper;
		
		private var _commands:Dictionary;
		private var _models:Dictionary;
		
		private var _numCommands:int;
		private var _numModels:int;
		
		
		/**
		 * Constructor
		 */
		public function LogicEngine() {
			super();
		}
		
		//---------------------------------------------------------------------
		//  Commands
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function releaseCommands():void {
			for (var id:String in _commands) {
				this.removeCommand(id);
			}
		}
		
		//---------------------------------------------------------------------
		//  Models
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function releaseModels():void {
			for (var id:String in _models) {
				this.removeModel(id);
			}
		}
		
		/**
		 * @private
		 */
		private function onModelUpdate(id:String, data:IViewData, type:String):void {
			if (context.instance.gameEngine.currentEngineObject) _injector.updateObject(context.instance.gameEngine.currentEngineObject, id, data, type);
		}
		
		//---------------------------------------------------------------------
		//  UIHelper
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function destroyUIHelper():void {
			if (_uiHelper) {
				_uiHelper.destroy();
				_uiHelper = null;
			}
		}
		
		
		/**
		 * Entry point.
		 */
		override internal function setup():void {
			super.setup();
			
			_commands = new Dictionary();
			_models = new Dictionary();
			_numCommands = 0;
			_numModels = 0;
		}
		
		/**
		 * Destructor
		 */
		override internal function destroy():void {
			releaseCommands();
			releaseModels();
			destroyUIHelper();
			
			_commands = null;
			_models = null;
			_numCommands = 0;
			_numModels = 0;
			
			super.destroy();
		}
		
		/**
		 * Add model by class reference (inherit from AbstractModel and implements IModel).
		 * 
		 * @param	classReference (must be extends AbstractModel)
		 */
		public function addModel(classReference:Class):void {
			var model:AbstractModel = new classReference();
			if (!model is AbstractModel) throw new GameError(GameError.E_MODEL_CLASS);
			
			if (_models[model.id] != undefined) {
				throw new GameError(model.id + GameError.E_MODEL_EXISTS);
			} else {
				model.context = this.context;
				model.updateCallback = onModelUpdate;
				model.setup();
				_models[model.id] = model;
				++_numModels;
			}
		}
		
		/**
		 * Remove model by id.
		 * Return true if model is removed / false if an error occured.
		 * 
		 * @param	id
		 * @return	true if model is removed / false if an error occured
		 */
		public function removeModel(id:String):Boolean {
			if (_models[id] != undefined) {
				var model:AbstractModel = _models[id] as AbstractModel;
				model.destroy();
				_models[id] = null;
				delete _models[id];
				--_numModels;
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Get model by id.
		 * 
		 * @param	id
		 * @return	Instance of AbstractModel / undefined
		 */
		public function getModel(id:String):AbstractModel {
			return _models[id];
		}
		
		/**
		 * Test if model exists by id.
		 * 
		 * @param	id
		 * @return	true if model exists / false if not
		 */
		public function hasModel(id:String):Boolean {
			return _models[id] != undefined;
		}
		
		/**
		 * Add Command by class reference (inherit from AbstractCommand and implements ICommand)
		 * 
		 * @param	classReference (must be extends AbstractCommand)
		 */
		public function addCommand(classReference:Class):void {
			var command:AbstractCommand = new classReference();
			if (!command is AbstractCommand) throw new GameError(GameError.E_MODEL_CLASS);
			
			if (_commands[command.id] != undefined) {
				throw new GameError(command.id + GameError.E_MODEL_EXISTS);
			} else {
				command.context = this.context;
				command.setup();
				_commands[command.id] = command;
				++_numCommands;
			}
		}
		
		/**
		 * Remove command by id.
		 * Return true if command is removed / false if an error occured.
		 * 
		 * @param	id
		 * @return	true if command is removed / false if an error occured.
		 */
		public function removeCommand(id:String):Boolean {
			if (_commands[id] != undefined) {
				var command:AbstractCommand = _commands[id] as AbstractCommand;
				command.destroy();
				_commands[id] = null;
				delete _commands[id];
				--_numCommands;
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Execute command by id.
		 * Call execute() method in command instance.
		 * 
		 * @param	id
		 * @param	event
		 */
		public function executeCommand(id:String, event:Event):void {
			if (_commands[id] != undefined) {
				var command:AbstractCommand = _commands[id] as AbstractCommand;
				command.execute(event);
			} else {
				// TODO : Error !
				trace('WARNING !', id, 'command does not exists !');
			}
		}
		
		/**
		 * Get command by id.
		 * 
		 * @param	id
		 * @return	Instance of AbstractCommand / undefined
		 */
		public function getCommand(id:String):AbstractCommand {
			return _commands[id];
		}
		
		/**
		 * Test if command exists by id.
		 * 
		 * @param	id
		 * @return	true if command exists / false if not
		 */
		public function hasCommand(id:String):Boolean {
			return _commands[id] != undefined;
		}
		
		
		/**
		 * @private
		 */
		public function get numCommands():int {
			return _numCommands;
		}
		
		/**
		 * @private
		 */
		public function get numModels():int {
			return _numModels;
		}
		
		/**
		 * @private
		 */
		public function set uiHelper(value:IUIHelper):void {
			destroyUIHelper();
			
			_uiHelper = value;
			_uiHelper.init();
		}
		
		/**
		 * @private
		 */
		public function get uiHelper():IUIHelper {
			return _uiHelper;
		}
	}
}