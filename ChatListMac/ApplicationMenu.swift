//
//  ApplicationMenu.swift
//  ChatListMac
//
//  Created by Gustavo Diefenbach on 16/10/23.
//

import Foundation
import SwiftUI

class ApplicationMenu: NSObject {
    let menu = NSMenu()
    
    func createMenu() -> NSMenu {
        let menuClass =  ListView()
        let topView = NSHostingController(rootView: menuClass)
        topView.view.frame.size = CGSize(width: 400, height: 300)
        
        let customMenuItem = NSMenuItem()
        customMenuItem.view = topView.view
        
        self.menu.addItem(customMenuItem)
        self.menu.addItem(NSMenuItem.separator())
        
        return menu
    }
}
