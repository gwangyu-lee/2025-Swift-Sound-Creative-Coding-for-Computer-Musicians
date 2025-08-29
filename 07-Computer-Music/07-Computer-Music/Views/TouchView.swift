//
//  TouchView.swift
//  07
//
//  Created by Gwangyu Lee on 8/20/25.
//

import SwiftUI

struct TouchView: View {
    
    @State private var offsetHeight: Double = 50
    
    @State private var dragX: Double = 0
    @State private var dragY: Double = 0
    
    @State private var tapX: Double = 0
    @State private var tapY: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Drag
                Rectangle()
                    .fill(Color.red)
                    .frame(height: geometry.size.height/2 - offsetHeight)
                    .cornerRadius(10)
                    .contentShape(Rectangle()) // hit test area 명확화
                    .gesture(
                        DragGesture()
                            .onChanged { event in
                                dragX = event.location.x
                                dragY = event.location.y
                                sendOSCMessage(address: "/dragX", value: Float(dragX))
                                sendOSCMessage(address: "/dragY", value: Float(dragY))
                                
                                print("Red: Drag: x:\(event.location.x), y:\(event.location.y)")
                            }
                            .onEnded { event in
                                print("Red: Drag: End x:\(event.location.x), y:\(event.location.y)")
                            }
                    )
                    .padding(.bottom)
                
                Text("Drag: x:\(dragX, specifier: "%.2f"), y:\(dragY, specifier: "%.2f")")
                Text("Tap: x:\(tapX, specifier: "%.2f"), y:\(tapY, specifier: "%.2f")")
                
                // Tap
                Rectangle()
                    .fill(Color.blue)
                    .frame(height: geometry.size.height/2 - offsetHeight)
                    .cornerRadius(10)
                    .contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { event in
                                tapX = event.location.x
                                tapY = event.location.y
                                sendOSCMessage(address: "/tapX", value: Float(tapX))
                                sendOSCMessage(address: "/tapY", value: Float(tapY))
                                print("Blue: Tap: x:\(event.location.x), y:\(event.location.y)")
                            }
                    )
                    .padding(.top)
            }
            .padding()
        }
        .onAppear {
            setOSCClientIP()
        }
    }

}


#Preview {
    TouchView()
}
