//
//  DynamoCondViewController.swift
//  Dynamon
//
//  Created by Touch Duck on 2016/10/15.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa
import RealmSwift

class DynamoCondViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var comboBoxExecuteMethod: NSPopUpButton!
    @IBOutlet weak var comboBoxIndex: NSPopUpButtonCell!
    @IBOutlet weak var checkBoxAutoSort: NSButton!

    @IBOutlet weak var labelDataCounter: NSTextField!
    @IBOutlet weak var tableView: NSTableView!

    @IBOutlet weak var indicator: NSProgressIndicator!

    @IBOutlet weak var textFieldLimit: NSTextField!
    @IBOutlet weak var textFieldSleep: NSTextField!

    var currentTableName: String?

    let scanRequest = CDynamoScanRequest()
    let queryRequest = CDynamoQueryRequest()

    let dynamoCondManager = DynamoCondManager()

    var keySchemaRows: Array<CDynamoKeySchema>! = Array()
    var keyFilterRows: Array<CDynamoKeySchema>! = Array()

    var document: Document? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        document = App.shared.document()
        document?.dynamoCondViewController = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        clear()
    }

    func changeTableName(tableName: String) -> Void {
        currentTableName = tableName
        clear()
        changeCounter(count: 0)
        refreshTable()
    }

    func clear() -> Void {
        scanRequest.isStop = true
        queryRequest.isStop = true
        keySchemaRows.removeAll()
        keyFilterRows.removeAll()
        comboBoxIndex.removeAllItems()
        stopLoadingAnimation()
        self.tableView.reloadData()
    }

    func changeCounter(count: Int) -> Void {
        labelDataCounter.integerValue = count
    }

    func refreshTable() -> Void {

        if self.currentTableName?.count == 0 {
            return
        }

        clear()

        DispatchQueue.global().async {
            let cDynamo = self.document?.cDynamo
            cDynamo?.client.describeTable(self.currentTableName!, completion: { (dynamoTable) in

                self.dynamoCondManager.cDynamoTable = dynamoTable
                self.dynamoCondManager.makeAll()

                DispatchQueue.main.async {
                    for (key, _) in self.dynamoCondManager.indexWithCondDic {
                        self.comboBoxIndex.addItem(withTitle: key)
                    }
                    self.comboBoxIndex.selectItem(withTitle: self.dynamoCondManager.defaultTableIndexName as String)
                    self.setCurrentKeys()
                }

            }) { (errMsg) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                   App.shared.showAlert(messageText:errMsg)
                }

            }
        }
    }

    func setCurrentKeys() -> Void {

        if (comboBoxIndex.itemArray.count == 0) {
            return
        }

        keySchemaRows.removeAll()

        let keyName = comboBoxIndex.titleOfSelectedItem!
        let keyValues = self.dynamoCondManager.indexWithCondDic[keyName]

        // can not use hash or key in Scan (so not show)
        if comboBoxExecuteMethod.indexOfSelectedItem == 1 {
            for dynamoKeySchema in keyValues as! Array<CDynamoKeySchema> {
                keySchemaRows.append(dynamoKeySchema)
            }
        }

        keySchemaRows.append(contentsOf: keyFilterRows)

        self.tableView.reloadData()
    }

    func findRowKeySchema(row: Int) -> CDynamoKeySchema {
        return keySchemaRows[row]
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return keySchemaRows.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        let column = tableView.tableColumns.firstIndex(of: tableColumn!)!
        let keySchema = findRowKeySchema(row: row)

        switch column {
        case 0:
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CondAttributeCell"), owner: self) as? DynamoCondAttributeCellView {
                cell.dynamoMakeCell(keySchema: keySchema)
                return cell
            }
            break
        case 1:
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CondNameCell"), owner: self) as? DynamoCondNameCellView {
                cell.dynamoMakeCell(keySchema: keySchema)
                return cell
            }
            break
        case 2:
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CondTypeCell"), owner: self) as? DynamoCondTypeCellView {
                cell.dynamoMakeCell(keySchema: keySchema)
                return cell
            }
            break

        case 3:
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CondOperatorCell"), owner: self) as? DynamoCondOperatorCellView {
                cell.dynamoMakeCell(keySchema: keySchema)
                return cell
            }
            break
        case 4:
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CondValueCell"), owner: self) as? DynamoCondValueCellView {
                cell.dynamoMakeCell(keySchema: keySchema)
                return cell
            }
            break
        case 5:
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CondDeleteCell"), owner: self) as? DynamoCondDeleteCellView {
                cell.dynamoMakeCell(keySchema: keySchema)
                cell.rowIndex = row
                return cell
            }
            break
        default:
            break
        }

        return nil

    }

    @IBAction func pushedDeleteFilterButton(_ sender: AnyObject) {
        let dynamoCondDeleteCellView = sender.superview as! DynamoCondDeleteCellView
        let keySchema = keySchemaRows[dynamoCondDeleteCellView.rowIndex!]
        var idx = keySchemaRows.firstIndex(of: keySchema)
        keySchemaRows.remove(at: idx!)
        idx = keyFilterRows.firstIndex(of: keySchema)
        keyFilterRows.remove(at: idx!)
        setCurrentKeys()

    }

    private func tableView(tableView: NSTableView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, row: Int) {
    }

    @IBAction func addNewFilter(_ sender: AnyObject) {

        if currentTableName == "" {
            return
        }

        let newFilter = CDynamoKeySchema()
        newFilter.keyType = CDynamoKeyType_NOT_SET
        newFilter.attributeName = ""
        newFilter.scalarAttributeType = CDynamoScalarAttributeType_N

        keyFilterRows.append(newFilter)
        setCurrentKeys()
    }

    @IBAction func changedExecuteMethod(_ sender: AnyObject) {
        setCurrentKeys()
    }

    @IBAction func changedIndex(_ sender: AnyObject) {
        keySchemaRows.removeAll()
        keyFilterRows.removeAll()

        setCurrentKeys()
    }

    @IBAction func stopForSearch(_ sender: AnyObject) {
        scanRequest.isStop = true
        queryRequest.isStop = true
    }

    @IBAction func changedAutoSort(_ sender: AnyObject) {
        switch checkBoxAutoSort.state {
        case NSControl.StateValue.on:
            document?.dynamoItemViewController?.sortItems()
            document?.dynamoItemViewController?.tableView.reloadData()
        default:
            break
        }
    }

    @IBAction func startSearch(_ sender: AnyObject) {

        if currentTableName == "" {
            return
        }

        if !indicator.isHidden {
            App.shared.showAlert(messageText:"Searching..(can use stop button)")
            return
        }

        self.view.window?.makeFirstResponder(sender as? NSResponder)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.search()
        }

    }

    func search() -> Void {

        if comboBoxIndex.itemArray.count == 0 {
            return
        }

        let limitValue = textFieldLimit.integerValue
        if (limitValue <= 0) {
            textFieldLimit.integerValue = 1
        }

        let sleepValue = textFieldSleep.floatValue
        if (sleepValue <= 0) {
            textFieldSleep.stringValue = "0.0"
        }

        switch comboBoxExecuteMethod.indexOfSelectedItem {
        case 0:
            executeScan()
        case 1:
            executeQuery()
        default:
            break
        }

    }

    func executeScan() -> Void {

        scanRequest.clear()
        scanRequest.tableName = currentTableName

        let selectedIndexName = comboBoxIndex.titleOfSelectedItem!
        if dynamoCondManager.indexWithNameDic.index(forKey: selectedIndexName) != nil {
            let indexName = dynamoCondManager.indexWithNameDic[comboBoxIndex.titleOfSelectedItem!]
            scanRequest.indexName = indexName
        }

        scanRequest.limit = Int(textFieldLimit.integerValue)
        scanRequest.sleepTime = CGFloat(textFieldSleep.floatValue)
        scanRequest.config()

        for keySchema in keySchemaRows {
            switch keySchema.keyType {
            case CDynamoKeyType_HASH:
                break
            case CDynamoKeyType_RANGE:
                break
            default:
                scanRequest.setFilter(keySchema)
            }
        }

        startLoadingAnimation()

        document?.dynamoItemViewController?.dataScan(scanRequest: scanRequest, sender: self)
    }

    func executeQuery() -> Void {

        queryRequest.clear()
        queryRequest.tableName = currentTableName

        let selectedIndexName = comboBoxIndex.titleOfSelectedItem!
        if dynamoCondManager.indexWithNameDic.index(forKey: selectedIndexName) != nil {
            let indexName = dynamoCondManager.indexWithNameDic[comboBoxIndex.titleOfSelectedItem!]
            queryRequest.indexName = indexName
        }

        queryRequest.limit = Int(textFieldLimit.integerValue)
        queryRequest.sleepTime = CGFloat(textFieldSleep.floatValue)

        queryRequest.config()

        for keySchema in keySchemaRows {
            switch keySchema.keyType {
            case CDynamoKeyType_HASH:
                if keySchema.inputValue.count == 0 {
                    App.shared.showAlert(
                        messageText:"The supplied Item contains a null AttributeValue of Partion Key")
                    return
                }
                queryRequest.setHashKey(keySchema)
            case CDynamoKeyType_RANGE:
                queryRequest.setRangeKey(keySchema)
            default:
                queryRequest.setFilter(keySchema)
            }
        }

        startLoadingAnimation()

        document?.dynamoItemViewController?.dataQuery(queryRequest: queryRequest, sender: self)
    }

    func startLoadingAnimation() -> Void {
        self.indicator.isHidden = false
        self.indicator.startAnimation(self)
    }

    func stopLoadingAnimation() -> Void {
        self.indicator.isHidden = true
        self.indicator.stopAnimation(self)
    }

}
