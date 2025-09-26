//
//  CompassView.swift
//  07
//
//  Created by Gwangyu Lee on 8/19/25.
//

import SwiftUI
//import AudioKit

struct CompassView: View {
    @ObservedObject var sensorManager: SensorManager
    
    @State private var frequency: Double = 220
    @State private var fmIndex: Double = 0
    @State private var noteOnOff: Bool = false
    @State private var selectedWave: String = "sine"
    
    // 연속 각도(언랩) 상태
    @State private var displayedHeading: Double = 0
    @State private var lastRawHeading: Double?

    // heading 변화 감지 후 noteOff 예약
    @State private var noteOffWorkItem: DispatchWorkItem?

    var body: some View {
        VStack {
            // 🔹 모던 나침반 UI
            ModernCompassView(heading: displayedHeading)
                .frame(width: 220, height: 220)
                .padding()
            
            // 🔹 값 표시 (옵션)
            Text("\(normalize0to360(displayedHeading), specifier: "%.2f")°")
                .font(.title2)
                .foregroundColor(.secondary)
            
        }
        .onChange(of: sensorManager.heading) { oldValue, newValue in
            // 1) 연속 각도 업데이트 (각도 언랩 + 최단 경로 누적)
            if let last = lastRawHeading {
                let delta = shortestDelta(from: last, to: newValue)
                displayedHeading += delta
            } else {
                displayedHeading = newValue
            }
            lastRawHeading = newValue

            // 2) OSC는 원시 heading(0...360)을 그대로 전송
            sendOSCMessage(address: "/heading", value: sensorManager.heading)

            // 3) 오디오는 연속 각도를 사용해 점프 방지
            fmIndex = newValue
            SynthManager.shared.updateFMIndex(fmIndex)

            print("Compass: oldValue: \(oldValue), newValue: \(newValue), displayed: \(displayedHeading), fmindex: \(fmIndex)")

            // 기존 noteOn/noteOff 지연 로직 유지
            SynthManager.shared.noteOn(frequency: frequency)
            noteOnOff = true

            noteOffWorkItem?.cancel()

            let workItem = DispatchWorkItem {
                SynthManager.shared.noteOff()
                noteOnOff = false
                print("Compass: noteOff after 0.5s inactivity")
            }
            noteOffWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        }
        .onAppear {
            setOSCClientIP()
            SynthManager.shared.updateFrequency(frequency: frequency)
            SynthManager.shared.selectedWave = selectedWave
            lastRawHeading = sensorManager.heading
            displayedHeading = sensorManager.heading
            print("Compass: onAppear")
        }
        .onDisappear {
            // NavigationSplitView list로 나갈 때도 noteOff
            SynthManager.shared.noteOff()
            noteOnOff = false
            print("Compass: onDisappear -> noteOff")
        }
    }
    
    // -180...+180 범위의 최단 각도 차이 계산
    private func shortestDelta(from: Double, to: Double) -> Double {
        var d = (to - from).truncatingRemainder(dividingBy: 360)
        if d > 180 { d -= 360 }
        if d < -180 { d += 360 }
        return d
    }

    // 표시용: 0...360 정규화
    private func normalize0to360(_ angle: Double) -> Double {
        let v = angle.truncatingRemainder(dividingBy: 360)
        return v >= 0 ? v : (v + 360)
    }
}

#Preview {
    @Previewable @StateObject var sensorManager = SensorManager()
    CompassView(sensorManager: sensorManager)
}

//
// 🔹 모던 나침반 UI 구현
//
struct ModernCompassView: View {
    var heading: Double
    
    var body: some View {
        ZStack {
            // 바깥 링
            Circle()
                .strokeBorder(
                    AngularGradient(
                        gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.white]),
                        center: .center
                    ),
                    lineWidth: 4
                )
                .shadow(color: .black.opacity(0.2), radius: 5)
            
            // N/E/S/W 표시
            let labels = ["N","E","S","W"]
            ForEach(0..<4) { i in
                let label = labels[i]
                Text(label)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(label == "N" ? .red : .primary)
                    .position(
                        x: i == 1 ? 200 - 20 : (i == 3 ? 20 : 100), // E, W, 가운데
                        y: i == 0 ? 20 : (i == 2 ? 200 - 20 : 100)  // N, S, 가운데
                    )
                    .frame(width: 200, height: 200, alignment: .center)
            }

            
            // 바늘 (빨강/파랑)
            ZStack {
                Capsule()
                    .fill(Color.red.gradient)
                    .frame(width: 8, height: 90)
                    .offset(y: -45)
                
                Capsule()
                    .fill(Color.blue.gradient)
                    .frame(width: 8, height: 90)
                    .offset(y: 45)
            }
            .rotationEffect(.degrees(heading))
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: heading)
            
            // 중앙 점
            Circle()
                .fill(Color.primary)
                .frame(width: 14, height: 14)
        }
    }
}
