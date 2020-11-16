//
//  DynamoItemViewController.swift
//  Dynamon
//
//  Created by 李均範 on 2016/10/03.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa
import RealmSwift

class DynamoItemViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var tableView: NSTableView!
    
    var currentTableName: String! = ""
    
    let cDynamoTable = CDynamoTable()
    
    let dynamoSorter = DynamoItemComparator()
    
    var dynamoCondViewController: DynamoCondViewController! = nil
    
    var headerNameList: Array<String> = Array()
    
    var document: Document? = nil
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        document = App.shared.document()
        document?.dynamoItemViewController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataClear(isRemoveAllColumns: true)
    }
    
    func dataClear(isRemoveAllColumns: Bool) -> Void {
        
        if isRemoveAllColumns {
            
            headerNameList.removeAll()
            
            while (tableView.tableColumns.count > 0) {
                tableView.removeTableColumn(tableView.tableColumns.last!)
            }
            
            dynamoSorter.sortDescriptors.removeAll()
            cDynamoTable.headers.removeAllObjects()
        }
        
        cDynamoTable.items.removeAllObjects()
    }
    
    func dataScan(scanRequest: CDynamoScanRequest, sender: Any!) {
        
        self.dynamoCondViewController = sender as? DynamoCondViewController
        
        if scanRequest.tableName.count == 0 {
            return
        }
        
        if currentTableName != scanRequest.tableName {
            currentTableName = scanRequest.tableName
            self.dataClear(isRemoveAllColumns: true)
        } else {
            self.dataClear(isRemoveAllColumns: false)
        }
        
        document?.dynamoCondViewController?.changeCounter(count: 0)
        
        DispatchQueue.global(qos: .background).async {
            
            let cDynamo = self.document?.cDynamo
            cDynamo?.client.scan(scanRequest, completion: { (headers, items) in
                self.cDynamoTable.items.addObjects(from: items!)
                
                DispatchQueue.main.async {
                    for header in headers! {
                        self.cDynamoTable.addHeader(header)
                        if self.headerNameList.firstIndex(of: header.attributeName) == nil {
                            self.addTableHeader(header: header)
                        }
                        self.headerNameList.append(header.attributeName)
                    }
                    
                    if self.dynamoCondViewController.checkBoxAutoSort.state == NSControl.StateValue.on {
                        self.sortItems()
                    }
                    
                    self.document?.dynamoCondViewController?.changeCounter(count: self.cDynamoTable.items.count)
                    self.tableView.reloadData()
                }
                
            }, faild: { (errMsg) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    App.shared.showAlert(messageText:errMsg)
                }
                
            }, end: {
                DispatchQueue.main.async {
                    self.dynamoCondViewController.stopLoadingAnimation()
                }
            })
            
        }
        
    }
    
    func dataQuery(queryRequest: CDynamoQueryRequest, sender: Any!) {
        
        self.dynamoCondViewController = sender as? DynamoCondViewController
        
        if queryRequest.tableName.count == 0 {
            return
        }
        
        if currentTableName != queryRequest.tableName {
            currentTableName = queryRequest.tableName
            self.dataClear(isRemoveAllColumns: true)
        } else {
            self.dataClear(isRemoveAllColumns: false)
        }
        
        document?.dynamoCondViewController?.changeCounter(count: 0)
        
        DispatchQueue.global(qos: .background).async {
            
            let cDynamo = self.document?.cDynamo
            
            cDynamo?.client.query(queryRequest, completion: { (headers, items) in
                
                self.cDynamoTable.items.addObjects(from: items!)
                
                DispatchQueue.main.async {
                    for header in headers! {
                        self.cDynamoTable.addHeader(header)
                        if self.headerNameList.firstIndex(of: header.attributeName) == nil {
                            self.addTableHeader(header: header)
                        }
                        self.headerNameList.append(header.attributeName)
                        
                    }
                    
                    if self.dynamoCondViewController.checkBoxAutoSort.state == NSControl.StateValue.on {
                        self.sortItems()
                    }
                    
                    self.document?.dynamoCondViewController?.changeCounter(count: self.cDynamoTable.items.count)
                    self.tableView.reloadData()
                }
                
            }, faild: { (errMsg) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    App.shared.showAlert(messageText:errMsg)
                }
                
            }, end: {
                DispatchQueue.main.async {
                    self.dynamoCondViewController.stopLoadingAnimation()
                }
                
            })
            
        }
        
    }
    
    func addTableHeader(header: CDynamoHeader) {
        
        let tableColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(header.headerName))
        
        let realm = try! Realm()
        
        let columnInfoModel = realm.objects(ColumnInfoModel.self)
            .filter("tableName = '\(currentTableName!)' and headerName = '\(header.headerName!)'").first
        
        if columnInfoModel == nil {
            tableColumn.width = 120
            
        } else {
            try! realm.write {
                tableColumn.width = CGFloat((columnInfoModel?.witdh)!)
            }
        }
        
        let sortDescriptor = NSSortDescriptor(key: header.attributeName, ascending: true)
        tableColumn.sortDescriptorPrototype = sortDescriptor
        
        let cell = NSTableHeaderCell(textCell: header.headerName)
        cell.textColor = NSColor.white
        cell.alignment = NSTextAlignment.left
        
        tableColumn.headerCell = cell;
        
        self.tableView.addTableColumn(tableColumn)
    }
    
    func sortItems() -> Void {
        dynamoSorter.sortDescriptors = tableView.sortDescriptors
        cDynamoTable.items.sort(options: NSSortOptions.stable, usingComparator: dynamoSorter.compareRecord)
        tableView.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return cDynamoTable.items.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if cDynamoTable.items.count <= row {
            return nil
        }
        
        for item in cDynamoTable.items[row] as! [CDynamoItem] {
            if (item.headerName! == tableColumn?.identifier.rawValue) {
                if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ItemCell"), owner: self) as? DynamoItemCellView {
                    cell.setDynamoItem(item: item)
                    return cell
                }
            }
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ItemCell"), owner: self) as? DynamoItemCellView {
            cell.setNotExistItem()
            return cell
        }
        
        return nil
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        sortItems()
        tableView.reloadData()
    }
    
    func tableViewColumnDidResize(_ notification: Notification) {
        
        let tableColumn = notification.userInfo?["NSTableColumn"] as? NSTableColumn
        if (tableColumn != nil) {
            ColumnInfoModel.save(tableName: currentTableName,
                                 headerName: tableColumn?.headerCell.stringValue,
                                 width: Int((tableColumn?.width)!))
        }
        
    }
    
}
