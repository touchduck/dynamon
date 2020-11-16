//
//  DynamoCondManager.swift
//  Dynamon
//
//  Created by Touch Duck on 2016/10/19.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa

class DynamoCondManager: NSObject {

    var cDynamoTable: CDynamoTable! = nil

    var indexWithCondDic: Dictionary<String, AnyObject> = Dictionary()
    var indexWithNameDic: Dictionary<String, String> = Dictionary()

    var defaultTableIndexName: String!

    func makeAll() -> Void {

        indexWithCondDic.removeAll()

        makeFromTableIndex()
        makeFromLocalIndex()
        makeFromGlobalIndex()
    }

    func makeFromTableIndex() -> Void {

        var newArray = Array<CDynamoKeySchema>()

        var comboName = "[ Table ] \(cDynamoTable!.tableName!): "

        for key in cDynamoTable!.keySchemas {
            let keySchema = key as! CDynamoKeySchema
            newArray.append(keySchema)
            comboName += "\(keySchema.attributeName!), "
        }
        let last = comboName.index(comboName.startIndex,
                offsetBy: comboName.count - 2)
        comboName = String(comboName[..<last])
        indexWithCondDic[comboName] = newArray as AnyObject?
        defaultTableIndexName = comboName
    }

    func makeFromLocalIndex() -> Void {

        for index in cDynamoTable!.localSecondaryIndexes {

            var newArray = Array<CDynamoKeySchema>()

            let localSecondaryIndex = index as! CDynamoLocalSecondaryIndex

            var comboName = "[ Local Secondary Index ] \(localSecondaryIndex.indexName!): "

            for key in localSecondaryIndex.keySchemas {
                let keySchema = key as! CDynamoKeySchema
                newArray.append(keySchema)
                comboName += "\(keySchema.attributeName!), "
            }

            let last = comboName.index(comboName.startIndex,
                    offsetBy: comboName.count - 2)
            comboName = String(comboName[..<last])
            indexWithCondDic[comboName] = newArray as AnyObject?
            indexWithNameDic[comboName] = localSecondaryIndex.indexName!
        }

    }

    func makeFromGlobalIndex() -> Void {

        for index in cDynamoTable!.globalSecondaryIndexes {

            var newArray = Array<CDynamoKeySchema>()

            let globalSecondaryIndex = index as! CDynamoGlobalSecondaryIndex

            var comboName = "[ Global Secondary Index ] \(globalSecondaryIndex.indexName!): "

            for key in globalSecondaryIndex.keySchemas {
                let keySchema = key as! CDynamoKeySchema
                newArray.append(keySchema)
                comboName += "\(keySchema.attributeName!), "
            }

            let last = comboName.index(comboName.startIndex,
                    offsetBy: comboName.count - 2)
            comboName = String(comboName[..<last])
            indexWithCondDic[comboName] = newArray as AnyObject?
            indexWithNameDic[comboName] = globalSecondaryIndex.indexName!
        }
    }

    func printInfo() -> Void {
        for (key, _) in indexWithCondDic {
            print("dictionary key is \(key)")
        }
    }
}
