//
//  CredentialsModel.swift
//  BodyLotion
//
//  Created by 李均範 on 2020/08/06.
//  Copyright © 2020 李均範. All rights reserved.
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

