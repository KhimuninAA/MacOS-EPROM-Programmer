//
//  ConnectBox.swift
//  MacOS-EPROM-Programmer
//
//  Created by Алексей Химунин on 04.09.2024.
//

import Foundation
import AppKit

class ConnectBox: NSBox {
    var onDevicesUpdate: (()->Void)?
    var onConnect: ((_ port: String, _ baudRate: Int)->Void)?
    var onDisconnect: (()->Void)?
    
    var speedTitle: KhLabel!
    var speedPopUpButton: NSPopUpButton!
    var deviceTitle: KhLabel!
    var devicePopUpButton: NSPopUpButton!
    var deviceUpdateButton: NSButton!
    var deviceConnectButton: NSButton!
    var deviceDisconnectButton: NSButton!

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
        speedTitle.stringValue = "speed:"
        contentView?.addSubview(speedTitle)

        speedPopUpButton = NSPopUpButton(frame: .zero)
        contentView?.addSubview(speedPopUpButton)

        deviceTitle = KhLabel(frame: .zero)
        deviceTitle.alignment = .left
        deviceTitle.stringValue = "device:"
        contentView?.addSubview(deviceTitle)

        devicePopUpButton = NSPopUpButton(frame: .zero)
        contentView?.addSubview(devicePopUpButton)
        
        deviceUpdateButton = NSButton(frame: .zero)
        deviceUpdateButton.title = "device update"
        deviceUpdateButton.target = self
        deviceUpdateButton.action = #selector(updateButtonClick)
        contentView?.addSubview(deviceUpdateButton)
        
        deviceConnectButton = NSButton(frame: .zero)
        deviceConnectButton.title = "device connect"
        deviceConnectButton.isEnabled = false
        deviceConnectButton.target = self
        deviceConnectButton.action = #selector(connectButtonClick)
        contentView?.addSubview(deviceConnectButton)
        
        deviceDisconnectButton = NSButton(frame: .zero)
        deviceDisconnectButton.title = "device disconnect"
        deviceDisconnectButton.isEnabled = false
        deviceDisconnectButton.target = self
        deviceDisconnectButton.action = #selector(disconnectButtonClick)
        contentView?.addSubview(deviceDisconnectButton)
        
        self.sizeToFit()
        setIsConnect(false)
    }
    
    @discardableResult
    func calcSubviewsHeight(withOldSize oldSize: NSSize, isSubviewsUpdate: Bool = false) -> CGFloat {
        //let padding: CGFloat = 8 //16
        let itemHeight: CGFloat = 32
        let textHeight: CGFloat = 16
        
        var retHeight: CGFloat = 0

        if let selfContent = self.contentView {
            let size = selfContent.frame.size
            
            let speedTitleTop: CGFloat = size.height - textHeight
            let speedTitleFrame = CGRect(x: 0, y: speedTitleTop, width: size.width, height: textHeight)
            
            let speedPopUpButtonTop = speedTitleFrame.minY - itemHeight
            let speedPopUpButtonFrame = CGRect(x: 0, y: speedPopUpButtonTop, width: size.width, height: itemHeight)
            
            let deviceTitleTop: CGFloat = speedPopUpButtonFrame.minY - textHeight
            let deviceTitleFrame = CGRect(x: 0, y: deviceTitleTop, width: size.width, height: textHeight)
            
            let devicePopUpButtonTop = deviceTitleFrame.minY - itemHeight
            let devicePopUpButtonFrame = CGRect(x: 0, y: devicePopUpButtonTop, width: size.width, height: itemHeight)
            
            let deviceUpdateButtonTop = devicePopUpButtonFrame.minY - itemHeight
            let deviceUpdateButtonFrame = CGRect(x: 0, y: deviceUpdateButtonTop, width: size.width, height: itemHeight)
            
            let deviceConnectButtonTop = deviceUpdateButtonFrame.minY - itemHeight
            let deviceConnectButtonFrame = CGRect(x: 0, y: deviceConnectButtonTop, width: size.width, height: itemHeight)
            
            let deviceDisconnectButtonTop = deviceConnectButtonFrame.minY - itemHeight
            let deviceDisconnectButtonFrame = CGRect(x: 0, y: deviceDisconnectButtonTop, width: size.width, height: itemHeight)
            
            if isSubviewsUpdate {
                speedTitle.frame = speedTitleFrame
                speedPopUpButton.frame = speedPopUpButtonFrame
                deviceTitle.frame = deviceTitleFrame
                devicePopUpButton.frame = devicePopUpButtonFrame
                deviceUpdateButton.frame = deviceUpdateButtonFrame
                deviceConnectButton.frame = deviceConnectButtonFrame
                deviceDisconnectButton.frame = deviceDisconnectButtonFrame
            }
            
            retHeight = deviceDisconnectButtonFrame.minY //- 2 * padding
        }
        return self.frame.size.height - retHeight
    }

    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)

        calcSubviewsHeight(withOldSize: oldSize, isSubviewsUpdate: true)
    }
    
    func setIsConnect(_ isConnect: Bool) {
        deviceConnectButton.isEnabled = !isConnect
        deviceDisconnectButton.isEnabled = isConnect
    }
    
    func setBaudRatesData(_ data: [Int]) {
        speedPopUpButton.removeAllItems()
        for baudRate in data {
            speedPopUpButton.addItem(withTitle: String(baudRate))
        }
    }
    
    func setDevicesData(_ data: [String]) {
        devicePopUpButton.removeAllItems()
        for item in data {
            devicePopUpButton.addItem(withTitle: item)
        }
    }
    
    //Click
    @objc
    func updateButtonClick() {
        onDevicesUpdate?()
    }
    
    @objc
    func connectButtonClick() {
        let baudRate = Int(speedPopUpButton.selectedItem?.title ?? "300") ?? 300
        let port = devicePopUpButton.selectedItem?.title ?? ""
        onConnect?(port, baudRate)
    }
    
    @objc
    func disconnectButtonClick() {
        onDisconnect?()
    }
}
