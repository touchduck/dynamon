//
//  Department.swift
//  Dynamon
//
//  Created by Touch Duck on 2016/10/02.
//  Copyright © 2016年 Touch Duck. All rights reserved.
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
