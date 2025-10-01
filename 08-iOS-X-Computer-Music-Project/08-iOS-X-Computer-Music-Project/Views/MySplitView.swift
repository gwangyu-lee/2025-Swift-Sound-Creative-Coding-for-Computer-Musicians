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
    
    @State private var selectedView: String? = "What is FM Synthesis?"
    
    // 배열, 뷰 목록
    let views = ["What is FM Synthesis?", "Cicada", "Annoying Kid", "Tissue", "Saber", "About"]
    
    var body: some View {
        NavigationSplitView {
            List(
                views,
                id: \.self,
                selection: $selectedView
            ) {
                view in Text(view)
            }
            .navigationTitle("FM Playground")
        } detail: {
            if let selectedView = selectedView {
                switch selectedView {
                case "What is FM Synthesis?":
                    FMSynthesis()
                case "Cicada":
                    Cicadidae()
                case "Annoying Kid":
                    CharacterView(sensorManager: sensorManagerTJ)
                case "Tissue":
                    TissueContentView()
                case "Saber":
                    SaberView()
//                case "Settings":
//                    SettingsView()
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
