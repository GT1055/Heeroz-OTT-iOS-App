//
//  File.swift
//  Mp4OfflineDownload
//
//  Created by user on 09/11/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CSCoreDataInitial: NSObject {
    /// Shared Instance Created
    static let SharedInstance = CSCoreDataInitial()
    /// core data manage data
    var managedObjectContext: NSManagedObjectContext
    override  init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "Vplayed", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application.
        // It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1].appendingPathComponent("Application Support/")
        do {
            try FileManager.default.createDirectory(atPath: docURL.path, withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        let storeURL = docURL.appendingPathComponent("Vplayed.sqlite")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType,
                                       configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
}
