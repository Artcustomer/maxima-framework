/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.maxima.context.menu {
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	import artcustomer.maxima.Maxima;
	import artcustomer.maxima.context.GameContext;
	import artcustomer.maxima.base.IDestroyable;
	
	
	/**
	 * GameContextMenu
	 * 
	 * @author David Massenot
	 */
	public class GameContextMenu extends Object implements IDestroyable {
		private var _container:DisplayObjectContainer;
		
		private var _contextMenu:ContextMenu;
		
		private var _contextMenuItemTitle:ContextMenuItem;
		private var _contextMenuItemFramework:ContextMenuItem;
		
		private var _urlRequest:URLRequest;
		
		private var _titleCaption:String;
		private var _frameworkCaption:String;
		
		
		/**
		 * Constructor
		 */
		public function GameContextMenu() {
			
		}
		
		//---------------------------------------------------------------------
		//  ContextMenu
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleContextMenuItem(e:ContextMenuEvent):void {
			switch (e.type) {
				case(ContextMenuEvent.MENU_ITEM_SELECT):
					if ((e.target as ContextMenuItem).caption == _frameworkCaption) navigateToURL(_urlRequest, '_blank');
					break;
					
				default:
					break;
			}
		}
		
		
		/**
		 * Setup ContextFrameworkMenu.
		 */
		public function setup():void {
			_container = GameContext.currentContext.contextView;
			
			_titleCaption = GameContext.currentContext.instance.name;
			_frameworkCaption = Maxima.CODE + ' ' + Maxima.VERSION;
			
			_urlRequest = new URLRequest(Maxima.ONLINE_DOCUMENTATION);
			
			_contextMenuItemTitle = new ContextMenuItem(_titleCaption, false, false);
			_contextMenuItemFramework = new ContextMenuItem(_frameworkCaption, false, true);
			_contextMenuItemFramework.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleContextMenuItem, false, 0, true);
			
			_contextMenu = new ContextMenu();
			_contextMenu.hideBuiltInItems();
			_contextMenu.customItems.push(_contextMenuItemTitle);
			_contextMenu.customItems.push(_contextMenuItemFramework);
			
			_container.contextMenu = _contextMenu;
		}
		
		/**
		 * Destructor
		 */
		public function destroy():void {
			_contextMenuItemTitle = null;
			_contextMenuItemFramework.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleContextMenuItem);
			_contextMenuItemFramework = null;
			_urlRequest = null;
			_titleCaption = null;
			_frameworkCaption = null;
			
			if (_contextMenu) {
				_contextMenu = null;
				_container.contextMenu = null;
			}
			
			_container = null;
		}
	}
}