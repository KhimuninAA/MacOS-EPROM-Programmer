//
//  CoreCommand.swift
//  MacOS-GRBL-Controller-1
//
//  Created by Алексей Химунин on 08.08.2022.
//

import Foundation
import ORSSerial

class CoreCommand{
    var currentSerialPort: ORSSerialPort?
    
    private var isBusy: Bool = false
    private var complition: ((_ ret: String)->Void)?
    func send(command: String, complition: ((_ ret: String)->Void)?){
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
                self.complition?(fullReceive)
            }
        }
    }
}
