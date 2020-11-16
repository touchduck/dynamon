//
//  DynamoTableCellView.swift
//  Dynamon
//
//  Created by 李均範 on 2016/10/03.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa

class DynamoItemCellView: NSTableCellView {

    var haveItem = false

    func setNotExistItem() {
        textField?.stringValue = ""
        textField?.placeholderString = "( not exist )"
    }

    func setDynamoItem(item: CDynamoItem) {
        textField?.stringValue = item.display
        haveItem = true
    }

}
