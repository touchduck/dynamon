//
//  OutlineTableList.swift
//  BodyLotion
//
//  Created by 李均範 on 2020/08/06.
//  Copyright © 2020 李均範. All rights reserved.
//

import Cocoa

class OutlineTableList: NSObject {
    let name: String
    let icon: NSImage?
    var tableInfos: [OutlineTableInfo] = []

    init(name: String, icon: NSImage?) {
        self.name = name
        self.icon = icon
    }
}
