//
//  ContentView.swift
//  04-SwiftUI
//
//  Created by Gwangyu Lee on 8/12/25.
//

import SwiftUI

struct ContentView: View {
    // MARK: Variables
    
    @State private var txtUsername = ""
    @State private var count = 10
    
    // MARK: Body
    var body: some View {
        VStack {
            
            // Title
            Text("2025-Swift-Sound-Creative-Coding-for-Computer-Musicians")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.green)
            
            // Image
            Image(systemName: "music.note")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            // Text
            Text("Hello, Gwangyu!")
            
            // TextField
            TextField("Enter your name", text: $txtUsername)
                .onChange(of: txtUsername, initial: false, { oldValue, newValue in
                    print("old text: \(oldValue), new text: \(newValue)")
                })
            
            // Spacer()
            Divider()
            
            HStack {
                // 이 버튼을 누를때마다
                Button(action: {
                    // Statements
                    print("Button Clicked!")
                    count += 1
                }) {
                    // Shape
                    Text("Add one")
                }
                // 이 버튼을 누를때마다
                Button(action: {
                    // Statements
                    print("Button Clicked!")
                    count += 2
                }) {
                    // Shape
                    Text("Add two")
                }
            }

            // 숫자 증가 1, 2, 3...
            Text("\(count)")
            
        }
        .padding()
    }
    
    // MARK: Function
    
}

#Preview {
    ContentView()
}
