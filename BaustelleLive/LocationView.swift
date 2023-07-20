//
//  LocationView.swift
//  BaustelleLive
//
//  Created by Felix De Montis on 23.08.21.
//

import SwiftUI
import SwiftUIX

struct LocationView<ViewModel: LocationViewViewModelProtocol>: View {
    @ObservedObject var locationData: ViewModel
    
    var body: some View {
        List {
            Button(action: {
                locationData.loadPreviewContent()
            }) {
                HStack {
                    Image(uiImage: locationData.image.uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 128, height: 72)
                        .cornerRadius(8.0)
                        .clipped()
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Letzte Aufnahme")
                            .foregroundColor(.primary)
                        Text(locationData.date)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                }
            }
            .listRowSeparator(.hidden)
            
            let sectionHeader = {
                Text("Videos")
                    .font(.title)
                    .foregroundColor(.accentColor)
            }()
            
            Section(header: sectionHeader) {
                ForEach(locationData.videos) {video in
                    VideoItem(video: video)
                        .listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(locationData.location)
        .sheet(isPresented: $locationData.imageOpen, content: {
            NavigationView {
                QuickLookView(previewItemUrls: [locationData.imagePreviewUrl], title: locationData.imagePreviewDate)
                    .navigationTitle(locationData.imagePreviewDate)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigation) {
                            Button(action: {
                                self.locationData.imageOpen = false
                            }) {
                                Text("Schließen")
                            }
                        }
                        
                        ToolbarItem(placement: .primaryAction) {
                            Button(action: {
                                self.locationData.shouldShare.toggle();
                            }, label: {
                                Image(systemName: "square.and.arrow.up")
                            })
                            .sheet(isPresented: $locationData.shouldShare) {
                                let shareImg = locationData.image.uiImage.copy()
                                
                                let text = "Schau was gerade auf der U2xU5 Baustelle in der Lindengasse passiert!\n\nAlle 10 Sekunden aktualisierende Bilder findet man unter https://latest.baustelle.live"
                                
                                AppActivityView(activityItems: [shareImg, text], applicationActivities: nil)
                            }
                        }
                    }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        })
    }
}

#if DEBUG
struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                LocationView(locationData: MockLocationViewViewModel())
            }
        }
    }
}
#endif
