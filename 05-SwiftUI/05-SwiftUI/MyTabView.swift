//
//  MyTabView.swift
//  05-SwiftUI
//
//  Created by Gwangyu Lee on 8/18/25.
//

import SwiftUI

struct MyTabView: View {
    var body: some View {
        TabView {
            FirstView()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("First")
                }
            
            SecondView()
                .tabItem {
                    Image(systemName: "music.microphone")
                    Text("Second")
                }
            ThirdView()
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Third")
                }
        }
    }
}

#Preview {
    MyTabView()
}
