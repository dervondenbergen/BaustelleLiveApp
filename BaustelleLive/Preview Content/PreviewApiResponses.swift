//
//  PreviewApiResponses.swift
//  BaustelleLive
//
//  Created by Felix De Montis on 21.01.22.
//

import Foundation

extension BaustelleLiveApi {
    static var exampleResponse = Bundle.main.decode(BaustelleLiveApi.self, from: "response.example.json")
}
