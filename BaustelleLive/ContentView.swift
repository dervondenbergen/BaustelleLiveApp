//
//  ContentView.swift
//  BaustelleLive
//
//  Created by Felix De Montis on 17.08.21.
//

import SwiftUI
import URLImage

struct ContentView: View {
    var baustelleLiveApi = URL(string: "https://latest.baustelle.live/api.json")!
    
    var callout: String? {
        apiData?.callout
    }
    var li16: URL {
        URL(string: apiData?.li16.imageUrl ?? "https://latest.baustelle.live/li16.jpg")!
    }
    var li16date: String {
        apiData?.li16.human ?? "Datum lädt …"
    }
    var li27: URL {
        URL(string: apiData?.li27.imageUrl ?? "https://latest.baustelle.live/li27.jpg")!
    }
    var li27date: String {
        apiData?.li27.human ?? "Datum lädt …"
    }
    
    
    @State var isLoading = false
    
    @State var apiData: BaustelleLiveApi?
    
    var body: some View {
        NavigationView {
            List {
                if (apiData != nil) {
                    if (callout != nil) {
                        Text(callout!)
                            .fontWeight(.regular)
                            .foregroundColor(Color.black)
                            .padding(10)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .background(Color("CalloutBackground"))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("CalloutBorder"), lineWidth: 4)
                            )
                            .listRowInsets(.init(top: 2, leading: 2, bottom: 2, trailing: 2))
                            .listRowSeparator(.hidden)
                        
                    }
                    
                    Section {
                        
                        Text("Lindengasse 16")
                            .font(.title)
                            .listRowSeparator(.hidden)
                        
                        ZStack {
                            
                            URLImage(li16) {
                                // This view is displayed before download starts
                                EmptyView()
                            } inProgress: { progress in
                                // Display progress
                                VStack {
                                    Spacer()
                                    Text("Lädt...")
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .aspectRatio(4 / 3, contentMode: .fit)
                                .background(Color.gray)
                            } failure: { error, retry in
                                // Display error and retry button
                                VStack {
                                    Text(error.localizedDescription)
                                    Button("Retry", action: {
                                        retry()
                                    })
                                }
                            } content: { image, info in
                                ZStack {
                                    NavigationLink(destination: LocationView(
                                        location: "Lindengasse 16",
                                        image: image,
                                        id: "li16",
                                        rawImage: info.cgImage,
                                        date: li16date,
                                        videos: apiData!.li16.videos
                                    )) {}
                                    
                                    image
                                        .resizable()
                                        .aspectRatio(4 / 3, contentMode: .fit)
                                }
                            }
                            
                        }
                        .listRowInsets(.init())
                        .listRowSeparator(.hidden)
                        
                        
                        Text(li16date)
                            .listRowSeparator(.hidden)
                        
                    }
                    .listSectionSeparator(.hidden)
                    
                    Section {
                        Text("Lindengasse 27")
                            .font(.title)
                        
                        ZStack {
                            URLImage(li27) {
                                // This view is displayed before download starts
                                EmptyView()
                            } inProgress: { progress in
                                // Display progress
                                VStack {
                                    Spacer()
                                    Text("Lädt...")
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .aspectRatio(16 / 9, contentMode: .fit)
                                .background(Color.gray)
                            } failure: { error, retry in
                                // Display error and retry button
                                VStack {
                                    Text(error.localizedDescription)
                                    Button("Retry", action: {
                                        retry()
                                    })
                                }
                            } content: { image, info in
                                ZStack {
                                    NavigationLink(destination: LocationView(
                                        location: "Lindengasse 27",
                                        image: image,
                                        id: "li27",
                                        rawImage: info.cgImage,
                                        date: li27date,
                                        videos: apiData!.li27.videos
                                    )) {}
                                    
                                    image
                                        .resizable()
                                        .aspectRatio(16 / 9, contentMode: .fit)
                                }
                            }
                        }
                        .listRowInsets(.init())
                        .listRowSeparator(.hidden)
                        
                        
                        Text(li27date)
                            .listRowSeparator(.hidden)
                        
                    }
                    .listSectionSeparator(.hidden)
                    
                    
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                }
            }
            .refreshable {
                await loadData()
            }
            .navigationTitle("baustelle.live")
            .navigationBarTitle("test")
            
        }
        .onAppear {
            Task {
                await loadData()
            }
        }
        
    }
    
    func loadData() async {
        self.isLoading = true
        
        do {
            let (jsonData, _) = try await URLSession.shared.data(from: baustelleLiveApi)
            self.apiData = try JSONDecoder().decode(BaustelleLiveApi.self, from: jsonData)
            self.isLoading = false
        } catch {
            self.apiData = nil
            self.isLoading = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPod touch (7th generation)")
    }
}
