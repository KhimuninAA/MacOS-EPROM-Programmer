//
//  AppDelegate.swift
//  MacOS-EPROM-Programmer
//
//  Created by Алексей Химунин on 04.09.2024.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate, NSMenuDelegate {

    @IBOutlet var window: NSWindow!
    var rootView: RootView?

    func applicationWillFinishLaunching(_ notification: Notification) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didWindowChange),
            name: NSWindow.didMoveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didWindowChange),
            name: NSWindow.didResizeNotification,
            object: nil
        )
    }

    @objc func didWindowChange() {
        saveWindowFrame()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //-- frame from storage
        let wFrame = Storage.readWindowFrame()
        if wFrame.width > 50 && wFrame.height > 50 {
            window.setFrame(wFrame, display: true)
        }
        //---
        rootView = RootView()
        rootView?.onResizeAction = { [weak self] in
            self?.saveWindowFrame()
        }
        window.contentView = rootView
        window.delegate = self
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.orderOut(self)
        saveWindowFrame()
        return false
    }

    private func saveWindowFrame() {
        let frame = window.frame
        Storage.save(windowFrame: frame)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }


}

