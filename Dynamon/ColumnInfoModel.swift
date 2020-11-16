//
//  DynamonColumnInfo.swift
//  Dynamon
//
//  Created by 李均範 on 2016/10/11.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa
import RealmSwift

class ColumnInfoModel: Object {

    @objc dynamic var uuid = NSUUID().uuidString
    @objc dynamic var tableName = ""
    @objc dynamic var headerName = ""
    @objc dynamic var witdh = 0

    static func save(tableName: String!, headerName: String!, width: Int!) -> Void {

        let realm = try! Realm()

        let columnInfoModel = realm.objects(ColumnInfoModel.self)
            .filter("tableName = '\(tableName!)' and headerName = '\(headerName!)'").first

        if columnInfoModel == nil {

            let newData = ColumnInfoModel()
            newData.tableName = tableName
            newData.headerName = headerName
            newData.witdh = width

            try! realm.write {
                realm.add(newData)
            }

        } else {
            try! realm.write {
                columnInfoModel?.witdh = width
            }
        }

    }

}
