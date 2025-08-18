//
//  SecondView.swift
//  05-SwiftUI
//
//  Created by Gwangyu Lee on 8/18/25.
//

import SwiftUI

struct SecondView: View {
    
    // state 안에서
    // published 밖에서
    
    @State private var frequency: Double = 440
    @State private var fmIndex: Double = 0
    @State private var noteOnOff: Bool = false
    
    // Picker
    @State private var selectedWave: String = "sine"
    @State private var wave = ["sine", "square", "sawtooth", "triangle", "noise"]
    
    var body: some View {
        
        VStack {
            Text("FM Synthesis")
                .font(.title)
                .fontWeight(.bold)
            
            // Frequency
            GroupBox{
                Text("Frequency: \(Int(frequency))")
                Slider(value: $frequency, in: 440...880)
                    .onChange(of: frequency) { oldValue, newValue in
                        print("Slider: Frequency: oldValue: \(oldValue), newValue: \(newValue)")
                    }
            }
            
            // FM Index
            GroupBox{
                Text("FM Index: \(String(format: "%.2f", fmIndex))")
                Slider(value: $fmIndex, in: 0...10)
                    .onChange(of: fmIndex) { oldValue, newValue in
                        print("Slider: FM Index: oldValue: \(oldValue), newValue: \(newValue)")
                    }
            }
            
            // Wave
            Picker("", selection: $selectedWave) {
                ForEach(wave, id: \.self) { newValue in
                    Text(newValue)
                }
                .onChange(of: selectedWave) { _, newValue in
                    print("Picker: Wave: \(newValue)")
                }
            }
            .pickerStyle(.segmented)
            
            // Note On Off
            Toggle("Note OnOff", isOn: $noteOnOff)
                .toggleStyle(SwitchToggleStyle(tint:.red))
                .onChange(of: noteOnOff) { _, newValue in
                    print("Toggle: Note OnOff: \(newValue)")
                }
            
        }
        .padding()
        
    }
}

#Preview {
    SecondView()
}
