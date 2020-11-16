//
//  DynamoSearchCondCellView.swift
//  Dynamon
//
//  Created by 李均範 on 2016/10/15.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa

class DynamoCondAttributeCellView: NSTableCellView, DynamoCondProtocol {

    @IBOutlet weak var nameTextField: NSTextField!

    var keySchema: CDynamoKeySchema? = nil

    internal func dynamoMakeCell(keySchema: CDynamoKeySchema) {

        self.keySchema = keySchema

        nameTextField?.isEditable = false
        nameTextField?.isBordered = false

        switch keySchema.keyType {
        case CDynamoKeyType_HASH:
            nameTextField?.stringValue = "Partition key"
            break
        case CDynamoKeyType_RANGE:
            nameTextField?.stringValue = "Sort key"
            break
        default:
            nameTextField?.stringValue = "Filter"
            break
        }

    }

}
