//
//  OSCSettingsView.swift
//  07
//
//  Created by Gwangyu Lee on 8/21/25.
//

import SwiftUI

public struct SettingsView: View {
    
    @State private var ipAddress: String = UserDefaults.standard.string(forKey: "ipAddress") ?? "127.0.0.1"
    @State private var port: String = UserDefaults.standard.string(forKey: "port") ?? "8800"
    
    @State private var selectedLanguage: String = "EN"
    @State private var languages = ["EN", "JP", "KR"]
    
    public var body: some View {
        
        List {
            Text("Language")
                .font(.title2)
                .bold()
                .listRowSeparator(.hidden)

            Picker("", selection: $selectedLanguage) {
                ForEach(languages, id: \.self) { newValue in
                    Text(newValue)
                }
            }
            .pickerStyle(.segmented)
            
            Text("OSC")
                .font(.title2)
                .bold()

            HStack {
                Text("IP Address")
                    .frame(width: 100, alignment: .leading)
                Spacer()
                TextField("127.0.0.1", text: $ipAddress)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 160, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
                    .onChange(of: ipAddress) { _, newValue in
                        UserDefaults.standard.set(newValue, forKey: "ipAddress")
                        setOSCClientIP()
                    }
            }
            .listRowSeparator(.hidden)
            HStack {
                Text("Port")
                    .frame(width: 100, alignment: .leading)
                Spacer()
                TextField("8800", text: $port)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 160, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
                    .onChange(of: port) { _, newValue in
                        UserDefaults.standard.set(newValue, forKey: "port")
                        setOSCClientIP()
                    }
            }
            
        }
        
    }
    
}

#Preview {
    SettingsView()
}
