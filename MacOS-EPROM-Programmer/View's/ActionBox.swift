//
//  ActionBox.swift
//  MacOS-EPROM-Programmer
//
//  Created by Алексей Химунин on 06.09.2024.
//

import Foundation
import AppKit

enum ActrionType {
    case none
    case OpenFile
    case SaveFile
    case ShowBuffer
    case Voltage
    case Read
    case Write
    case Verify
}

class ActrionButton: NSButton {
    var type: ActrionType = .none
}

class ActionBox: NSBox {
    var logTextField: NSTextField!
    var scrollLogTextView = NSScrollView()
    var openFileButton: ActrionButton!
    var saveFileButton: ActrionButton!
    var showBufferButton: ActrionButton!
    var voltageButton: ActrionButton!
    var readButton: ActrionButton!
    var writeButton: ActrionButton!
    var verifyButton: ActrionButton!
    var progressIndicator: NSProgressIndicator!
    
    var onType: ((_ type: ActrionType) -> Void)?
    
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
        
        progressIndicator = NSProgressIndicator(frame: .zero)
        progressIndicator.minValue = 0
        progressIndicator.maxValue = 1
        progressIndicator.isIndeterminate = false
        contentView?.addSubview(progressIndicator)
        
        openFileButton = ActrionButton(frame: .zero)
        openFileButton.title = "Open File"
        openFileButton.target = self
        openFileButton.action = #selector(btnClick)
        openFileButton.type = .OpenFile
        contentView?.addSubview(openFileButton)
        
        saveFileButton = ActrionButton(frame: .zero)
        saveFileButton.title = "Save File"
        saveFileButton.target = self
        saveFileButton.action = #selector(btnClick)
        saveFileButton.type = .SaveFile
        contentView?.addSubview(saveFileButton)
        
        showBufferButton = ActrionButton(frame: .zero)
        showBufferButton.title = "Show Buffer"
        showBufferButton.target = self
        showBufferButton.action = #selector(btnClick)
        showBufferButton.type = .ShowBuffer
        contentView?.addSubview(showBufferButton)
        
        voltageButton = ActrionButton(frame: .zero)
        voltageButton.title = "Voltage"
        voltageButton.target = self
        voltageButton.action = #selector(btnClick)
        voltageButton.type = .Voltage
        contentView?.addSubview(voltageButton)
        
        readButton = ActrionButton(frame: .zero)
        readButton.title = "Read"
        readButton.target = self
        readButton.action = #selector(btnClick)
        readButton.type = .Read
        contentView?.addSubview(readButton)
        
        writeButton = ActrionButton(frame: .zero)
        writeButton.title = "Write"
        writeButton.target = self
        writeButton.action = #selector(btnClick)
        writeButton.type = .Write
        contentView?.addSubview(writeButton)
        
        verifyButton = ActrionButton(frame: .zero)
        verifyButton.title = "Verify"
        verifyButton.target = self
        verifyButton.action = #selector(btnClick)
        verifyButton.type = .Verify
        contentView?.addSubview(verifyButton)
        
        scrollLogTextView.hasHorizontalScroller = false
        scrollLogTextView.hasVerticalScroller = true
        contentView?.addSubview(scrollLogTextView)
        
        logTextField = NSTextField(frame: scrollLogTextView.bounds)
        logTextField.isEditable = false
        scrollLogTextView.documentView = logTextField
        
        self.sizeToFit()
    }
    
    @objc private func btnClick(_ sender: ActrionButton) {
        onType?(sender.type)
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        let padding: CGFloat = 4 //8
        let btnHeight: CGFloat = 24
        
        if let selfContent = self.contentView {
            let size = selfContent.frame.size
            
            let progressIndicatorHeight: CGFloat = 8
            let progressIndicatorTop = size.height - progressIndicatorHeight
            let progressIndicatorFrame = CGRect(x: 0, y: progressIndicatorTop, width: size.width, height: progressIndicatorHeight)
            progressIndicator.frame = progressIndicatorFrame
            
            var btnTop = progressIndicatorFrame.minY - btnHeight - padding
            var btnLeft: CGFloat = 0
            // 3btn
            var btnWidth = (size.width - 2 * padding)/3
            openFileButton.frame = CGRect(x: btnLeft, y: btnTop, width: btnWidth, height: btnHeight)
            btnLeft += btnWidth + padding
            saveFileButton.frame = CGRect(x: btnLeft, y: btnTop, width: btnWidth, height: btnHeight)
            btnLeft += btnWidth + padding
            showBufferButton.frame = CGRect(x: btnLeft, y: btnTop, width: btnWidth, height: btnHeight)
            // 4btn
            btnTop -= btnHeight + padding
            btnWidth = (size.width - 3 * padding)/4
            btnLeft = 0
            voltageButton.frame = CGRect(x: btnLeft, y: btnTop, width: btnWidth, height: btnHeight)
            btnLeft += btnWidth + padding
            readButton.frame = CGRect(x: btnLeft, y: btnTop, width: btnWidth, height: btnHeight)
            btnLeft += btnWidth + padding
            writeButton.frame = CGRect(x: btnLeft, y: btnTop, width: btnWidth, height: btnHeight)
            btnLeft += btnWidth + padding
            verifyButton.frame = CGRect(x: btnLeft, y: btnTop, width: btnWidth, height: btnHeight)
            btnLeft += btnWidth + padding
            
            var logTextFieldHeight = btnTop - padding
            if logTextFieldHeight < 0 {
                logTextFieldHeight = 0
            }
            let logTextFieldFrame = CGRect(x: 0, y: 0, width: size.width, height: logTextFieldHeight)
            scrollLogTextView.frame = logTextFieldFrame
            scrollLogTextView.documentView?.setFrameSize(logTextFieldFrame.size)
        }
    }
    
    func addLog(_ log: String) {
        var tempLog = logTextField.stringValue
        if tempLog.count > 0 {
            tempLog += "\r\n"
        }
        tempLog += log
        logTextField.stringValue = tempLog
        logTextField.sizeToFit()
        let height = logTextField.frame.size.height
        let width = scrollLogTextView.frame.width
        logTextField.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
}
