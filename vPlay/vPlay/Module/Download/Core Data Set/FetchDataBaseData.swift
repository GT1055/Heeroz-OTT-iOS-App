//
//  FetchDataBaseData.swift
//  LearningSpaces
//
//  Created by user on 28/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CoreData
import CryptoSwift
/// Model Fetch Data From Data Basge
class FetchDataBaseData: NSObject {
    // Fetch saved Record's
    class func fetchSavedData(parentView: AnyObject,
                              completionHandler: @escaping(_ response: [AssertDetails]) -> Void) {
        let controller = parentView as? CSParentViewController
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AssertDetails")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate1 = NSPredicate(format: "userId == %@", LibraryAPI.sharedInstance.getUserId())
        let predicateCompound = NSCompoundPredicate.init(type: .and,
                                                         subpredicates: [predicate1])
        fetchRequest.predicate = predicateCompound
        do {
            let result = try CSCoreDataInitial.SharedInstance.managedObjectContext.fetch(fetchRequest) as?
                [AssertDetails]
            completionHandler(result!)
        } catch let error as NSError {
            controller?.showToastMessageTop(message: error.localizedDescription)
        }
    }
    // Fetch saved Record's
    class func checkFileExist(parentView: AnyObject, assertId: String,
                              completionHandler: @escaping(_ response: Bool) -> Void) {
        let controller = parentView as? CSParentViewController
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AssertDetails")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate1 = NSPredicate(format: "userId == %@", LibraryAPI.sharedInstance.getUserId())
        let predicate2 = NSPredicate(format: "assertId == %@", assertId)
        let predicateCompound = NSCompoundPredicate.init(type: .and,
                                                         subpredicates: [predicate1, predicate2])
        fetchRequest.predicate = predicateCompound
        do {
            let result = try CSCoreDataInitial.SharedInstance.managedObjectContext.fetch(fetchRequest) as?
                [AssertDetails]
            if (result?.count)! > 0 {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        } catch let error as NSError {
            controller?.showToastMessageTop(message: error.localizedDescription)
        }
    }
    // Save Assert To Data Base
    class func saveFileData(parentView: AnyObject, downloadUrl: URL!,
                            detail: CSDownloadModel!,
                            completionHandler: @escaping(_ responce: Bool) -> Void) {
        let controller = parentView as? CSParentViewController
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AssertDetails")
        let videoEntity = NSEntityDescription.entity(forEntityName: "AssertDetails",
                                                     in: CSCoreDataInitial.SharedInstance.managedObjectContext)
        let assertDetails = NSManagedObject(entity: videoEntity!,
                                            insertInto: CSCoreDataInitial.SharedInstance.managedObjectContext) as? AssertDetails
        fetchRequest.returnsObjectsAsFaults = false
        let predicate1 = NSPredicate(format: "userId == %@", LibraryAPI.sharedInstance.getUserId())
        let predicate2 = NSPredicate(format: "assertId == %@", detail.assertId)
        let predicateCompound = NSCompoundPredicate.init(type: .and,
                                                         subpredicates: [predicate1, predicate2])
        fetchRequest.predicate = predicateCompound
        do {
            let result = try CSCoreDataInitial.SharedInstance.managedObjectContext.fetch(fetchRequest) as?
                [AssertDetails]
            if (result?.count)! > 0 {  completionHandler(false); return }
            assertDetails?.userId = LibraryAPI.sharedInstance.getUserId()
            assertDetails?.assertId = detail.assertId
            assertDetails?.type = detail.type
            assertDetails?.title = detail.title
            assertDetails?.castCrew = detail.castCrew
            assertDetails?.desciption = detail.desciption
            assertDetails?.thumbnail = detail.thumbNail
            self.saveTheVideoAndAudioFile(downloadUrl, assertId: detail.assertId, parentView: parentView)
            do {
                try CSCoreDataInitial.SharedInstance.managedObjectContext.save()
                completionHandler(true)
            } catch let error as NSError {
                controller?.showToastMessageTop(message: error.localizedDescription)
            }
        } catch let error as NSError {
            controller?.showToastMessageTop(message: error.localizedDescription)
        }
    }
    // Save Assert To Data Base
    class func saveTheVideoAndAudioFile(_ assertUrl: URL!, assertId: String, parentView: AnyObject) {
        let controller = parentView as? CSParentViewController
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AssertFileData")
        let videoEntity = NSEntityDescription.entity(forEntityName: "AssertFileData",
                                                     in: CSCoreDataInitial.SharedInstance.managedObjectContext)
        let storeAssertData = NSManagedObject(entity: videoEntity!,
                                              insertInto: CSCoreDataInitial.SharedInstance.managedObjectContext) as? AssertFileData
        fetchRequest.returnsObjectsAsFaults = false
        let predicate1 = NSPredicate(format: "fileId == %@", assertId.aesEncryptedBase64String())
        let predicateCompound = NSCompoundPredicate.init(type: .and,
                                                         subpredicates: [predicate1])
        fetchRequest.predicate = predicateCompound
        do {
            let result = try CSCoreDataInitial.SharedInstance.managedObjectContext.fetch(fetchRequest) as? [AssertFileData]
            if (result?.count ?? 0) > 0 {
                return
            }
            storeAssertData?.fileId = assertId.aesEncryptedBase64String()
            storeAssertData?.fileUrl = assertUrl.lastPathComponent.aesEncryptedBase64String()
            /// Start Loader
            do {
                try CSCoreDataInitial.SharedInstance.managedObjectContext.save()
            } catch let error as NSError {
                controller?.showToastMessageTop(message: error.localizedDescription)
            }
        } catch let error as NSError {
            controller?.showToastMessageTop(message: error.localizedDescription)
        }
    }
    /// Fetch Assert File
    class func fetchAssertFile(parentView: AnyObject, assertId: String,
                               completionHandler: @escaping(_ responce: AssertFileData) -> Void) {
        let controller = parentView as? CSParentViewController
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AssertFileData")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate1 = NSPredicate(format: "fileId == %@", assertId.aesEncryptedBase64String())
        let predicateCompound = NSCompoundPredicate.init(type: .and,
                                                         subpredicates: [predicate1])
        fetchRequest.predicate = predicateCompound
        do {
            let result = try CSCoreDataInitial.SharedInstance.managedObjectContext.fetch(fetchRequest) as? [AssertFileData]
            if (result?.count)! > 0 {
                completionHandler((result?.first)!)
            }
        } catch let error as NSError {
            controller?.showToastMessageTop(message: error.localizedDescription)
        }
    }
}
// MARK: - Delete Methods
extension FetchDataBaseData {
    /// Delete a Saved File From Audio By it's audio ID
    class func deleteAssert(parentView: AnyObject,
                            assertId: String,
                            completionHandler: @escaping (_ response: [Any]) -> Void) {
        let controller = parentView as? CSParentViewController
        let moc = CSCoreDataInitial.SharedInstance.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AssertDetails")
        let predicate1 = NSPredicate(format: "userId == %@", LibraryAPI.sharedInstance.getUserId())
        let predicate2 = NSPredicate(format: "assertId == %@", assertId)
        let predicateCompound = NSCompoundPredicate.init(type: .and,
                                                         subpredicates: [predicate1, predicate2])
        fetchRequest.predicate = predicateCompound
        do {
            let result = try moc.fetch(fetchRequest) as? [AssertDetails]
            if result?.count == 1 {
                self.deleteAssertFile((result?.first?.assertId)!, filetype: (result?.first?.type)!,
                                      parentView: parentView)
                moc.delete((result?.first!)!)
                do {
                    try moc.save()
                    completionHandler(result!)
                } catch let error as NSError {
                    controller?.showToastMessageTop(message: error.localizedDescription)
                }
            }
        } catch let error as NSError {
            controller?.showToastMessageTop(message: error.localizedDescription)
        }
    }
    // Delete a Saved File From Audio By it's audio ID
    class func deleteAssertFile(_ fileId: String, filetype: String, parentView: AnyObject) {
        let controller = parentView as? CSParentViewController
        let moc = CSCoreDataInitial.SharedInstance.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AssertFileData")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate1 = NSPredicate(format: "fileId == %@", fileId.aesEncryptedBase64String())
        let predicateCompound = NSCompoundPredicate.init(type: .and,
                                                         subpredicates: [predicate1])
        fetchRequest.predicate = predicateCompound
        do {
            let result = try CSCoreDataInitial.SharedInstance.managedObjectContext.fetch(fetchRequest)
                as? [AssertFileData]
            if result?.count == 1 {
                self.removeTheSelectedFile((result?.first?.fileUrl)!, type: filetype)
                moc.delete((result?.first!)!)
                do {
                    try moc.save()
                } catch let error as NSError {
                    controller?.showToastMessageTop(message: error.localizedDescription)
                }
            }
        } catch let error as NSError {
            controller?.showToastMessageTop(message: error.localizedDescription)
        }
    }
    /// Delete all teh record
    class func deleteAllRecords(parentView: AnyObject,
                                completionHandler: @escaping (_ response: Bool) -> Void) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AssertDetails")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        let deleteFileFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AssertFileData")
        let deleteFileRequest = NSBatchDeleteRequest(fetchRequest: deleteFileFetch)
        do {
            try CSCoreDataInitial.SharedInstance.managedObjectContext.execute(deleteRequest)
            try CSCoreDataInitial.SharedInstance.managedObjectContext.save()
            try CSCoreDataInitial.SharedInstance.managedObjectContext.execute(deleteFileRequest)
            try CSCoreDataInitial.SharedInstance.managedObjectContext.save()
            self.removeAllTheFile()
            completionHandler(true)
        } catch {
        }
    }
    /// Remove One Particular file from the saved Path
    class func removeTheSelectedFile(_ assertName: String, type: String) {
        let decryptFile = assertName.aesDecryptBase64String()
        let assertArray = decryptFile.components(separatedBy: ".")
        let assert = assertArray.first! + "." + type
        let fileManager = FileManager.default
        let documentsUrl =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        let documentsPath = documentsUrl.path
        do {
            if let documentPath = documentsPath {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                for fileName in fileNames where assert == fileName {
                    if fileName.hasSuffix(".mp4") {
                        let filePathName = "\(documentPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                    } else if fileName.hasSuffix(".mp3") {
                        let filePathName = "\(documentPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                    }
                }
            }
        } catch {
        }
    }
    /// Remove all the file from the saved Path
    class func removeAllTheFile() {
        let fileManager = FileManager.default
        let documentsUrl =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        let documentsPath = documentsUrl.path
        do {
            if let documentPath = documentsPath {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                for fileName in fileNames {
                    if fileName.hasSuffix(".mp4") {
                        let filePathName = "\(documentPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                    } else if fileName.hasSuffix(".mp3") {
                        let filePathName = "\(documentPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                    }
                }
            }
        } catch {
        }
    }
    //This method is used to remove file at local document directory path
    class func removeItem(_ filePath: String) {
        if FileManager.default.fileExists(atPath: filePath) {
            do { try FileManager.default.removeItem(atPath: filePath)
            } catch { }
        }
    }
}
