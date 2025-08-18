//
//  ContentView.swift
//  05-SwiftUI
//
//  Created by Gwangyu Lee on 8/18/25.
//

import SwiftUI

struct FirstView: View {
    
    // 아이폰 width 가져오기
    let screenWidth = UIScreen.main.bounds.width
    let offsetWidth: CGFloat = 100
    
    let myScreenWidth = UIScreen.main.bounds.width - 100 // offset
    
    var body: some View {
        
        // 여기서부터 세로로 쌓기
        VStack {
            
            // Title
            Text("Swift Sound 100")
                .font(.title)
                .fontWeight(.bold)
            
            // 여기서부터 그룹박스안에 집어넣기
            GroupBox{
                HStack {
                    Text("Position")
                    Spacer()
                    Text("Top")
                }
                
                HStack {
                    Text("Position")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Top")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(width: screenWidth - offsetWidth)
            } // 그룹박스 끝나로 컬러 설정
            .foregroundStyle(.red) // text
            .backgroundStyle(.blue.opacity(0.2)) // fill color
            
            Link("Swift Study GitHub",
                 destination: URL(string: "https://github.com/gwangyu-lee/2025-Swift-Sound-Creative-Coding-for-Computer-Musicians")!)
            .foregroundStyle(.red)
            
            // list 시작
            List {
                Text("SwiftUI")
                Link("Swift Study GitHub",
                     destination: URL(string: "https://github.com/gwangyu-lee/2025-Swift-Sound-Creative-Coding-for-Computer-Musicians")!)
                .foregroundStyle(.red)
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
            } // 리스트 끝

//            .listStyle(.plain)
            .background(Color.red.opacity(0.2))
            .scrollContentBackground(.hidden)

            .frame(height: 300)
            .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    FirstView()
}

