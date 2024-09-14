//
//  RomTabView.swift
//  MacOS-EPROM-Programmer
//
//  Created by Алексей Химунин on 08.09.2024.
//

import Foundation
import AppKit

class RomTabView: NSTabView {
    var rom27TabItem: Rom27TabItem!
    var rom28TabItem: Rom28TabItem!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    private func initView() {
        wantsLayer = true
        
        //alignmentRectInsets = 
        
        rom27TabItem = Rom27TabItem(identifier: nil)
        self.addTabViewItem(rom27TabItem)
        
        rom28TabItem = Rom28TabItem(identifier: nil)
        self.addTabViewItem(rom28TabItem)
    }
}
