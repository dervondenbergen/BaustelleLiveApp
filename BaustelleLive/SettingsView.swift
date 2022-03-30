//
//  SettingsView.swift
//  BaustelleLive
//
//  Created by Felix De Montis on 06.03.22.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("shouldReload") var shouldReload = false
    
    var body: some View {
        NavigationView {
            List {
                Section(footer: Text("Wenn sich die App im Vordergrund befindet, werden zwischen 5 und 23 Uhr die Bilder alle 10 Sekunden neu geladen.")) {
                    Toggle(isOn: $shouldReload) {
                        Text("Bilder automatisch updaten")
                    }
                }
                
                HStack {
                    AsyncImage(url: URL(string: "https://felix.dm/assets/images/avatar.jpg")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.green.opacity(0.3)
                    }
                    .aspectRatio(1 / 1, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(100)
                    
                    VStack(spacing: 6) {
                        Spacer()
                        Text("Ein Projekt von")
                            .font(.system(size: 15))
                        
                        Text("Felix De Montis")
                            .bold()
                        
                        Text("@dervondenbergen")
                            .font(.system(size: 12))
                            .italic()
                            
                        Spacer()
                    }
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity)
                }
                .listRowInsets(.zero)
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Einstellungen")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                      Text("Schließen")
                    })
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
