//
//  DynamoCondTypeCellView.swift
//  Dynamon
//
//  Created by Touch Duck on 2016/10/16.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa

class DynamoCondTypeCellView: NSTableCellView, DynamoCondProtocol {

    @IBOutlet weak var comboBox: NSComboBox!

    var keySchema: CDynamoKeySchema? = nil

    internal func dynamoMakeCell(keySchema: CDynamoKeySchema) {

        self.keySchema = keySchema

        makeComboBox();

        switch keySchema.scalarAttributeType {
        case CDynamoScalarAttributeType_S:
            comboBox.selectItem(at: 0)
        case CDynamoScalarAttributeType_N:
            comboBox.selectItem(at: 1)
        case CDynamoScalarAttributeType_B:
            comboBox.selectItem(at: 2)
        default:
            comboBox.selectItem(at: 1)
            keySchema.scalarAttributeType = CDynamoScalarAttributeType_N
        }

    }

    func makeComboBox() -> Void {

        comboBox.removeAllItems()
        comboBox.isEditable = false

        comboBox.addItem(withObjectValue: "String")
        comboBox.addItem(withObjectValue: "Number")
        comboBox.addItem(withObjectValue: "Binary")
    }

    @IBAction func changedCondType(_ sender: AnyObject) {

        switch comboBox.stringValue {
        case "String": keySchema?.scalarAttributeType = CDynamoScalarAttributeType_S
        case "Number": keySchema?.scalarAttributeType = CDynamoScalarAttributeType_N
        case "Binary": keySchema?.scalarAttributeType = CDynamoScalarAttributeType_B
        default:
            break
        }

    }

}
