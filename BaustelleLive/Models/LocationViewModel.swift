//
//  LocationViewModel.swift
//  BaustelleLive
//
//  Created by Felix De Montis on 20.07.23.
//

import Foundation
import SwiftUI

struct LocationImage {
    var uiImage: UIImage
    var rawImageData: Data
}

protocol LocationViewViewModelProtocol: ObservableObject, Hashable {
    var location: String { get }
    var image: LocationImage { get }
    var id: String { get }
    var date: String { get }
    var videos: [BaustelleLiveVideo] { get }
        
    var imageOpen: Bool { get set }
    var shouldShare: Bool { get set }
    var imagePreviewDate: String { get set }
    var imagePreviewUrl: URL { get set }
    
    func loadPreviewContent()
}

class LocationViewViewModel: LocationViewViewModelProtocol {
    var location: String
    var image: LocationImage
    var id: String
    var date: String
    var videos: [BaustelleLiveVideo]
    
    @Published var imageOpen: Bool
    @Published var shouldShare: Bool
    @Published var imagePreviewDate: String
    @Published var imagePreviewUrl: URL
    
    init(location: String, image: LocationImage, id: String, date: String, videos: [BaustelleLiveVideo]) {
        self.location = location
        self.image = image
        self.id = id
        self.date = date
        self.videos = videos
        
        self.imageOpen = false
        self.shouldShare = false
        self.imagePreviewDate = ""
        self.imagePreviewUrl = FileManager.default.temporaryDirectory.appendingPathComponent("openImage.jpg")
    }
    
    func loadPreviewContent() {
        print("loadPreviewContent")
        do {
            try image.rawImageData.write(to: imagePreviewUrl, options: .atomic) // atomic option overwrites it if needed
            imagePreviewDate = String(date)
            
            imageOpen = true
        } catch {
            print("error writing to File, can't show it in QuickLook")
        }
    }
    
    static func == (lhs: LocationViewViewModel, rhs: LocationViewViewModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class MockLocationViewViewModel: LocationViewViewModelProtocol {
    var location: String = "Lindengasse 16"
    var image: LocationImage = {
        let exampleImage = UIImage(named: "li16")!
        return LocationImage(
            uiImage: exampleImage,
            rawImageData: exampleImage.jpegData(compressionQuality: 1)!
        )
    }()
    var id: String = "li16"
    var date: String = "23.08.2021, 19:14:11"
    var videos: [BaustelleLiveVideo] = BaustelleLiveApi.exampleResponse.li16.videos
    
    @Published var imageOpen: Bool = false
    @Published var shouldShare: Bool = false
    @Published var imagePreviewDate: String = ""
    @Published var imagePreviewUrl: URL = FileManager.default.temporaryDirectory.appendingPathComponent("openImage.jpg")
    
    func loadPreviewContent() {
        print("loadPreviewContent")
        do {
            try image.rawImageData.write(to: imagePreviewUrl, options: .atomic) // atomic option overwrites it if needed
            imagePreviewDate = String(date)
            
            imageOpen = true
        } catch {
            print("error writing to File, can't show it in QuickLook")
        }
    }
    
    static func == (lhs: MockLocationViewViewModel, rhs: MockLocationViewViewModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
