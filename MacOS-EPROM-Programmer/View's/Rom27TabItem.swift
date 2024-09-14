//
//  Rom27TabItem.swift
//  MacOS-EPROM-Programmer
//
//  Created by Алексей Химунин on 08.09.2024.
//

import Foundation
import AppKit

enum Rom27Type {
    case C16
    case C32
    case C64
    case C128
    case C256
    case C512
    
    var count: Int {
        switch self {
        case .C16:
            return 2048
        case .C32:
            return 4096
        case .C64:
            return 8192
        case .C128:
            return 16384
        case .C256:
            return 32768
        case .C512:
            return 65536
        }
    }
    
    static let allValues = [C16,C32,C64,C128,C256,C512]
    func asStr() -> String {
        switch self {
        case .C16:
            return "C16"
        case .C32:
            return "C32"
        case .C64:
            return "C64"
        case .C128:
            return "C128"
        case .C256:
            return "C256"
        case .C512:
            return "C512"
        }
    }
    func asCommand() -> String {
        switch self {
        case .C16:
            return "a"
        case .C32:
            return "b"
        case .C64:
            return "c"
        case .C128:
            return "d"
        case .C256:
            return "e"
        case .C512:
            return "f"
        }
    }
    static func getType(by name: String) -> Rom27Type {
        for type in allValues {
            if name.contains(type.asStr()) {
                return type
            }
        }
        //Default
        return .C16
    }
}

class Rom27View: NSView {
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
        
        let def: Rom27Type = .C16
        for type in Rom27Type.allValues {
            let rodioButton = NSButton(frame: .zero)
            rodioButton.setButtonType(.radio)
            rodioButton.target = self
            rodioButton.action = #selector(radioClick)
            rodioButton.title = "27" + type.asStr()
            addSubview(rodioButton)
            if type == def {
                rodioButton.state = .on
            } else {
                rodioButton.state = .off
            }
        }
    }
    
    @objc private func radioClick(_ sender: NSButton) {
        for radio in self.subviews {
            if let radio = radio as? NSButton {
                if radio == sender {
                    let type = Rom27Type.getType(by: sender.title)
                    print(type)
                } else {
                    radio.state = .off
                }
            }
        }
    }
    
    func getSelectedType() -> Rom27Type? {
        for radio in self.subviews {
            if let radio = radio as? NSButton {
                if radio.state == .on {
                    return Rom27Type.getType(by: radio.title)
                }
            }
        }
        return nil
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        let selfSize = self.frame.size
        let padding: CGFloat = 8
        
        let buttonWidth = selfSize.width - 2 * padding
        let buttonHeight: CGFloat = 24
        var top = selfSize.height - buttonHeight - padding
        
        for radio in self.subviews {
            if let radio = radio as? NSButton {
                let frame = CGRect(x: padding, y: top, width: buttonWidth, height: buttonHeight)
                radio.frame = frame
                top = frame.minY - buttonHeight
            }
        }
    }
}

class Rom27TabItem: NSTabViewItem {
    
    override init(identifier: Any?) {
        super.init(identifier: Rom27View())
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    private func initView() {
        self.label = "27xxx"
        //wantsLayer = true
        
        self.view = Rom27View()
    }
}
