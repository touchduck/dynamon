//
//  ItemListViewController.swift
//  Dynamon
//
//  Created by Touch Duck on 2016/10/02.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa
import RealmSwift

class DynamoListViewController: NSViewController,
        NSOutlineViewDelegate, NSOutlineViewDataSource {

    @IBOutlet weak var sourceListView: NSOutlineView!

    var listTables: Array<String>?

    var outlineTableList = OutlineTableList(name: "Tables", icon: NSImage(named: "TableIcon"))

    var document: Document? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        document = App.shared.document()
        document?.dynamoListViewController = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreTableList()
    }

    func refreTableList() -> Void {
        self.sourceListView?.expandItem(nil, expandChildren: true)

        self.listTables = []

        DispatchQueue.global().async {
            let cDynamo = self.document?.cDynamo
            cDynamo?.client.listTables({ (tableNames) in
                
                for tableName in tableNames! {
                    self.listTables?.append(tableName as! String)
                    let tbl = OutlineTableInfo(name: tableName as! String, icon: NSImage(named: "TableIcon"))
                    self.outlineTableList.tableInfos.append(tbl)
                }
                
                if self.outlineTableList.tableInfos.count > 0 {
                    DispatchQueue.main.async {
                        self.sourceListView.reloadData()
                        self.sourceListView.expandItem(self.outlineTableList, expandChildren: true)
                        
                        if self.outlineTableList.tableInfos.count > 0 {
                            self.sourceListView.selectRowIndexes(IndexSet.init(integer: 1), byExtendingSelection: true)
                        } else {
                            self.sourceListView.selectRowIndexes(IndexSet.init(integer: 0), byExtendingSelection: true)
                        }
                    }
                    
                }
                
            }, faild: { (errMsg) in
                DispatchQueue.main.async {
                    self.sourceListView.reloadData()
                    App.shared.showAlert(messageText:errMsg)
                }
            })
            
        }
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let item: AnyObject = item as AnyObject? {
            switch item {
            case let tblList as OutlineTableList:
                return tblList.tableInfos[index]
            default:
                return self
            }

        } else {
            switch index {
            case 0:
                return outlineTableList
            default:
                return self
            }
        }
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        switch item {
        case let tblList as OutlineTableList:
            return (tblList.tableInfos.count > 0) ? true : false
        default:
            return false
        }
    }

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {

        if let item: AnyObject = item as AnyObject? {
            switch item {
            case let tblList as OutlineTableList:
                return tblList.tableInfos.count
            default:
                return 0
            }
        }
        return 1
    }


    func outlineViewSelectionIsChanging(_ notification: Notification) {
        let index = self.sourceListView.selectedRow - 1
        if index < 0 {
            return
        }

        if self.outlineTableList.tableInfos.count <= index {
            return
        }
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {

        switch item {
        case let tblList as OutlineTableList:
            let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderCell"), owner: self) as! NSTableCellView
            if let textField = view.textField {
                textField.stringValue = tblList.name
            }
            return view
        case let tblInfo as OutlineTableInfo:
            let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DataCell"), owner: self) as! NSTableCellView
            if let textField = view.textField {
                textField.stringValue = tblInfo.name
            }
            //            if let image = tblInfo.icon {
            //                view.imageView!.image = image
            //            }
            return view
        default:
            return nil
        }

    }

    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        switch item {
        case _ as OutlineTableList:
            return true
        default:
            return false
        }
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {

        let selectedIndex = self.sourceListView.selectedRow
        let idx = selectedIndex - 1

        if selectedIndex <= 0 {
            self.document?.displayName = "Dynamon"
            self.document?.dynamoCondViewController?.changeTableName(tableName: "")
            self.document?.dynamoItemViewController?.dataClear(isRemoveAllColumns: true)

        } else {
            let tableName = self.listTables![idx]
            self.document?.displayName = tableName
            self.document?.dynamoCondViewController?.changeTableName(tableName: tableName)
            self.document?.dynamoItemViewController?.dataClear(isRemoveAllColumns: true)
        }

        let winCtl = self.view.window?.windowController
        winCtl?.synchronizeWindowTitleWithDocumentName()
    }
}
