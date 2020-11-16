//
//  UserInfo.swift
//  Dynamon
//
//  Created by Touch Duck on 2016/09/22.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa
import RealmSwift

class CredentialsModel: Object {

    @objc dynamic var uuid = NSUUID().uuidString

    @objc dynamic var mode = 0

    @objc dynamic var region = ""

    @objc dynamic var method = ""
    @objc dynamic var host = ""
    @objc dynamic var port = ""

    @objc dynamic var accessKey = ""
    @objc dynamic var secretKey = ""

}
