//
//  VideoTile.swift
//  BaustelleLiveTV
//
//  Created by Felix De Montis on 31.12.22.
//

import SwiftUI

struct VideoTile: View {
    
    let video: BaustelleLiveVideo
    
    var body: some View {
        Link(destination: URL(string: "https://youtube.com/watch?v=\(video.id)&list=\(video.playlist)")!, label: {
            VStack(spacing: 0) {
                AsyncImage(url: video.thumb, content: { image in
                    image
                        .resizable()
                        .aspectRatio(16 / 9, contentMode: .fill)
                }, placeholder: {
                    VStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        Spacer()
                    }
                    .aspectRatio(16 / 9, contentMode: .fill)
                    .background(Color.gray)
                })
                
                HStack(alignment: .center, spacing: 0) {
                    Text(video.date)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack(alignment: .center, spacing: 12) {
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
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                .padding(20)
            }
            .background(.gray)
            .cornerRadius(20)
            .clipped()
        })
//        .buttonStyle(.plain)
//        .cornerRadius(20)
//        .padding(0)
//        .clipped()
    }
}

//struct VideoTile_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoTile()
//    }
//}
