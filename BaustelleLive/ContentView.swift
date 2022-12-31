//
//  ContentView.swift
//  BaustelleLive
//
//  Created by Felix De Montis on 17.08.21.
//

import SwiftUI
import SDWebImage

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
    @State var li16Image: LocationImage?
    @State var li16ImageError: Bool = false
    @State var li16ImageProgress: Int?
    @State var li16LocationViewOpen: Bool = false
    
    var li27: URL {
        URL(string: apiData?.li27.imageUrl ?? "https://latest.baustelle.live/li27.jpg")!
    }
    var li27date: String {
        apiData?.li27.human ?? "Datum lädt …"
    }
    var li27Error: BaustelleLiveApiError? {
        apiData?.li27.error
    }
    @State var li27Image: LocationImage?
    @State var li27ImageError: Bool = false
    @State var li27ImageProgress: Int?
    @State var li27LocationViewOpen: Bool = false
    
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
    
    @State var showReloadInfo: Bool = false
    
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
                                if li16ImageProgress != nil {
                                    VStack {
                                        Spacer()
                                        Text("Lädt… \(li16ImageProgress!)%")
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .aspectRatio(4 / 3, contentMode: .fit)
                                    .background(Color.gray)
                                }
                                
                                if li16ImageError {
                                    VStack {
                                        Spacer()
                                        Text("Fehler beim herunterladen vom Bild")
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .aspectRatio(4 / 3, contentMode: .fit)
                                    .background(Color.gray)
                                }
                                
                                if li16Image != nil {
                                    Button(action: {
                                        li16LocationViewOpen.toggle()
                                    }) {
                                        Image(uiImage: li16Image!.uiImage)
                                            .resizable()
                                            .aspectRatio(4 / 3, contentMode: .fit)
                                    }
                                    
                                    NavigationLink(destination: LocationView(
                                        location: "Lindengasse 16",
                                        image: li16Image!,
                                        id: "li16",
                                        date: li16date,
                                        videos: apiData!.li16.videos
                                    ), isActive: $li16LocationViewOpen) {
                                        EmptyView()
                                    }
                                    .opacity(0)
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
                                if li27ImageProgress != nil {
                                    VStack {
                                        Spacer()
                                        Text("Lädt… \(li27ImageProgress!)%")
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .aspectRatio(16 / 9, contentMode: .fit)
                                    .background(Color.gray)
                                }
                                
                                if li27ImageError {
                                    VStack {
                                        Spacer()
                                        Text("Fehler beim herunterladen vom Bild")
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .aspectRatio(16 / 9, contentMode: .fit)
                                    .background(Color.gray)
                                }
                                
                                if li27Image != nil {
                                    Button(action: {
                                        li27LocationViewOpen.toggle()
                                    }) {
                                        Image(uiImage: li27Image!.uiImage)
                                            .resizable()
                                            .aspectRatio(16 / 9, contentMode: .fit)
                                    }
                                    
                                    NavigationLink(destination: LocationView(
                                        location: "Lindengasse 27",
                                        image: li27Image!,
                                        id: "li27",
                                        date: li27date,
                                        videos: apiData!.li27.videos
                                    ), isActive: $li27LocationViewOpen) {
                                        EmptyView()
                                    }
                                    .opacity(0)
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if shouldReload {
                        Group {
                            if apiData?.live == true {
                                Text("\(Image(systemName: "circle.fill")) Live")
                                    .foregroundColor(.red)
                            } else {
                                Text("\(Image(systemName: "circle")) Live")
                                    .foregroundColor(.gray)
                            }
                        }
                        .onTapGesture {
                            showReloadInfo.toggle()
                        }
                        .alert("Kameras sind zur Zeit \(apiData?.live == true ? "Live" : "nicht Live").", isPresented: $showReloadInfo, actions: {})
                    }
                }
            
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSettingsView = true
                    }) {
                        Label("Einstellungen", systemImage: "gearshape")
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
            if shouldReload {
                print("onAppear shouldReload")
                setReloadTimer()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            // https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-when-your-app-moves-to-the-background-or-foreground-with-scenephase
            if newPhase == .active {
                print("scenePase active")
                // is in foreground, (re)start automatic updating and immediately fetch update
                
                // https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer
                // https://developer.apple.com/documentation/foundation/userdefaults
                // https://www.hackingwithswift.com/books/ios-swiftui/storing-user-settings-with-userdefaults
                
                if shouldReload {
                    setReloadTimer()
                }
            } else if newPhase == .background {
                print("scenePase background")
                
                removeReloadTimer()
                // is in background, stop outomatic updating
            }
        }
        .onChange(of: shouldReload) { newShouldReload in
            print("shouldReload \(newShouldReload)")
            if newShouldReload {
                setReloadTimer()
            } else {
                removeReloadTimer()
            }
        }
    }
    
    func setReloadTimer() {
        reloadTimer = Timer.scheduledTimer(withTimeInterval: reloadTimeInSeconds, repeats: true) { _ in
            Task {
                await self.loadData()
            }
        }
    }
    
    func removeReloadTimer() {
        reloadTimer?.invalidate()
    }
    
    func loadData() async {
        self.isLoading = true
        self.apiError = false
        
        do {
            let (jsonData, _) = try await URLSession.shared.data(from: baustelleLiveApi)
            self.apiData = try JSONDecoder().decode(BaustelleLiveApi.self, from: jsonData)
            self.isLoading = false
            self.apiError = false
            
            loadImages()
        } catch {
            self.apiData = nil
            self.isLoading = false
            self.apiError = true
        }
    }
    
    func loadImages() {
        if li16Error == nil {
            SDWebImageManager.shared.loadImage(
                with: li16,
                options: [.queryMemoryData],
                progress: { receivedSize, expectedSize, url in
                    //Progress tracking code
                    li16ImageProgress = expectedSize / max(1, receivedSize)
                },
                completed: { image, data, error, cacheType, finished, url in
                    guard error == nil else {
                        li16ImageError = true
                        li16ImageProgress = nil
                        li16Image = nil
                        
                        return
                    }
                    
                    li16ImageError = false
                    li16ImageProgress = nil
                    
                    if let data = data {
                        li16Image = LocationImage(uiImage: image!, rawImageData: data)
                    }
                }
            )
        }
        
        if li27Error == nil {
            SDWebImageManager.shared.loadImage(
                with: li27,
                options: [.queryMemoryData],
                progress: { receivedSize, expectedSize, url in
                    //Progress tracking code
                    li27ImageProgress = expectedSize / max(1, receivedSize)
                },
                completed: { image, data, error, cacheType, finished, url in
                    guard error == nil else {
                        li27ImageError = true
                        li27ImageProgress = nil
                        li27Image = nil
                        
                        return
                    }
                    
                    li27ImageError = false
                    li27ImageProgress = nil
                    
                    if let data = data {
                        li27Image = LocationImage(uiImage: image!, rawImageData: data)
                    }
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPod touch (7th generation)")
    }
}
