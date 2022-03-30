//
//  LocationView.swift
//  BaustelleLive
//
//  Created by Felix De Montis on 23.08.21.
//

import SwiftUI
import URLImage
import SwiftUIX

struct LocationImage {
    var uiImage: UIImage
    var rawImageData: Data
}

struct LocationView: View {
    var location: String;
    var image: LocationImage
    var id: String;
    var date: String;
    var videos: [BaustelleLiveVideo]
        
    @State private var imageOpen = false;
    @State private var shouldShare = false;
    
    @State private var imagePreviewDate: String = ""
    @State private var imagePreviewUrl: URL = FileManager.default.temporaryDirectory.appendingPathComponent("openImage.jpg")
    
    var body: some View {
        List {
            Button(action: {
                loadPreviewContent()
            }) {
                HStack {
                    Image(uiImage: image.uiImage)
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
                    QuickLookView(previewItemUrls: [imagePreviewUrl], title: imagePreviewDate)
                        .navigationTitle(imagePreviewDate)
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
                                    let shareImg = image.uiImage.copy()
                                    
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
        
    func loadPreviewContent() {
        do {
            try image.rawImageData.write(to: imagePreviewUrl, options: .atomic) // atomic option overwrites it if needed
            imagePreviewDate = date
            
            imageOpen = true
        } catch {
            print("error writing to File, can't show it in QuickLook")
        }
    }
}

#if DEBUG
struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                let exampleImage = UIImage(named: "li16")!
                let exampleLocationImage = LocationImage(
                    uiImage: exampleImage,
                    rawImageData: exampleImage.jpegData(compressionQuality: 1)!
                )
                LocationView(location: "Lindengasse 16", image: exampleLocationImage, id: "li16", date: "23.08.2021, 19:14:11", videos: BaustelleLiveApi.exampleResponse.li16.videos)
            }
        }
    }
}
#endif
