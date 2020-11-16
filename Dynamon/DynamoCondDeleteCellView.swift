//
//  DynamoCondDeleteCellView.swift
//  Dynamon
//
//  Created by Touch Duck on 2016/10/16.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa

class DynamoCondDeleteCellView: NSTableCellView, DynamoCondProtocol {

    @IBOutlet weak var deleteButton: NSButton!

    var rowIndex: Int?

    var keySchema: CDynamoKeySchema? = nil

    internal func dynamoMakeCell(keySchema: CDynamoKeySchema) {

        self.keySchema = keySchema

        switch keySchema.keyType {
        case CDynamoKeyType_HASH:
            deleteButton.isHidden = true
            break
        case CDynamoKeyType_RANGE:
            deleteButton.isHidden = true
            break
        default:
            deleteButton.isHidden = false
            break
        }

    }

}
