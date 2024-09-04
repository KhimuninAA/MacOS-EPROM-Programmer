//
//  ConnectBox.swift
//  MacOS-EPROM-Programmer
//
//  Created by Алексей Химунин on 04.09.2024.
//

import Foundation
import AppKit

class ConnectBox: NSBox {
    var speedTitle: KhLabel!
    var speedPopUpButton: NSPopUpButton!

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
        titlePosition = .noTitle

        speedTitle = KhLabel(frame: .zero)
        speedTitle.alignment = .left
        speedTitle.ver
        speedTitle.stringValue = "speed"
        addSubview(speedTitle)

        speedPopUpButton = NSPopUpButton(frame: .zero)
        addSubview(speedPopUpButton)
    }

    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)

        let padding: CGFloat = 8 //16
        let itemHeight: CGFloat = 32

        let selfFrame = self.frame
        //let selfContentFrame = self.contentView?.frame
        //print(selfContentFrame)
        let itemWidth = selfFrame.width - (2 * padding) - (2 * selfFrame.origin.x)  // - 2 * selfMargins.width

        let speedTitleTop = selfFrame.height - padding - itemHeight - selfFrame.origin.y// - selfMargins.height
        let speedTitleFrame = CGRect(x: padding, y: speedTitleTop, width: itemWidth, height: itemHeight)
        speedTitle.frame = speedTitleFrame
    }
}
