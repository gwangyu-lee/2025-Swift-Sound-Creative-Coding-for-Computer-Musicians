//
//  ContentView.swift
//  06-Computer-Music
//
//  Created by Gwangyu Lee on 8/18/25.
//
//
//  ContentView.swift
//  06-Computer-Music
//
//  Created by Gwangyu Lee on 8/18/25.
//

import SwiftUI

struct FMSynthesis: View {
    
    @State private var frequency: Double = 440
    @State private var modFrequency: Double = 0.0
    @State private var modFrequencyNorm: Double = 0.0
    @State private var fmIndex: Double = 1
    @State private var noteOnOff: Bool = false
    
    @State private var selectedWave: String = "sine"
    @State private var wave = ["sine", "sawtooth", "triangle", "rectangle"]
    
    // Log mapping
    @State private var modFMinPositive: Double = 2.0
    @State private var modFMax: Double = 200.0
    
    var body: some View {
        
        Text("What is FM Synthesis?")
            .font(.largeTitle)
            .fontWeight(.bold)

        List {
            HStack() {
                VStack() {
                    Text("Carrier · 8 Hz")
                    //                        .font(.headline)
                    SineOscilloscopeView(demoFrequency: 8.0, demoTimeWindow: 1.0, demoSamples: 600)
                        .frame(height: 120)
                }
                
                VStack() {
                    Text("Modulator · 1 Hz")
                    //                        .font(.headline)
                    SineOscilloscopeView(demoFrequency: 1.0, demoTimeWindow: 2.0, demoSamples: 600)
                        .frame(height: 120)
                }
            }
            .listRowSeparator(.hidden)
            
            // FM synthesis 결과
            VStack() {
                Text("FM Result (8Hz ± 4Hz)")
                //                    .font(.headline)
                FMOscilloscopeView()
                    .frame(height: 120)
            }
            .listRowSeparator(.hidden)
            
//            Divider()
            
            Text("Try it!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                
            
            Text("Carrier Frequency: \(Int(frequency)) Hz")
                .listRowSeparator(.hidden)
            Slider(value: $frequency, in: 440...880)
                .onChange(of: frequency) { _, newValue in
                    SynthManager.shared.updateFrequency(frequency: newValue)
                    print("Slider: Frequency: \(newValue)")
                }
            
            Text("Modulator Frequency: \(String(format: "%.2f", modFrequency)) Hz")
                .listRowSeparator(.hidden)
            Slider(value: $modFrequencyNorm, in: 0...1)
                .onAppear {
                    // Sync normalized value with current frequency
                    modFrequencyNorm = invLogMap(modFrequency)
                    SynthManager.shared.updateModulatorFrequency(modFrequency)
                }
                .onChange(of: modFrequencyNorm) { _, newNorm in
                    let actual = logMap(newNorm)
                    modFrequency = actual
                    SynthManager.shared.updateModulatorFrequency(actual)
                    print("Slider (Log): Modulator Frequency: \(String(format: "%.3f", actual)) Hz")
                }
            
            Text("Index: \(String(format: "%.2f", fmIndex)) (Depth: ± \(String(format: "%.2f", modFrequency * fmIndex)) Hz)")
                .listRowSeparator(.hidden)
            Slider(value: $fmIndex, in: 1...10)
                .onAppear {
                    SynthManager.shared.updateFMIndex(fmIndex)
                }
                .onChange(of: fmIndex) { _, newValue in
                    SynthManager.shared.updateFMIndex(newValue)
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
        .listStyle(.plain)
        .padding()
        .onDisappear {
            if noteOnOff {
                noteOnOff = false
                SynthManager.shared.noteOff()
                print("View disappeared: Note Off")
            }
        }
    }
    
    private func logMap(_ norm: Double) -> Double {
        let clampedNorm = min(max(norm, 0), 1)
        if clampedNorm == 0 { return 0 }
        let ratio = 1.0 + (modFMax / modFMinPositive)
        return modFMinPositive * (pow(ratio, clampedNorm) - 1.0)
    }
    
    private func invLogMap(_ value: Double) -> Double {
        let clampedVal = min(max(value, 0), modFMax)
        if clampedVal == 0 { return 0 }
        let ratio = 1.0 + (modFMax / modFMinPositive)
        return log(1.0 + clampedVal / modFMinPositive) / log(ratio)
    }
}


struct FMOscilloscopeView: View {
    var carrierFrequency: Double = 8.0
    var modulatorFrequency: Double = 1.0
    var fmIndex: Double = 6.0
    var demoTimeWindow: Double = 2.0
    var demoSamples: Int = 1200
    var demoAmplitude: Double = 0.8
    
    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation) { ctx in
                let t = ctx.date.timeIntervalSinceReferenceDate
                let w = Double(geo.size.width)
                let h = Double(geo.size.height)
                let centerY = h / 2.0
                let amp = (h / 2.0) * demoAmplitude
                
                
                let deviation = fmIndex * modulatorFrequency
                
                let path = Path { p in
                    for i in 0..<demoSamples {
                        let x = Double(i) / Double(demoSamples - 1)
                        let sampleTime = t - (1.0 - x) * demoTimeWindow
                        
                        let modulatorPhase = 2.0 * .pi * modulatorFrequency * sampleTime
                        
                        let carrierPhase = 2.0 * .pi * carrierFrequency * sampleTime
                        let modulationPhase = (deviation / modulatorFrequency) * sin(modulatorPhase)
                        let totalPhase = carrierPhase + modulationPhase
                        
                        let value = sin(totalPhase)
                        
                        let px = x * w
                        let py = centerY - value * amp
                        
                        if i == 0 {
                            p.move(to: CGPoint(x: px, y: py))
                        } else {
                            p.addLine(to: CGPoint(x: px, y: py))
                        }
                    }
                }
                
                ZStack {
                    GridBackgroundView()
                        .frame(width: geo.size.width, height: geo.size.height)
                    
                    path
                        .strokedPath(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 1)
                        .foregroundColor(.blue)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct SineOscilloscopeView: View {
    var demoFrequency: Double
    var demoTimeWindow: Double = 1.0
    var demoSamples: Int = 512
    var demoAmplitude: Double = 0.9
    
    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation) { ctx in
                let t = ctx.date.timeIntervalSinceReferenceDate
                let w = Double(geo.size.width)
                let h = Double(geo.size.height)
                let centerY = h / 2.0
                let amp = (h / 2.0) * demoAmplitude
                
                let path = Path { p in
                    for i in 0..<demoSamples {
                        let x = Double(i) / Double(demoSamples - 1)
                        let sampleTime = t - (1.0 - x) * demoTimeWindow
                        
                        let value = sin(2.0 * .pi * demoFrequency * sampleTime)
                        
                        let px = x * w
                        let py = centerY - value * amp
                        
                        if i == 0 {
                            p.move(to: CGPoint(x: px, y: py))
                        } else {
                            p.addLine(to: CGPoint(x: px, y: py))
                        }
                    }
                }
                
                ZStack {
                    GridBackgroundView()
                        .frame(width: geo.size.width, height: geo.size.height)
                    
                    path
                        .strokedPath(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 1)
                        .foregroundColor(.accentColor)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct GridBackgroundView: View {
    var body: some View {
        GeometryReader { g in
            let w = g.size.width
            let h = g.size.height
            Canvas { context, size in
                // 수평 중앙 라인
                var central = Path()
                central.move(to: CGPoint(x: 0, y: h/2))
                central.addLine(to: CGPoint(x: w, y: h/2))
                context.stroke(central, with: .color(.gray.opacity(0.25)), lineWidth: 1)
                
                
                for i in 1...3 {
                    let y = h * Double(i) / 4.0
                    var p = Path()
                    p.move(to: CGPoint(x: 0, y: y))
                    p.addLine(to: CGPoint(x: w, y: y))
                    context.stroke(p, with: .color(.gray.opacity(0.06)), lineWidth: 0.5)
                }
                
                
                let cols = 8
                for i in 0...cols {
                    let x = w * Double(i) / Double(cols)
                    var p = Path()
                    p.move(to: CGPoint(x: x, y: 0))
                    p.addLine(to: CGPoint(x: x, y: h))
                    context.stroke(p, with: .color(.gray.opacity(0.04)), lineWidth: 0.5)
                }
            }
        }
    }
}

#Preview {
    FMSynthesis()
}

