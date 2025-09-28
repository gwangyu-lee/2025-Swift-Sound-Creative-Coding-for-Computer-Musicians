//
//  ContentView.swift
//  07
//
//  Created by Gwangyu Lee on 8/19/25.
//

import SwiftUI

struct MySplitView: View {
    
    @StateObject var sensorManager = SensorManager()
    @StateObject var sensorManagerTJ = SensorManagerTJ()
    
    @State private var selectedView: String? = "FM Synthesis"
    
    // 배열, 뷰 목록
    let views = ["FM Synthesis", "Cicadidae", "Annoying Kid", "Tissue", "Settings", "About"]
    
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
                case "FM Synthesis":
                    FMSynthesis()
                case "Cicadidae":
                    Cicadidae()
                case "Annoying Kid":
                    CharacterView(sensorManager: sensorManagerTJ)
                case "Tissue":
                    TissueContentView()
                case "Settings":
                    SettingsView()
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
