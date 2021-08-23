//
//  BaustelleLiveApi.swift
//  BaustelleLive
//
//  Created by Felix De Montis on 23.08.21.
//

import Foundation

struct BaustelleLiveApi: Codable {
    var li16: Location!
    var li27: Location!
    
    struct Location: Codable {
        var id: String
        var human: String
        var imageUrl: String
    }
}
    
