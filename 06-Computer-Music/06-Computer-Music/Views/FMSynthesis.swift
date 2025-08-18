//
//  ContentView.swift
//  06-Computer-Music
//
//  Created by Gwangyu Lee on 8/18/25.
//

import SwiftUI

struct FMSynthesis: View {
    
    // state 안에서
    // published 밖에서
    
    @State private var frequency: Double = 440
    @State private var fmIndex: Double = 0
    @State private var noteOnOff: Bool = false
    
    // Picker
    @State private var selectedWave: String = "sine"
    @State private var wave = ["sine", "sawtooth", "triangle", "rectangle", "noise"]
    
    var body: some View {
        
        VStack {
            Text("FM Synthesis")
                .font(.title)
                .fontWeight(.bold)
            
            // Frequency
            GroupBox{
                Text("Frequency: \(Int(frequency)) Hz")
                Slider(value: $frequency, in: 440...880)
                    .onChange(of: frequency) { _, newValue in
                        SynthManager.shared.updateFrequency(frequency: newValue)
                        print("Slider: Frequency: \(newValue)")
                    }
            }
            
            // FM Index
            GroupBox{
                Text("FM Index: \(String(format: "%.2f", fmIndex))")
                Slider(value: $fmIndex, in: 0...10)
                    .onChange(of: fmIndex) { _, newValue in
                        SynthManager.shared.updateFMIndex(newValue)
                        print("Slider: FM Index: \(newValue)")
                    }
            }
            
            // Wave Picker
            Picker("", selection: $selectedWave) {
                ForEach(wave, id: \.self) { waveName in
                    Text(waveName)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedWave) { _, newValue in
                SynthManager.shared.selectedWave = newValue
                print("Picker: Waveform: \(newValue)")
            }
            
            // Note On Off
            Toggle("Note On/Off", isOn: $noteOnOff)
                .toggleStyle(SwitchToggleStyle(tint:.red))
                .onChange(of: noteOnOff) { _, newValue in
                    if newValue {
                        SynthManager.shared.noteOn(frequency: frequency)
                        print("Toggle: Note On")
                    } else {
                        SynthManager.shared.noteOff()
                        print("Toggle: Note Off")
                    }
                }
            
        }
        .padding()
        .onDisappear {
            // View가 사라지면
            // noteOnOff가 true이면, 소리가 나고 있으면,
            if noteOnOff {
                // noteOnOff는 false
                noteOnOff = false
                // audio도 off
                SynthManager.shared.noteOff()
                print("View disappeared: Note Off")
            }
        }
    }
}

#Preview {
    FMSynthesis()
}
