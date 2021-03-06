//
//  BaustelleLiveApi.swift
//  BaustelleLive
//
//  Created by Felix De Montis on 23.08.21.
//

import Foundation

struct BaustelleLiveApi: Codable {
    var li16: BaustelleLiveApiLocation!
    var li27: BaustelleLiveApiLocation!
    var callout: String?
    var callout_test: String?
    var live: Bool?
}
struct BaustelleLiveApiLocation: Codable {
    var id: String
    var human: String?
    var imageUrl: String?
    var dateHash: String?
    var error: BaustelleLiveApiError?
    var videos: [BaustelleLiveVideo]!
    var live: Bool?
}

struct BaustelleLiveApiError: Codable {
    var type: BaustelleLiveApiErrorType
}

enum BaustelleLiveApiErrorType: String, Codable {
    case cameraoffline
}

struct BaustelleLiveVideo: Codable, Identifiable {
    var id: String
    var time: String
    var thumb: URL
    var type: BaustelleLiveVideoType
    var date: String
    var playlist: String
}

enum BaustelleLiveVideoType: String, Codable {
    case monthly
    case daily
}
