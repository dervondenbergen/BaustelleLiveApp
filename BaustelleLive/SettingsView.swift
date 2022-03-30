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
                Toggle(isOn: $shouldReload) {
                    Text("Bilder automatisch updaten")
                }
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
