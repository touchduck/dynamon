//
//  Account.swift
//  Dynamon
//
//  Created by Touch Duck on 2016/10/02.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa

class OutlineTableInfo: NSObject {
    let name: String
    let icon: NSImage?

    init(name: String, icon: NSImage?) {
        self.name = name
        self.icon = icon
    }
}
