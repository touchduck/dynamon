//
//  Document.swift
//  Dynamon
//
//  Created by 李均範 on 2016/10/09.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

import Cocoa
import RealmSwift

class Document: NSDocument {

    var cDynamo: CDynamo?

    var dynamoListViewController: DynamoListViewController?
    var dynamoCondViewController: DynamoCondViewController?
    var dynamoItemViewController: DynamoItemViewController?

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
        displayName = "DynamoDB"
    }

    override class var autosavesInPlace: Bool {
        return false
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! WindowController
        addWindowController(windowController)
    }

    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func save(withDelegate delegate: Any?, didSave didSaveSelector: Selector?, contextInfo: UnsafeMutableRawPointer?) {
        // not ready
    }

    override func saveAs(_ sender: Any?) {
        // not ready
    }

}

