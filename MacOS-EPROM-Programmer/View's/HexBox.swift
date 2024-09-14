//
//  HexBox.swift
//  MacOS-EPROM-Programmer
//
//  Created by Алексей Химунин on 11.09.2024.
//

import Foundation
import AppKit

class HexBox: NSBox {
    var scrollLogTextView = NSScrollView()
    var logTextField: NSTextField!
    var tableView: NSTableView!
    var col: NSTableColumn!
    
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
        
        scrollLogTextView.hasHorizontalScroller = false
        scrollLogTextView.hasVerticalScroller = true
        //scrollLogTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView?.addSubview(scrollLogTextView)
        
        logTextField = NSTextField(frame: scrollLogTextView.bounds)
        logTextField.isEditable = false
        logTextField.font = NSFont(name: "PT Mono", size: 24)
//        scrollLogTextView.documentView = logTextField
        
        tableView = NSTableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        //contentView?.addSubview(tableView)
        tableView.intercellSpacing = NSSize(width: 0.0, height: 0.0)
        tableView.headerView = nil
        scrollLogTextView.documentView = tableView
        
        col = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "col"))
        col.minWidth = 200
        tableView.addTableColumn(col)
        
        //tableView.reg
        
        self.sizeToFit()
        
        //tableView.scrollRowToVisible(99)
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        
        if let selfContent = self.contentView {
            let size = selfContent.frame.size
            
            let logTextFieldFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            scrollLogTextView.frame = logTextFieldFrame
        }
    }
    
    func clearLog() {
        logTextField.stringValue = ""
    }
    
    var rowsData: [String]?
    func setRows(rows: [String]) {
        rowsData = rows
        tableView.reloadData()
    }
    
//    func addLog(_ log: String) {
//        var tempLog = logTextField.stringValue
//        if tempLog.count > 0 {
//            tempLog += "\r\n"
//        }
//        tempLog += log
//        logTextField.stringValue = tempLog
//        logTextField.sizeToFit()
//        let height = logTextField.frame.size.height
//        let width = scrollLogTextView.frame.width
//        logTextField.frame = CGRect(x: 0, y: 0, width: width, height: height)
//    }
//    
//    func setStr(_ str: String) {
//        logTextField.stringValue = str
//        logTextField.sizeToFit()
//        let height = logTextField.frame.size.height
//        let width = scrollLogTextView.frame.width
//        logTextField.frame = CGRect(x: 0, y: 0, width: width, height: height)
//    }
}

extension HexBox: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return rowsData?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = NSTextField(frame: .zero)
        cell.wantsLayer = true
        //let redColor = NSColor.red.cgColor.copy(alpha: 0.4)
        cell.layer?.backgroundColor = NSColor.clear.cgColor
        cell.font = NSFont(name: "PT Mono", size: 24)
        cell.stringValue = rowsData?[row] ?? ""
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 32
    }
}
