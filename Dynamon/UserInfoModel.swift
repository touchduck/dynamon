//
//  UserInfo.swift
//  Dynamon
//
//  Created by Touch Duck on 2016/09/22.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa
import RealmSwift

class AwsCredentialsModel: Object {

    @objc dynamic var uuid = NSUUID().uuidString
    @objc dynamic var awsRegion = ""
    @objc dynamic var awsDynamoDbLocal = 0
    @objc dynamic var awsMethod = ""
    @objc dynamic var awsHost = ""
    @objc dynamic var awsPort = ""
    @objc dynamic var awsAccessKey = ""
    @objc dynamic var awsSecretKey = ""

}
