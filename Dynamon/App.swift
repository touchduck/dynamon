//
//  AppInfo.swift
//  Dynamon
//
//  Created by Touch Duck on 2017/05/02.
//  Copyright © 2017年 Touch Duck. All rights reserved.
//

import Cocoa
import RealmSwift

class App: NSObject {

    let infoDictionary = Bundle.main.infoDictionary!

    static let shared: App = {
        let instance = App()
        return instance
    }()

    // MARK: - Initialization Method
    override init() {
        super.init()
    }

    func hostApiV1() -> String {
        let hostapi = infoDictionary["TouchDuck-API-V1"]! as! String
        return hostapi
    }
    
    func document() -> Document? {
        let document = NSDocumentController.shared.currentDocument as! Document?
        return document;
    }
    
    func cDynamo() -> CDynamo? {
        return document()?.cDynamo
    }
    
    func showAlert(messageText:String?) -> Void {
        let alert = NSAlert()
        alert.messageText = messageText!
        alert.runModal()
    }
    
}
