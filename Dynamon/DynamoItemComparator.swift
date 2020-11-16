//
//  DynamoItemSortCompare.swift
//  Dynamon
//
//  Created by Touch Duck on 2016/10/10.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa

class DynamoItemComparator: NSObject {

    var sortDescriptors: [NSSortDescriptor] = []

    func compareRecord(items1: Any, items2: Any) -> ComparisonResult {

        var sortDescriptor: NSSortDescriptor?

        for descriptor in sortDescriptors {
            sortDescriptor = descriptor
            break
        }

        if sortDescriptor == nil {
            return ComparisonResult.orderedSame
        }

        let arr1 = items1 as! NSArray
        let arr2 = items2 as! NSArray

        var item1: CDynamoItem? = nil
        var item2: CDynamoItem? = nil

        for elem in arr1 {
            let dynamoItem = elem as! CDynamoItem
            if (dynamoItem.attributeName == sortDescriptor?.key) {
                item1 = dynamoItem
                break
            }
        }

        for elem in arr2 {
            let dynamoItem = elem as! CDynamoItem
            if (dynamoItem.attributeName == sortDescriptor?.key) {
                item2 = dynamoItem
                break
            }
        }

        if item1 == nil && item2 == nil {
            return ComparisonResult.orderedSame
        }

        if item1 == nil {
            if (sortDescriptor?.ascending)! {
                return ComparisonResult.orderedAscending
            } else {
                return ComparisonResult.orderedDescending
            }
        }

        if item2 == nil {
            if (sortDescriptor?.ascending)! {
                return ComparisonResult.orderedDescending
            } else {
                return ComparisonResult.orderedAscending
            }
        }

        switch (item1?.attributeType)! {
        case CDynamoItemTypeN:
            return compareN(sortDescriptor: sortDescriptor!, item1: item1!.display, item2: item2!.display)
        default:
            return compareS(sortDescriptor: sortDescriptor!, item1: item1!.display, item2: item2!.display)
        }

    }

    func compareN(sortDescriptor: NSSortDescriptor, item1: String, item2: String) -> ComparisonResult {

        var buff1: Int?
        buff1 = Int(item1)

        var buff2: Int?
        buff2 = Int(item2)

        if (buff1 == nil || buff2 == nil) {
            return compareFloat(sortDescriptor: sortDescriptor, item1: Float(item1)!, item2: Float(item2)!)
        }

        if (buff1! < buff2!) {
            if (sortDescriptor.ascending) {
                return ComparisonResult.orderedAscending
            } else {
                return ComparisonResult.orderedDescending
            }
        }

        if (buff1! > buff2!) {
            if (sortDescriptor.ascending) {
                return ComparisonResult.orderedDescending
            } else {
                return ComparisonResult.orderedAscending
            }
        }
        return ComparisonResult.orderedSame
    }

    func compareFloat(sortDescriptor: NSSortDescriptor, item1: Float, item2: Float) -> ComparisonResult {

        if (item1 < item2) {
            if (sortDescriptor.ascending) {
                return ComparisonResult.orderedAscending
            } else {
                return ComparisonResult.orderedDescending
            }
        }

        if (item1 > item2) {
            if (sortDescriptor.ascending) {
                return ComparisonResult.orderedDescending
            } else {
                return ComparisonResult.orderedAscending
            }
        }
        return ComparisonResult.orderedSame
    }


    func compareS(sortDescriptor: NSSortDescriptor, item1: String, item2: String) -> ComparisonResult {
        if (item1 < item2) {
            if (sortDescriptor.ascending) {
                return ComparisonResult.orderedAscending
            } else {
                return ComparisonResult.orderedDescending
            }
        }

        if (item1 > item2) {
            if (sortDescriptor.ascending) {
                return ComparisonResult.orderedDescending
            } else {
                return ComparisonResult.orderedAscending
            }
        }
        return ComparisonResult.orderedSame
    }

}
