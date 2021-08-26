//
//  LocationView.swift
//  BaustelleLive
//
//  Created by Felix De Montis on 23.08.21.
//

import SwiftUI
import AdvancedScrollView
import URLImage
import Just

struct LocationView: View {
    var location: String;
    var image: Image;
    var id: String;
    var rawImage: CGImage;
    var date: String;
    
    let magnification = Magnification(range: 1.0...5.0, initialValue: 1.0, isRelative: true)
    
    @State private var imageOpen = false;
    @State private var shouldShare = false;
    
    @State private var videosLoading = false;
    @State private var videos: [BaustelleLiveVideo] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Button(action: {
                    self.imageOpen = true;
                }) {
                    HStack {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 128, height: 72)
                            .cornerRadius(8.0)
                            .clipped()
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Letzte Aufnahme")
                                .foregroundColor(.primary)
                            Text(date)
                        }
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        
                    }
                }
                .padding(16.0)
                .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
                .sheet(isPresented: $imageOpen, onDismiss: {
                    if (self.shouldShare) {
                        
                        let shareImg = UIImage(cgImage: rawImage)
                        
                        let text = "Schau was gerade auf der U2xU5 Baustelle in der Lindengasse passiert!\n\nAlle 10 Sekunden aktualisierende Bilder findet man unter https://latest.baustelle.live"
                        
                        let activityController = UIActivityViewController(activityItems: [shareImg, text], applicationActivities: nil)
                        
                        UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
                        
                        self.shouldShare = false
                    }
                }, content: {
                    VStack {
                        HStack {
                            Text(date)
                            
                            Spacer()
                            
                            Button(action: {
                                self.shouldShare = true;
                                self.imageOpen = false;
                                
                            }) {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                        .padding(16.0)
                        AdvancedScrollView(magnification: magnification) { _ in
                            image
                        }
                    }
                })
                
                Text("Videos")
                    .font(.title)
                    .padding(.horizontal, 16.0)
                    .padding(.bottom, 8.0)
                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                
                
                ForEach(videos) {video in
                    VideoItem(video: video)
                }
                .padding(.horizontal, 16.0)
                .padding(.bottom, 16)
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                
            }
        }
        .padding(.top, 1)
        .navigationTitle(location)
        .onAppear {
            loadData()
        }
    }
    
    func loadData() {
        self.videosLoading = true
        
        let r = Just.get("https://latest.baustelle.live/videos_\(id).json")
        
        if (r.ok) {
            print("request ok")
            let decoder = JSONDecoder()
            let videoData = try! decoder.decode(BaustelleLiveVideos.self, from: r.content!)
            
            self.videos = videoData.videos
            
            self.videosLoading = false
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                let rawImage = UIImage(named: "li16")?.cgImage
                LocationView(location: "Lindengasse 16", image: Image("li16"), id: "li16", rawImage: rawImage!, date: "23.08.2021, 19:14:11")
            }
            .previewDevice("iPod touch (7th generation)")
        }
    }
}
