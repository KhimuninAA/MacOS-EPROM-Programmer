//
//  KhLabel.swift
//  USB-HID-3
//
//  Created by Алексей Химунин on 07.11.2020.
//

import Foundation
import Cocoa

class KhLabel: NSTextField{
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView(){
        isBezeled = false
        drawsBackground = false
        isEnabled = false
        isSelectable = false
    }
}
