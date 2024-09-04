//
//  KhHexView.swift
//  USB-HID-3
//
//  Created by Алексей Химунин on 20.11.2020.
//

import Foundation
import Cocoa

class KhHexScrollView: NSScrollView{
    private var hexView: KhHexView!
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView(){
        hexView = KhHexView()
        //addSubview(hexView)
        documentView = hexView
        
//        verticalScroller = .none
//        horizontalScroller = false
        //self.autoresizingMask = AutoresizingMask.width //| AutoresizingMask.height
        
        //self.isRulerVisible = true

        
        //setHasVerticalScroller = true
        //setHasHorizontalScroller = false
        //setauto
        //[self setHasVerticalScroller:YES];
        //[scrollview setHasHorizontalScroller:NO];
        //[scrollview setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    }
    
    func addString(_ str: String) {
        hexView.stringValue = hexView.stringValue + str
        resizeSubviews(withOldSize: self.frame.size)
    }
    
    func setData(_ data: [UInt8]){
        hexView.setData(data)
        //displayIfNeeded()
        resizeSubviews(withOldSize: self.frame.size)
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        
        let selfSize = frame.size
        
        let hexViewSize = hexView.sizeThatFits(NSSize(width: selfSize.width, height: CGFloat.greatestFiniteMagnitude))
        let contSize = CGSize(width: selfSize.width, height: hexViewSize.height)
        
        hexView.frame = CGRect(x: 0, y: 0, width: contSize.width, height: contSize.height)
        //hexView.isRulerVisible
        //self.contentSize = contSize
        //self.setco
        //contentSize = CGSize(width: selfSize.width, height: hexViewSize.height)
    }
}

class KhHexView: NSTextField{
    /// Стартовый адрес с которого начинаеться вывод данных
    var startAddress: UInt16 = 0
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView(){
        isEditable = false
        //let fomtSize: CGFloat = 24 //font?.pointSize ?? 0
        //font = NSFont(name: "Menlo", size: fomtSize)
        
        wantsLayer = true
        layer?.cornerRadius = 10
        layer?.masksToBounds = true
        layer?.borderWidth = 0
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        
        //let selfSize = frame.size
    }
    
    func setData(_ data: [UInt8]){
        var addr: UInt16 = startAddress
        var str = String(format:"%04X: ", addr)
        var pos: Int = 0
        var chars = "   "
        for byte in data{
            str += String(format:"%02X", byte)
            pos += 1
            addr += 1
            if (byte >= 0x20 && byte < 0x80){
                chars.append(Character(UnicodeScalar(byte)))
            }else{
                chars.append(".")
            }
            if pos == 16{
                pos = 0
                str += chars
                chars = "   "
                str += "\n"
                str += String(format:"%04X: ", addr)
            }else{
                str += " "
            }
        }
        self.stringValue = str
    }
    
}
