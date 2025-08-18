//
//  MyListView.swift
//  05-SwiftUI
//
//  Created by Gwangyu Lee on 8/18/25.
//

import SwiftUI

struct MySplitView: View {
    
    // 처음 뷰
    @State private var selectedView: String? = "default"
    
    // 배열, 뷰 목록
    let views = ["FirstView", "SecondView", "ThirdView"]
    
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
                case "FirstView":
                    FirstView()
                case "SecondView":
                    SecondView()
                case "ThirdView":
                    ThirdView()
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
