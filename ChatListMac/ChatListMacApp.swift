//
//  ChatListMacApp.swift
//  ChatListMac
//
//  Created by Gustavo Diefenbach on 16/10/23.
//

import SwiftUI

@main
struct ChatListMacApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}


class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var instance: AppDelegate!
    
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    let menu = ApplicationMenu()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.instance = self
        
        if let statusButton = statusBarItem.button {
            statusButton.image = NSImage(named: NSImage.Name("iconMenuBar"))
            //statusButton.image = NSImage(systemSymbolName: "square.and.arrow.up", accessibilityDescription: "icon")
        }
        
        //statusBarItem.button?.imagePosition = .imageLeading
        statusBarItem.menu = menu.createMenu()
    }
}
