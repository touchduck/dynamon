//
//  DynamoCondOperatorCellView.swift
//  Dynamon
//
//  Created by Touch Duck on 2016/10/16.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa

class DynamoCondOperatorCellView: NSTableCellView, DynamoCondProtocol {

    @IBOutlet weak var comboBox: NSComboBox!

    var condList = Array<String>()

    var keySchema: CDynamoKeySchema? = nil

    internal func dynamoMakeCell(keySchema: CDynamoKeySchema) {

        self.keySchema = keySchema

        comboBox.removeAllItems()
        condList.removeAll()
        comboBox.isEditable = false

        switch keySchema.keyType {
        case CDynamoKeyType_HASH:
            makeHash()
            break
        case CDynamoKeyType_RANGE:
            makeRange()
            break
        default:
            makeFilter()
            break
        }

        comboBox.addItems(withObjectValues: condList)
        findAndSetOperaterIndex()
    }

    func findAndSetOperaterIndex() -> Void {

        var ope = "="

        switch (keySchema?.comparisonOperator)! {
        case CDynamoComparisonOperator_EQ:ope = "="
        case CDynamoComparisonOperator_NE:ope = "!="
        case CDynamoComparisonOperator_LE:ope = "<="
        case CDynamoComparisonOperator_LT:ope = "<"
        case CDynamoComparisonOperator_GE:ope = ">="
        case CDynamoComparisonOperator_GT:ope = ">"
                //case CDynamoComparisonOperator_BETWEEN:ope = "Between"
        case CDynamoComparisonOperator_NOT_NULL:ope = "Exists"
        case CDynamoComparisonOperator_NULL_:ope = "Not Exists"
        case CDynamoComparisonOperator_CONTAINS:ope = "Contains [S]"
        case CDynamoComparisonOperator_NOT_CONTAINS:ope = "Not Contains [S]"
        case CDynamoComparisonOperator_BEGINS_WITH:ope = "Begins With [S]"
        default:
            keySchema?.comparisonOperator = CDynamoComparisonOperator_EQ
            break
        }

        comboBox.selectItem(withObjectValue: ope)
    }

    func makeHash() -> Void {
        condList.append("=")
    }

    func makeRange() -> Void {
        condList.append("=")
        condList.append("<")
        condList.append("<=")
        condList.append(">")
        condList.append(">=")
        //condList.append("Between")
    }

    func makeFilter() -> Void {
        condList.append("=")
        condList.append("!=")
        condList.append("<=")
        condList.append("<")
        condList.append(">=")
        condList.append(">")
        //condList.append("Between")
        condList.append("Exists")
        condList.append("Not Exists")
        condList.append("Contains [S]") // Can Not Use N
        condList.append("Not Contains [S]") // Can Not Use N
        condList.append("Begins With [S]") // Can Not Use N
    }

    @IBAction func changedOperator(_ sender: AnyObject) {

        switch comboBox.stringValue {
        case "=": keySchema?.comparisonOperator = CDynamoComparisonOperator_EQ
        case "!=": keySchema?.comparisonOperator = CDynamoComparisonOperator_NE
        case "<=": keySchema?.comparisonOperator = CDynamoComparisonOperator_LE
        case "<": keySchema?.comparisonOperator = CDynamoComparisonOperator_LT
        case ">=": keySchema?.comparisonOperator = CDynamoComparisonOperator_GE
        case ">": keySchema?.comparisonOperator = CDynamoComparisonOperator_GT
        case "Between": keySchema?.comparisonOperator = CDynamoComparisonOperator_BETWEEN
        case "Exists": keySchema?.comparisonOperator = CDynamoComparisonOperator_NOT_NULL
        case "Not Exists": keySchema?.comparisonOperator = CDynamoComparisonOperator_NULL_
        case "Contains [S]": keySchema?.comparisonOperator = CDynamoComparisonOperator_CONTAINS
        case "Not Contains [S]": keySchema?.comparisonOperator = CDynamoComparisonOperator_NOT_CONTAINS
        case "Begins With [S]": keySchema?.comparisonOperator = CDynamoComparisonOperator_BEGINS_WITH
        default:
            break
        }

    }

}
