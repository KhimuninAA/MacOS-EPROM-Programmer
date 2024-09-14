//
//  RootView.swift
//  MacOS-EPROM-Programmer
//
//  Created by Алексей Химунин on 04.09.2024.
//

import Foundation
import AppKit
import ORSSerial

class RootView: NSView{
    private let availableBaudRates = [300, 1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 115200, 230400]
    private let serialPortManager = ORSSerialPortManager.shared()
    let coreCommand = CoreCommand()
    
    var onResizeAction: (() -> Void)?
    var connectBox: ConnectBox!
    var actionBox: ActionBox!
    var romTabView: RomTabView!
    var hexBox: HexBox!
    
    var romData: Data?

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

        connectBox = ConnectBox(frame: .zero)
        connectBox.onDevicesUpdate = { [weak self] in
            self?.connectBox.setDevicesData(self?.getDeviceList() ?? [String]())
        }
        connectBox.onConnect = { [weak self] (port, baudRate) in
            self?.usbConnect(port: port, baudRate: baudRate)
        }
        connectBox.onDisconnect = { [weak self] in
            self?.coreCommand.currentSerialPort?.close()
        }
        addSubview(connectBox)
        
        actionBox = ActionBox()
        actionBox.onType = { [weak self] (type) in
            self?.action(type: type)
        }
        addSubview(actionBox)
        
        romTabView = RomTabView(frame: .zero)
        addSubview(romTabView)
        
        hexBox = HexBox ()
        addSubview(hexBox)
        
        coreCommand.onChangeStatusType = { [weak self] (type) in
            self?.updateConnectUI()
            switch type {
            case .none:
                self?.actionBox.addLog("none")
            case .removed:
                self?.actionBox.addLog("Port Removed")
            case .closed:
                self?.actionBox.addLog("Port Closed")
            case .opened:
                self?.actionBox.addLog("Port Opened")
            }
        }
        coreCommand.onFreeStatusType = { [weak self] (statusType) in
            if let text = statusType.text {
                self?.actionBox.addLog(text)
            }
        }

        initConnectData()
        actionBox.addLog("Start")
    }
    
    private func getDeviceList() -> [String] {
        var items = [String]()
        for availablePort in serialPortManager.availablePorts {
            items.append(availablePort.path)
        }
        return items
    }
    
    private func initConnectData() {
        connectBox.setIsConnect(false)
        connectBox.setBaudRatesData(availableBaudRates)
        connectBox.setDevicesData(getDeviceList())
    }

    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)

        let selfSize = self.frame.size
        let padding: CGFloat = 8
        let colWidth: CGFloat = 190

        let calcConnectBoxHeight = connectBox.calcSubviewsHeight(withOldSize: .zero)
        //let connectBoxHeight = selfSize.height - 2 * padding
        let connectBoxTop = selfSize.height - calcConnectBoxHeight - padding
        let connectBoxFrame = CGRect(x: padding, y: connectBoxTop, width: colWidth, height: calcConnectBoxHeight)
        connectBox.frame = connectBoxFrame
        
        let romTabViewLeft = connectBoxFrame.maxX + padding
        let romTabViewY = connectBoxFrame.minY// - romTabView.alignmentRectInsets.bottom * 0.5 //- romTabView.controlSize.
        let romTabViewFrame = CGRect(x: romTabViewLeft, y: romTabViewY, width: colWidth, height: connectBoxFrame.height)
        romTabView.frame = romTabViewFrame
        
        let actionBoxWidth = romTabViewFrame.maxX - padding //selfSize.width - 2 * padding
        let actionBoxHeight = connectBoxFrame.minY - 2 * padding
        let actionBoxFrame = CGRect(x: padding, y: padding, width: actionBoxWidth, height: actionBoxHeight)
        actionBox.frame = actionBoxFrame
        
        let hexBoxLeft = romTabViewFrame.maxX + padding
        let hexBoxHeight = selfSize.height - 2 * padding
        let hexBoxWidth = selfSize.width - hexBoxLeft - padding
        let hexBoxFrame = CGRect(x: hexBoxLeft, y: padding, width: hexBoxWidth, height: hexBoxHeight)
        hexBox.frame = hexBoxFrame
        
        onResizeAction?()
//        if let frame = window?.frame {
//            Storage.save(windowFrame: frame)
//        }
    }
    
    private func usbConnect(port: String, baudRate: Int) {
        self.coreCommand.open(port: port, baudRate: baudRate)
    }
    
    private func isUsbOpen() -> Bool {
        if let serialPort = self.coreCommand.currentSerialPort {
            return serialPort.isOpen
        }
        return false
    }
    
    func updateConnectUI() {
        let isOpen = isUsbOpen()
        connectBox.setIsConnect(isOpen)
    }
    
    func action(type: ActrionType) {
        switch type{
        case .none:
            break
        case .OpenFile:
            break
        case .SaveFile:
            break
        case .ShowBuffer:
            break
        case .Voltage:
            coreCommand.send(command: "v", complition: { [weak self] (ret) in
                if let text = ret.text {
                    self?.actionBox.addLog(text)
                }
            })
            break
        case .Read:
            romData = Data()
            hexBox.setRows(rows: [String]())
            actionBox.progressIndicator.doubleValue = 0
            if let romType = (romTabView.rom27TabItem.view as? Rom27View)?.getSelectedType() {
                coreCommand.send(command: romType.asCommand(), complition: { [weak self] (_) in
                    self?.coreCommand.send(command: "r", complition: { [weak self] (type) in
                        self?.romData?.append(type.data)
                        let progress = Double(self?.romData?.count ?? 0)/Double(romType.count)
                        self?.actionBox.progressIndicator.doubleValue = progress
                        if self?.romData?.count ?? 0 >= romType.count {
                            self?.readFinish()
                        }
                    })
                })
            }
            break
        case .Write:
            if let romType = (romTabView.rom27TabItem.view as? Rom27View)?.getSelectedType() {
                //coreCommand.send(command: romType.asCommand(), complition: nil)
                //coreCommand.send(command: "w", complition: nil)
            }
            break
        case .Verify:
            break
        }
    }
    
    func getNewStr(count: Int) -> String {
        let hByte = (0xFF00 & count) >> 8
        let lByte = (0x00FF & count)
        var str = String(format: "%02hhX", hByte)
        str += String(format: "%02hhX", lByte)
        str += ": "
        return str
    }
    
    func readFinish() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            var count: Int = 0
            var lenStr: String = self?.getNewStr(count: count) ?? ""
            var strList = [String]()
            if let data = self?.romData {
                for i in data {
                    lenStr += String(format: "%02hhX", i)
                    lenStr += " "
                    count += 1
                    if (count % 16) == 0 {
                        strList.append(lenStr + "\r\n")
                        //fullList += lenStr + "\r\n"
                        lenStr = self?.getNewStr(count: count) ?? ""
                    }
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.hexBox.setRows(rows: strList)
                //self?.hexBox.setStr(fullList)
            }
        }
    }
    
//case 'r': mode = READ; break;
//case 'w': mode = WRITE; break;
//case 'v': mode = VOLTAGE; break;
//case 'a': select_chip(C16); break;
//case 'b': select_chip(C32); break;
//case 'c': select_chip(C64); break;
//case 'd': select_chip(C128); break;
//case 'e': select_chip(C256); break;
//case 'f': select_chip(C512); break;
}
