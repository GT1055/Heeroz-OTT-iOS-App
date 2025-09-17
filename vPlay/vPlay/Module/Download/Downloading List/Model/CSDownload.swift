//
//  CSDownload.swift
//  Skempi
//
//  Created by contus on 5/4/18.
//  Copyright © 2018 contus. All rights reserved.
//

import Foundation
import AVFoundation

class CSDownload {
    var track: CSTrack
    var task: URLSessionDownloadTask?
    var isDownloading = false
    var resumeData: Data?
    var progress: Float = 0
    var file = String()
    var downloadedFile = String()
    init(track: CSTrack) {
        self.track = track
    }
}

class CSTrack {
    let previewURL: URL
    var downloaded = false
    var isDownloadCompleted = false
    var downloadData: CSDownloadModel
    var downloadPath = String()
    init(previewURL: URL, video: CSDownloadModel) {
        self.previewURL = previewURL
        self.downloadData = video
    }
}
import ObjectMapper
class CSDownloadModel: Mappable {
    var assertId = String()
    var type = String()
    var title = String()
    var castCrew = String()
    var thumbNail = String()
    var desciption = String()
    var progress = Float()
    var file = String()
    var downloadedFile = String()
    required convenience init?(map: Map) {
    self.init()
    }
    func mapping( map: Map) {
        assertId <- map["video_Id"]
        title <- map["title"]
        type <- map["type"]
        castCrew <- map["castCrew"]
        desciption <- map["desciption"]
        thumbNail <- map["thumbNail"]
        progress <- map["progress"]
        file <- map["file"]
        downloadedFile <- map["file"]
    }
}
class CSDownloadResponce: Mappable {
    var originalUrl = String()
    var encPath = String()
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping( map: Map) {
        originalUrl <- map["org"]
        encPath <- map["path"]
    }
}
