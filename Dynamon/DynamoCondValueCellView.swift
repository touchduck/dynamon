//
//  DynamoCondValueCellView.swift
//  Dynamon
//
//  Created by Touch Duck on 2016/10/16.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa

class DynamoCondValueCellView: NSTableCellView, DynamoCondProtocol {

    @IBOutlet weak var valueTextField: NSTextField!

    var keySchema: CDynamoKeySchema? = nil

    internal func dynamoMakeCell(keySchema: CDynamoKeySchema) {

        self.keySchema = keySchema

        valueTextField.placeholderString = "Enter value"
        valueTextField.stringValue = ""

        switch keySchema.keyType {
        case CDynamoKeyType_HASH:
            break
        case CDynamoKeyType_RANGE:
            break
        default:

            break
        }

        if keySchema.inputValue.count > 0 {
            valueTextField?.stringValue = keySchema.inputValue
        }
    }

    @IBAction func setInputValue(_ sender: AnyObject) {
        keySchema?.inputValue = valueTextField.stringValue
    }
}
