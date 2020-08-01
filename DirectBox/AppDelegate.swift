//
//  AppDelegate.swift
//  DirectBox
//
//  Created by ShamsDEV.com on 8/1/20.
//  Copyright © 2020 ShamsDEV.com. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        initStatusBar()
        WatchPasteboard {
            //Example link: https://www.dropbox.com/s/lzdy2p674el8ynw/avatar.png?dl=0
            
            let copiedString = "\($0)"
            let pattern = "dropbox\\.com\\/s\\/(.*)\\?dl"
            
            let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            if let match = regex?.firstMatch(in: copiedString, options: [], range: NSRange(location: 0, length: copiedString.utf16.count)) {
                if let mainRange = Range(match.range(at: 1), in: copiedString) {
                    let mainStr = copiedString[mainRange]
                    let directedLink = "http://dl.dropboxusercontent.com/s/" + mainStr;
                    self.copyToClipboard(text: directedLink)
                    self.showCopiedNotification(link: directedLink)
                }
            }
            
        }
    }
    
    func initStatusBar() {
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(
            withLength: NSStatusItem.squareLength)
        
        statusBarItem.button?.title = "📦"
        let statusBarMenu = NSMenu(title: "DropBox Link Director")
        statusBarItem.menu = statusBarMenu
        
        let quitMenuItem : NSMenuItem = NSMenuItem(
            title: "Quit",
            action: #selector(AppDelegate.quit),
            keyEquivalent: "")
        
        statusBarMenu.addItem(quitMenuItem)
    }
    
    func WatchPasteboard(copied: @escaping (_ copiedString:String) -> Void) {
        let pasteboard = NSPasteboard.general
        var changeCount = NSPasteboard.general.changeCount
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let copiedString = pasteboard.string(forType: .string) {
                if pasteboard.changeCount != changeCount {
                    copied(copiedString)
                    changeCount = pasteboard.changeCount
                }
            }
        }
    }
    
    func copyToClipboard(text : String) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(text, forType: NSPasteboard.PasteboardType.string)
    }
    
    func showCopiedNotification(link : String) {
        let notification = NSUserNotification()
        notification.title = "Link directed and copeid to clipboard!"
        notification.subtitle = link
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }

    
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }
}
