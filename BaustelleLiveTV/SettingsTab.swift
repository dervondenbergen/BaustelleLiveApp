//
//  SettingsTab.swift
//  BaustelleLiveTV
//
//  Created by Felix De Montis on 13.08.22.
//

import SwiftUI

struct SettingsTab: View {
    
    @AppStorage("shouldReload") var shouldReload = false
    
    let appVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")! as! String
    let appBundleVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")! as! String
    
    var body: some View {
        HStack {
            
            VStack(alignment: .center) {
                Spacer()
                AsyncImage(url: URL(string: "https://felix.dm/assets/images/avatar.jpg")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.green.opacity(0.3)
                }
                .aspectRatio(1 / 1, contentMode: .fit)
                .frame(maxWidth: 400)
                .cornerRadius(.infinity)
                
                Spacer()
                
                VStack(spacing: 10) {
                    
                    Text("Ein Projekt von")
                        .font(.system(size: 24))
                    
                    Text("Felix De Montis")
                        .bold()
                    
                    Text("@dervondenbergen")
                        .font(.system(size: 22))
                        .italic()
                    
                }
                
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: 600)
            
            VStack(spacing: 10) {
                
                Toggle("Bilder automatisch updaten", isOn: $shouldReload)
                Text("Wenn sich die App im Vordergrund befindet, werden zwischen 5 und 23 Uhr die Bilder alle 10 Sekunden neu geladen.")
                    .font(.body).foregroundColor(.secondary)
                    .padding()
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text("Version ")
                    Text("\(appVersion) (\(appBundleVersion))")
                        .foregroundColor(.secondary)
                }
                
            }
            .padding(.vertical)
        }
        .tabItem {
            Image(systemName: "gearshape")
            Text("Einstellungen")
        }
    }
}

struct SettingsTab_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTab()
    }
}
