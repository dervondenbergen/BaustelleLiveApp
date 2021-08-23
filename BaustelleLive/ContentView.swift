//
//  ContentView.swift
//  BaustelleLive
//
//  Created by Felix De Montis on 17.08.21.
//

import SwiftUI
import URLImage
import Just

struct ContentView: View {
    var li16 = URL(string: "https://latest.baustelle.live/li16.jpg");
    var li27 = URL(string: "https://latest.baustelle.live/li27.jpg");
    
    var li16txt = URL(string: "https://latest.baustelle.live/li16.txt");
    var li27txt = URL(string: "https://latest.baustelle.live/li27.txt");
    
    @State var li16date = "Datum lädt..."
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Lindengasse 16")
                        .font(.title)
                        .padding(.horizontal, 16.0)
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    
                    
                    
                    URLImage(li16!) {
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
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
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
                    } content: { image in
                        // Downloaded image
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    Text(li16date)
                        .padding(.horizontal, 16.0)
                        .padding(/*@START_MENU_TOKEN@*/.bottom, 10.0/*@END_MENU_TOKEN@*/)
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    
                    Text("Lindengasse 27")
                        .font(.title)
                        .padding(.horizontal, 16.0)
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    
                    URLImage(li27!) {
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
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
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
                    } content: { image in
                        // Downloaded image
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
            }
            .padding(.top, 1)
            .navigationTitle("Letzte Updates")
        }
        .onAppear {
            //loadDate(camera: "16")
            print("hallo")
        }
    }
    
    func loadDate(camera: String) {
        print("Camera \(camera)")
        self.li16date = camera
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
