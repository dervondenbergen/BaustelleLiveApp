//
//  LocationView.swift
//  BaustelleLive
//
//  Created by Felix De Montis on 23.08.21.
//

import SwiftUI
import URLImage
import SwiftUIX

struct LocationView: View {
    var location: String;
    var image: Image;
    var id: String;
    var rawImage: CGImage;
    var date: String;
    var videos: [BaustelleLiveVideo]
        
    @State private var imageOpen = false;
    @State private var shouldShare = false;
    
    @State private var imagePreviewUrl: URL = FileManager.default.temporaryDirectory.appendingPathComponent("openImage.jpg")
    
    var body: some View {
        List {
            Button(action: {
                do {
                    try UIImage(cgImage: rawImage).jpegData(compressionQuality: 1)?.write(to: imagePreviewUrl, options: .atomic) // atomic option overwrites it if needed
                    self.imageOpen = true
                } catch {
                    print("error writing to File, can't show it in QuickLook")
                }
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
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                }
            }
            .listRowSeparator(.hidden)
            .sheet(isPresented: $imageOpen, content: {
                NavigationView {
                    QuickLookView(previewItemUrls: [imagePreviewUrl], title: date)
                        .navigationTitle(date)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigation) {
                                Button(action: {
                                    self.imageOpen = false
                                }) {
                                    Text("Schließen")
                                }
                            }
                            
                            ToolbarItem(placement: .primaryAction) {
                                Button(action: {
                                    self.shouldShare.toggle();
                                }, label: {
                                    Image(systemName: "square.and.arrow.up")
                                })
                                .sheet(isPresented: $shouldShare) {
                                    let shareImg = UIImage(cgImage: rawImage)
                                    
                                    let text = "Schau was gerade auf der U2xU5 Baustelle in der Lindengasse passiert!\n\nAlle 10 Sekunden aktualisierende Bilder findet man unter https://latest.baustelle.live"
                                    
                                    AppActivityView(activityItems: [shareImg, text], applicationActivities: nil)
                                }
                            }
                        }
                }
                .navigationViewStyle(StackNavigationViewStyle())
            })
            
            let sectionHeader = {
                Text("Videos")
                    .font(.title)
                    .foregroundColor(.accentColor)
            }()
            
            Section(header: sectionHeader) {
                ForEach(videos) {video in
                    VideoItem(video: video)
                        .listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(location)
    }
}

#if DEBUG
struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                let rawImage = UIImage(named: "li16")?.cgImage
                LocationView(location: "Lindengasse 16", image: Image("li16"), id: "li16", rawImage: rawImage!, date: "23.08.2021, 19:14:11", videos: BaustelleLiveApi.exampleResponse.li16.videos)
            }
        }
    }
}
#endif
