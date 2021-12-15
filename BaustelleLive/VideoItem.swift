//
//  VideoItem.swift
//  BaustelleLive
//
//  Created by Felix De Montis on 26.08.21.
//

import SwiftUI
import URLImage

struct VideoItem: View {
    var video: BaustelleLiveVideo!
    
    var body: some View {
        Link(destination: URL(string: "https://youtube.com/watch?v=\(video.id)&list=\(video.playlist)")!, label: {
            HStack {
                URLImage(video.thumb) {
                    // This view is displayed before download starts
                    EmptyView()
                } inProgress: { progress in
                    // Display progress
                    VStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        Spacer()
                    }
                    .frame(width: 128, height: 72)
                    .background(Color.gray)
                    .cornerRadius(8.0)
                } failure: { error, retry in
                    // Display error and retry button
                } content: { image, info in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 128, height: 72)
                        .cornerRadius(8.0)
                        .clipped()
                    
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(video.date)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 5) {
                        Text(video.time)
                            .category()

                        switch video.type {
                        case .daily:
                            Text("Daily")
                                .category(background: .purple)
                        case .monthly:
                            Text("Monthly")
                                .category(background: .orange)
                        }
                        
                        
                    }.padding(.bottom, 3)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "arrow.up.forward")
                    .font(.headline)
                    .foregroundColor(.primary)
                
            }
        })
    }
}

let exampleVideo = BaustelleLiveVideo(
    id: "LH4JoZgMkZ0",
    time: "1:41",
    thumb: URL(string: "https://i3.ytimg.com/vi/LH4JoZgMkZ0/maxresdefault.jpg")!,
    type: .daily,
    date: "15. Juli 2021",
    playlist: "PLIKbLfgTek4SWjAqDueEzGJkpwGIKAhrD"
)

struct VideoItem_Previews: PreviewProvider {
    static var previews: some View {
            VideoItem(video: exampleVideo)
                .previewLayout(.sizeThatFits)
    }
}
