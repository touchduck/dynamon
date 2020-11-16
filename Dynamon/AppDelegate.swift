//
//  AppDelegate.swift
//  Dynamon
//
//  Created by Touch Duck on 2016/10/02.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa
import RealmSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    override init() {
        super.init()

        let realmConfig = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: { migration, oldSchemaVersion in
                    if (oldSchemaVersion < 1) {
                    }
                })

        print((realmConfig.fileURL?.absoluteString)!)

        Realm.Configuration.defaultConfiguration = realmConfig
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

