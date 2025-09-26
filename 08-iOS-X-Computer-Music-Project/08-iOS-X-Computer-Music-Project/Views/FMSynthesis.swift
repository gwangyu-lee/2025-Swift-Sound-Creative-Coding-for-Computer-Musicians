//
//  ContentView.swift
//  06-Computer-Music
//
//  Created by Gwangyu Lee on 8/18/25.
//

import SwiftUI

struct FMSynthesis: View {
    
    @State private var frequency: Double = 440
    @State private var fmIndex: Double = 0
    @State private var noteOnOff: Bool = false
    
    @State private var selectedWave: String = "sine"
    @State private var wave = ["sine", "sawtooth", "triangle", "rectangle", "noise"]
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text("What is FM Synthesis?")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            
//            HStack() {
//                VStack() {
//                    Text("Sine · 5 Hz")
//                        .font(.headline)
//                    SineOscilloscopeView(demoFrequency: 5.0, demoTimeWindow: 1.0, demoSamples: 600)
//                        .frame(height: 120)
//                }
//                
//                VStack() {
//                    Text("Sine · 1 Hz")
//                        .font(.headline)
//                    SineOscilloscopeView(demoFrequency: 1.0, demoTimeWindow: 1.0, demoSamples: 600)
//                        .frame(height: 120)
//                }
//            }
//            
//            VStack(alignment: .leading, spacing: 6) {
//                Text("Frequency Modulated by 1Hz Sine (1~9 Hz)")
//                    .font(.headline)
//                ModulatedFrequencyView()
//                    .frame(height: 120)
//            }


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
            if noteOnOff {
                noteOnOff = false
                SynthManager.shared.noteOff()
                print("View disappeared: Note Off")
            }
        }
    }
}


struct SineOscilloscopeView: View {
    var demoFrequency: Double
    var demoTimeWindow: Double = 1.0
    var demoSamples: Int = 512
    var demoAmplitude: Double = 0.9 // 뷰 높이에 대한 비율
    
    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation) { ctx in
                let t = ctx.date.timeIntervalSinceReferenceDate
                let w = Double(geo.size.width)
                let h = Double(geo.size.height)
                let centerY = h / 2.0
                let amp = (h / 2.0) * demoAmplitude
                
                // 샘플을 순회해서 Path 구성
                let path = Path { p in
                    for i in 0..<demoSamples {
                        let x = Double(i) / Double(demoSamples - 1)
                        // map x -> sample time
                        let sampleTime = t - (1.0 - x) * demoTimeWindow
                        
                        // value: 순수 사인파
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
                    // 배경 그리드
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

// Frequency Modulation Sine Oscilloscope
struct ModulatedFrequencyView: View {
    var minFreq: Double = 1.0     // 최소 Frequency
    var maxFreq: Double = 9.0     // 최대 Frequency
    var modFrequency: Double = 1.0 // 변조 주파수 1Hz
    var demoTimeWindow: Double = 10.0 // 시각화 시간 (초)
    var demoSamples: Int = 100   // 샘플 수
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
                        
                        // 1Hz 사인으로 Frequency 변조
                        let freqMod = (sin(2.0 * .pi * modFrequency * sampleTime) + 1.0) / 2.0
                        let currentFreq = minFreq + freqMod * (maxFreq - minFreq)
                        
                        // 시각화용 사인파
                        let value = sin(2.0 * .pi * currentFreq * sampleTime)
                        
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
                        .foregroundColor(.blue)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

// 기존 GridBackgroundView 재사용 가능



/// 간단한 배경 그리드
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
                
                // 가로 보조선
                for i in 1...3 {
                    let y = h * Double(i) / 4.0
                    var p = Path()
                    p.move(to: CGPoint(x: 0, y: y))
                    p.addLine(to: CGPoint(x: w, y: y))
                    context.stroke(p, with: .color(.gray.opacity(0.06)), lineWidth: 0.5)
                }
                
                // 세로 눈금
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
