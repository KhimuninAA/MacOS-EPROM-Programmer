//
//  RootView.swift
//  MacOS-EPROM-Programmer
//
//  Created by Алексей Химунин on 04.09.2024.
//

import Foundation
import AppKit

class RootView: NSView{
    var onResizeAction: (() -> Void)?
    var connectBox: ConnectBox!

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
        //self.layer?.backgroundColor = NSColor.gray.cgColor

        connectBox = ConnectBox(frame: .zero)
        addSubview(connectBox)

    }

    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)

        let selfSize = self.frame.size
        let padding: CGFloat = 8

        let connectBoxHeight = selfSize.height - 2 * padding
        connectBox.frame = CGRect(x: 5, y: 5, width: 190, height: connectBoxHeight)

        onResizeAction?()
//        if let frame = window?.frame {
//            Storage.save(windowFrame: frame)
//        }
    }
}
