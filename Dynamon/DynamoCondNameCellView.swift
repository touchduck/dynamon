//
//  DynamoCondNameCellView.swift
//  Dynamon
//
//  Created by Touch Duck on 2016/10/16.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa

class DynamoCondNameCellView: NSTableCellView, DynamoCondProtocol {

    @IBOutlet weak var nameTextField: NSTextField!

    var keySchema: CDynamoKeySchema? = nil

    internal func dynamoMakeCell(keySchema: CDynamoKeySchema) {

        self.keySchema = keySchema

        switch keySchema.keyType {
        case CDynamoKeyType_HASH:
            nameTextField?.stringValue = keySchema.attributeName
            nameTextField?.isEditable = false
        case CDynamoKeyType_RANGE:
            nameTextField?.stringValue = keySchema.attributeName
            nameTextField?.isEditable = false
        default:
            nameTextField?.stringValue = ""
            nameTextField?.isEditable = true
            nameTextField?.placeholderString = "Enter attribute"
        }

        if keySchema.attributeName.count > 0 {
            nameTextField?.stringValue = keySchema.attributeName
        }

    }

    @IBAction func setInputValue(_ sender: AnyObject) {
        keySchema?.attributeName = nameTextField.stringValue
    }

}

