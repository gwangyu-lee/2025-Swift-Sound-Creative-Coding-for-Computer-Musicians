//
//  ContentView.swift
//  07
//
//  Created by Gwangyu Lee on 8/19/25.
//

import SwiftUI

struct MySplitView: View {
    
    @StateObject var sensorManager = SensorManager()
    
    @State private var selectedView: String? = "default"
    
    // 배열, 뷰 목록
    let views = ["AccelView", "AngleView", "CompassView", "GyroView", "TouchView", "OSCSettingsView", "About"]
    
    var body: some View {
        NavigationSplitView {
            List(
                views,
                id: \.self,
                selection: $selectedView
            ) {
                view in Text(view)
            }
            .navigationTitle("Swift Study")
        } detail: {
            if let selectedView = selectedView {
                switch selectedView {
                case "AccelView":
                    AccelView(sensorManager: sensorManager)
                case "AngleView":
                    AngleView(sensorManager: sensorManager)
                case "CompassView":
                    CompassView(sensorManager: sensorManager)
                case "GyroView":
                    GyroView(sensorManager: sensorManager)
                case "TouchView":
                    TouchView()
                case "OSCSettingsView":
                    OSCSettingsView()
                case "About":
                    About()
                default:
                    Text("Welcome")
                }
            }
        }
    }
}

#Preview {
    MySplitView()
}
