//
//  CompassView.swift
//  07
//
//  Created by Gwangyu Lee on 8/19/25.
//


import SwiftUI
import AudioKit

struct CompassView: View {
    @ObservedObject var sensorManager: SensorManager
    
    @State private var frequency: Double = 220
    @State private var fmIndex: Double = 0
    @State private var noteOnOff: Bool = false
    @State private var selectedWave: String = "sine"
    
    // heading 변화 감지 후 noteOff 예약
    @State private var noteOffWorkItem: DispatchWorkItem?

    var body: some View {
        VStack {
            Text("Compass Heading")
            Text("\(sensorManager.heading, specifier: "%.2f")°")
                .onChange(of: sensorManager.heading) { oldValue, newValue in
                    sendOSCMessage(address: "/heading", value: sensorManager.heading)
                    fmIndex = sensorManager.heading
                    SynthManager.shared.updateFMIndex(fmIndex)
                    
                    print("Compass: oldValue: \(oldValue), newValue: \(newValue)")
                    
                    // heading 값이 바뀌면 noteOn
                    SynthManager.shared.noteOn(frequency: frequency)
                    noteOnOff = true
                    
                    // 기존 예약된 noteOff 취소
                    noteOffWorkItem?.cancel()
                    
                    // 0.5초 뒤 noteOff 예약
                    let workItem = DispatchWorkItem {
                        SynthManager.shared.noteOff()
                        noteOnOff = false
                        print("Compass: noteOff after 0.5s inactivity")
                    }
                    noteOffWorkItem = workItem
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
                }
        }
        .onAppear {
            setOSCClientIP()
            SynthManager.shared.updateFrequency(frequency: frequency)
            SynthManager.shared.selectedWave = selectedWave
            print("Compass: onAppear")
        }
        .onDisappear {
            // NavigationSplitView list로 나갈 때도 noteOff
            SynthManager.shared.noteOff()
            noteOnOff = false
            print("Compass: onDisappear -> noteOff")
        }
    }
}

#Preview {
    @Previewable @StateObject var sensorManager = SensorManager()
    
    CompassView(sensorManager: sensorManager)
}
