//
//  KhTextField.swift
//  USB-HID-3
//
//  Created by Алексей Химунин on 07.01.2021.
//

import Foundation
import Cocoa

class KhTextField: NSTextField{
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView(){
        wantsLayer = true
        layer = CALayer()
        layer?.cornerRadius = 6
        //layer?.borderColor = NSColor(hex: "#E0E0E0ff")?.cgColor
        layer?.borderWidth = 1
        //layer?.backgroundColor = NSColor(hex: "#FFFFFFff")?.cgColor
        //isEditable = false
        //self.isEnabled = false
        //layer?.borderColor = NSColor.clear.cgColor
        //textField.layer?.borderWidth = 1
        self.isEnabled = false
        //self.isEditable = false
        self.isEnabled = true
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        
        //let selfSize = frame.size
        shadowShow()
    }
    
    private func shadowShow(){
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 4
        shadow.shadowOffset = NSSize(width: 4, height: 4)
        shadow.shadowColor = NSColor.black
        self.shadow = shadow
    }
}
