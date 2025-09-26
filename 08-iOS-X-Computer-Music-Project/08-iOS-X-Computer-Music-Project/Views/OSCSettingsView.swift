//
//  OSCSettingsView.swift
//  07
//
//  Created by Gwangyu Lee on 8/21/25.
//

import SwiftUI

public struct OSCSettingsView: View {
    
    @State private var ipAddress: String = UserDefaults.standard.string(forKey: "ipAddress") ?? "127.0.0.1"
    @State private var port: String = UserDefaults.standard.string(forKey: "port") ?? "8800"
    
    public var body: some View {
        VStack {
            
            Text("OSC Settings")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            GroupBox {
                VStack {
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
                        //                        .frame(width: 450, alignment: .trailing)
                    }
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
                        //                        .frame(width: 450, alignment: .trailing)
                    }
                }
            }
            Spacer()
            
        }
        .padding()
        
    }
        
}

#Preview {
    OSCSettingsView()
}
