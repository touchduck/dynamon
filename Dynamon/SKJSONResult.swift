//
//  CommonResponse.swift
//  Dynamon
//
//  Created by Touch Duck on 2017/04/16.
//  Copyright © 2017年 Touch Duck. All rights reserved.
//

import Cocoa
import ObjectMapper

class DynamonJSONResult: Mappable {

    var code: Int?
    var success: Bool?
    var message: String?

    required init?(map: Map) {

    }

    // Mappable
    func mapping(map: Map) {
        code <- map["code"]
        success <- map["success"]
        message <- map["message"]
    }
}
