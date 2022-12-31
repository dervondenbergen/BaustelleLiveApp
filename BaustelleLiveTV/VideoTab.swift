//
//  VideoTab.swift
//  BaustelleLiveTV
//
//  Created by Felix De Montis on 30.12.22.
//

import SwiftUI

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

struct VideoTab: View {
    
    @Environment(\.displayScale) var displayScale
    
    let locationName: String
    let direction: CompassDirection
    let videos: [BaustelleLiveVideo]!
    
    var rows: [[BaustelleLiveVideo]] {
        videos.chunked(into: 3)
    }
    
    var body: some View {
        ScrollView {            
            Grid(horizontalSpacing: 30, verticalSpacing: 30) {
                ForEach(Array(zip(rows.indices, rows)), id: \.0) { index, row in
                    GridRow {
                        ForEach(row) {video in
                            VideoTile(video: video)
                        }
                    }
                }
            }
            .padding()
        }
        .tabItem {
            Label {
                Text(locationName)
            } icon: {
                if let compassImage = Compass(direction: direction).asImage(size: 36, scale: displayScale) {
                    Image(uiImage: compassImage)
                }
            }
        }
    }
}

//struct VideoTab_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoTab()
//    }
//}
