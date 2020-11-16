//
//  ViewController.swift
//  Dynamon
//
//  Created by Touch Duck on 2016/10/02.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa
import RealmSwift
import Alamofire
import ObjectMapper
import SwiftyJSON

class AuthViewController: NSViewController {

    @IBOutlet weak var popupRegion: NSPopUpButton!
    @IBOutlet weak var checkboxMode: NSButton!
    @IBOutlet weak var popupMethod: NSPopUpButton!
    @IBOutlet weak var textfieldHost: NSTextField!
    @IBOutlet weak var textfieldPort: NSTextField!
    @IBOutlet weak var textfieldAccessKey: NSTextField!
    @IBOutlet weak var securefieldSecretKey: NSSecureTextField!

    let realm = try! Realm()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateDynamoLocal(canUse: false)

        textfieldHost.placeholderString = "localhost"
        textfieldPort.placeholderString = "8000"

        let userinfos = realm.objects(CredentialsModel.self)
        if userinfos.count > 0 {

            let userinfo = userinfos[0]

            popupRegion.selectItem(withTitle: userinfo.region)
            checkboxMode.integerValue = userinfo.mode
            popupMethod.selectItem(withTitle: userinfo.method)
            textfieldHost.stringValue = userinfo.host
            textfieldPort.stringValue = userinfo.port
            textfieldAccessKey.stringValue = userinfo.accessKey
            securefieldSecretKey.stringValue = userinfo.secretKey

            if checkboxMode.state == NSControl.StateValue.on {
                updateDynamoLocal(canUse: true)
            } else {
                updateDynamoLocal(canUse: false)
            }
        }
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    func updateDynamoLocal(canUse: Bool) -> Void {
        if canUse {
            popupMethod.isEnabled = true
            textfieldHost.isEnabled = true
            textfieldPort.isEnabled = true
        } else {
            popupMethod.isEnabled = false
            textfieldHost.isEnabled = false
            textfieldPort.isEnabled = false
        }
    }

    @IBAction func pushedCustomDynamoLocal(_ sender: AnyObject) {
        if checkboxMode.state == NSControl.StateValue.on {
            updateDynamoLocal(canUse: true)
        } else {
            updateDynamoLocal(canUse: false)
        }
    }

    func isValid() -> Bool {

        if checkboxMode.state == NSControl.StateValue.on {
            if textfieldHost.stringValue.count == 0 {
                App.shared.showAlert(messageText:"Invalid hostname")
                return true
            }
            if textfieldPort.stringValue.count == 0 {
                App.shared.showAlert(messageText:"Invalid port")
                return true
            }
        }

        if textfieldAccessKey.stringValue.count == 0 {
            App.shared.showAlert(messageText:"Invalid Access Key ID")
            return true
        }

        if securefieldSecretKey.stringValue.count == 0 {
            App.shared.showAlert(messageText:"Invalid Secret Key")
            return true
        }

        return false
    }

    @IBAction func login(_ sender: AnyObject) {

        if isValid() {
            return
        }

        let selectedDate = Calendar.current.date(from: DateComponents(year: 2020, month: 12, day: 25))!

        //print(selectedDate.compare(Date()).rawValue)

        if selectedDate.compare(Date()).rawValue > 0 {
            let cDynamo = makeCDynamo()
            self.awsLogin(cDynamo: cDynamo)
        } else {
            App.shared.showAlert(messageText:"please update new version")
        }

    }

    func awsLogin(cDynamo:CDynamo) -> Void {
        
        cDynamo.client.listTables({ (tableNames) in
            
            let document = App.shared.document()
            document?.cDynamo = cDynamo
            
            let viewController = self.storyboard?
                .instantiateController(withIdentifier:
                    "contentSplitViewController") as! NSSplitViewController
            
            if self.view.frame.width > viewController.view.frame.width {
                viewController.view.frame = self.view.frame
            }
            
            self.view.window?.contentViewController = viewController
            
        }, faild: { (errMsg) in
            DispatchQueue.main.async {
                App.shared.showAlert(messageText:errMsg)
            }
        })
    }

    func makeCDynamo() -> CDynamo {

        let userinfos = realm.objects(CredentialsModel.self)
        if userinfos.count > 0 {
            try! realm.write {
                realm.delete(userinfos)
            }
        }
        
        let userinfo = CredentialsModel()
        userinfo.region = popupRegion.titleOfSelectedItem!
        userinfo.mode = checkboxMode.integerValue
        userinfo.method = popupMethod.titleOfSelectedItem!
        userinfo.host = textfieldHost.stringValue
        userinfo.port = textfieldPort.stringValue
        userinfo.accessKey = textfieldAccessKey.stringValue
        userinfo.secretKey = securefieldSecretKey.stringValue

        try! realm.write {
            realm.add(userinfo)
        }

        let cDynamo = CDynamo()
        
        cDynamo.awsRegion = userinfo.region
        
        switch userinfo.mode {
        case 1:
            if userinfo.method == "HTTP" {
                cDynamo.awsScheme = CDynamoScheme_HTTP
            }
            cDynamo.awsProxyHost = userinfo.host
            cDynamo.awsProxyPort = UInt(userinfo.port)!
        default:
            break
        }

        cDynamo.awsAccessKeyId = userinfo.accessKey
        cDynamo.awsSecretKey = userinfo.secretKey

        cDynamo.config()

        return cDynamo
    }

}
