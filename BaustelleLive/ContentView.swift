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
    
    // MARK: Data Variables
    var callout: String? {
        apiData?.callout
    }
    var li16: URL {
        URL(string: apiData?.li16.imageUrl ?? "https://latest.baustelle.live/li16.jpg")!
    }
    var li16date: String {
        apiData?.li16.human ?? "Datum lädt …"
    }
    var li16Error: BaustelleLiveApiError? {
        apiData?.li16.error
    }
    var li27: URL {
        URL(string: apiData?.li27.imageUrl ?? "https://latest.baustelle.live/li27.jpg")!
    }
    var li27date: String {
        apiData?.li27.human ?? "Datum lädt …"
    }
    var li27Error: BaustelleLiveApiError? {
        apiData?.li27.error
    }
    
    
    @State var isLoading = true
    @State var apiError = false
    
    @State var apiData: BaustelleLiveApi?
    
    // MARK: Settings Variables
    @State var showSettingsView = false
    
    // MARK: Data Refresh Variables
    @AppStorage("shouldReload") var shouldReload: Bool = false
    var reloadTimeInSeconds: TimeInterval {
        apiData?.live == true ? 10.0 : 120.0
    }
    @State var reloadTimer: Timer?
    
    @Environment(\.scenePhase) var scenePhase
    
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
                    
                    if (li27Error != nil || li16Error != nil) {
                        Text("Zur Zeit gibt es Probleme, es wird bereits daran gearbeitet.")
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
                        
                        if (li16Error == nil) {
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
                                        // FIXME: move navigation link outside, to prevent reloading, when image reloads
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
                        } else {
                            switch li16Error?.type {
                            case .cameraoffline:
                                Text("Die Kamera Lindengasse 16 ist zur Zeit offline.")
                                    .listRowSeparator(.hidden)
                            default:
                                Text("Zur Zeit gibt es Probleme mit der Kamera Lindengasse 16")
                                    .listRowSeparator(.hidden)
                            }
                        }
                        
                    }
                    .listSectionSeparator(.hidden)
                    
                    Section {
                        Text("Lindengasse 27")
                            .font(.title)
                        
                        if (li27Error == nil) {
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
                                        // FIXME: move navigation link outside, to prevent reloading, when image reloads
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
                        } else {
                            switch li27Error?.type {
                            case .cameraoffline:
                                Text("Die Kamera Lindengasse 27 ist zur Zeit offline.")
                                    .listRowSeparator(.hidden)
                            default:
                                Text("Zur Zeit gibt es Probleme mit der Kamera Lindengasse 27")
                                    .listRowSeparator(.hidden)
                            }
                        }
                        
                    }
                    .listSectionSeparator(.hidden)
                    
                    
                } else if (apiError) {
                    Text("Es gibt Probleme mit den Daten. Probiere es später nochmal 🤕")
                        .listRowSeparator(.hidden)
                } else {
                    HStack {
                        Text("Daten werden geladen")
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                    }
                }
            }
            .refreshable {
                await loadData()
            }
            .navigationTitle("baustelle.live")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSettingsView = true
                    }) {
                        Label("Einstellungen", systemImage: "gear")
                    }.sheet(isPresented: $showSettingsView) {
                        SettingsView()
                    }
                }
            }
            
        }
        .task {
            await loadData()
        }
        .onAppear {
            print("onAppear")
        }
        .onChange(of: scenePhase) { newPhase in
            // https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-when-your-app-moves-to-the-background-or-foreground-with-scenephase
            if newPhase == .active {
                print("Active")
                // is in foreground, (re)start automatic updating and immediately fetch update
                
                // https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer
                // https://developer.apple.com/documentation/foundation/userdefaults
                // https://www.hackingwithswift.com/books/ios-swiftui/storing-user-settings-with-userdefaults
                
                if shouldReload {
                    reloadTimer = Timer.scheduledTimer(withTimeInterval: reloadTimeInSeconds, repeats: true) { _ in
                        Task {
                            await self.loadData()
                        }
                    }
                }
            } else if newPhase == .background {
                print("Background")
                
                reloadTimer?.invalidate()
                // is in background, stop outomatic updating
            }
        }
    }
    
    func loadData() async {
        self.isLoading = true
        self.apiError = false
        
        do {
            let (jsonData, _) = try await URLSession.shared.data(from: baustelleLiveApi)
            self.apiData = try JSONDecoder().decode(BaustelleLiveApi.self, from: jsonData)
            self.isLoading = false
            self.apiError = false
        } catch {
            self.apiData = nil
            self.isLoading = false
            self.apiError = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPod touch (7th generation)")
    }
}
