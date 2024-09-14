//
//  CoreCommand.swift
//  MacOS-GRBL-Controller-1
//
//  Created by Алексей Химунин on 08.08.2022.
//

import Foundation
import ORSSerial

struct ComplitionData {
    let data: Data
    let text: String?
}

class CoreCommand {
    var currentSerialPort: ORSSerialPort?
    var coreCommandSerial = CoreCommandSerial()
    var onChangeStatusType: ((_ type: SerialStatusType) -> Void)?
    var onFreeStatusType: ((_ type: ComplitionData) -> Void)?
    
    private var isBusy: Bool = false
    private var complition: ((_ ret: ComplitionData)->Void)?
    
    func send(command: String, complition: ((_ ret: ComplitionData)->Void)?){
        if isBusy == false{
            let newCommand = "\(command)\r"
            if let port = self.currentSerialPort, port.isOpen == true, let data = newCommand.data(using: String.Encoding.utf8){
                print("SEND: \(newCommand)")
                isBusy = true
                self.complition = complition
                self.fullReceive = nil
                port.send(data)
            }
        }
    }
    
    func close() {
        if let currentSerialPort = currentSerialPort {
            if currentSerialPort.isOpen {
                currentSerialPort.close()
            }
            self.currentSerialPort = nil
        }
    }
    
    func open(port: String, baudRate: Int) {
        close()
        //-- Open --
        if let serialPort = ORSSerialPort(path: port){
            serialPort.baudRate = baudRate as NSNumber
            serialPort.numberOfStopBits = 1
            serialPort.numberOfDataBits = 8
            
            serialPort.parity = .none

            coreCommandSerial.onChangeStatusType = { [weak self] (type) in
                self?.onChangeStatusType?(type)
            }
            coreCommandSerial.onReceiveData = { [weak self] (data) in
                self?.receiveData(data)
            }
            
            serialPort.delegate = coreCommandSerial
            
            serialPort.dtr = false
            serialPort.rts = false
            
            serialPort.open()
            
            if serialPort.isOpen {
                //serialPort.dtr = true
                //serialPort.rts = true
                self.currentSerialPort = serialPort
            }
        }
    }
    
    func receiveData(_ data: Data) {
        let dataAsString = NSString(data: data, encoding: String.Encoding.ascii.rawValue)
        let complitionData = ComplitionData(data: data, text: dataAsString as? String)
        if let complition = self.complition {
            self.isBusy = false
            complition(complitionData)
        } else {
            self.isBusy = false
            onFreeStatusType?(complitionData)
        }
        //self.complition = nil

    }
    
    func newConnect(){
        self.isBusy = false
        self.fullReceive = nil
        self.complition = nil
    }
    
    private var fullReceive: String? = nil
    func setReceive(_ receive: String){
        fullReceive = (fullReceive ?? "") + receive
        if let fullReceive = fullReceive{
            if fullReceive.lowercased().contains("ok"){
                self.isBusy = false
                self.fullReceive = nil
                //self.complition?(fullReceive)
            }
        }
    }
}

enum SerialStatusType {
    case none
    case removed
    case closed
    case opened
}

class CoreCommandSerial: NSObject, ORSSerialPortDelegate {
    var onChangeStatusType: ((_ type: SerialStatusType) -> Void)?
    var onReceiveData: ((_ data: Data) -> Void)?
    
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        //updateConnectUI()
        onChangeStatusType?(.removed)
    }
    
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        //actionBox.addLog("Port Closed")
        //updateConnectUI()
        onChangeStatusType?(.closed)
    }
    
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        //actionBox.addLog("Port Opened")
        //updateConnectUI()
        onChangeStatusType?(.opened)
    }
    
//    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: any Error) {
//        print(error)
//    }
//    
//    func serialPort(_ serialPort: ORSSerialPort, requestDidTimeout request: ORSSerialRequest) {
//        print(request)
//    }
    
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        onReceiveData?(data)
//        if let dataAsString = NSString(data: data, encoding: String.Encoding.ascii.rawValue) {
//            //print("Receive: \(dataAsString)")
//            //coreCommand.setReceive(dataAsString as String)
//            actionBox.addLog(dataAsString as String)
//        }
    }
    
//    func serialPort(_ serialPort: ORSSerialPort, didReceiveResponse responseData: Data, to request: ORSSerialRequest) {
//        print(request)
//    }
//    
//    func serialPort(_ serialPort: ORSSerialPort, didReceivePacket packetData: Data, matching descriptor: ORSSerialPacketDescriptor) {
//        print(packetData)
//    }
}
