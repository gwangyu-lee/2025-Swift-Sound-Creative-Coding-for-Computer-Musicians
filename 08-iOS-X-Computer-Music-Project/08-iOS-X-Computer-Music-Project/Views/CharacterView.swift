//
//  CharacterView.swift
//  07
//

import SwiftUI

struct CharacterView: View {
    @ObservedObject var sensorManager: SensorManagerTJ
    @State private var isOn = false
    
    @State private var frequency: Double = 440
    @State private var amplitude: Double = 0.5 // 초기 진폭을 0이 아닌 값으로 설정
    @State private var fmIndex: Double = 0
    
    // MARK: - 매핑 함수
    private func mappedFrequency(from roll: Double) -> Double {
        let minFreq = 220.0
        let maxFreq = 880.0
        // 로그 스케일 매핑: roll 값을 정규화하고 지수 함수에 적용
        let rollNorm = (roll / (.pi / 2) + 1) / 2 // -pi/2 ~ pi/2 -> 0 ~ 1
        return minFreq * pow(maxFreq / minFreq, rollNorm.clamped(to: 0...1))
    }
    
    private func mappedAmplitude(from pitch: Double) -> Double {
        // 선형 매핑: pitch 값을 0과 1 사이로 정규화
        let pitchNorm = (pitch / (.pi / 2) + 1) / 2 // -pi/2 ~ pi/2 -> 0 ~ 1
        return pitchNorm.clamped(to: 0...1)
    }
    
    private func mappedFMIndex(from heading: Double) -> Double {
        // 선형 매핑: heading 값을 0과 15 사이로 정규화
        let minIndex = 0.0
        let maxIndex = 30.0
        let headingNorm = heading / 360.0 // 0 ~ 360 -> 0 ~ 1
        return minIndex + (maxIndex - minIndex) * headingNorm.clamped(to: 0...1)
    }
    
    private func mappedBackgroundColor(roll: Double, pitch: Double) -> Color {
        let hue: Double = (roll / (.pi/2) + 1) / 2
        let brightness: Double = 0.4 + ((pitch / (.pi/2) + 1) / 2) * 0.6
        return Color(hue: hue, saturation: 0.8, brightness: brightness)
    }
    
    // MARK: - 사운드 업데이트 로직
    private func updateSoundParameters() {
        guard isOn else { return }
        
        // 현재 센서 값으로 모든 사운드 파라미터 업데이트
        let currentRoll = sensorManager.roll
        let currentPitch = sensorManager.pitch
        let currentHeading = sensorManager.heading
        
        frequency = mappedFrequency(from: currentRoll)
        amplitude = mappedAmplitude(from: currentPitch)
        fmIndex = mappedFMIndex(from: currentHeading)

        
        SynthManagerTJ.shared.updateFrequency(frequency: frequency)
        SynthManagerTJ.shared.updateAmplitude(amplitude)
        SynthManagerTJ.shared.updateFMIndex(fmIndex)
    }
    
    var body: some View {
        ZStack {
            // 🌈 배경
            mappedBackgroundColor(roll: sensorManager.roll,
                                  pitch: sensorManager.pitch)
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.3), value: sensorManager.roll)
            .animation(.easeInOut(duration: 0.3), value: sensorManager.pitch)
            
            VStack(spacing: 20) {
                // 📝 상단 중앙 텍스트
                Text("Annoying kid")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.top, 40)
                
                Spacer()
                
                // 👤 캐릭터 얼굴
                ZStack {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 200, height: 200)
                        .shadow(radius: 10)
                    
                    // 👀 눈 (방위각 따라 이동, 탭으로 개폐)
                    HStack(spacing: 60) {
                        EyeView(isAwake: isOn, offset: eyeOffset(from: sensorManager.heading))
                        EyeView(isAwake: isOn, offset: eyeOffset(from: sensorManager.heading))
                    }
                    
                    // 👄 입 (주파수/음량에 따라 변화)
                    MouthView(frequency: frequency, amplitude: amplitude)
                        .offset(y: 50)
                }
                .onDisappear {
                    SynthManagerTJ.shared.stop()
                }
                .onTapGesture {
                    isOn.toggle()
                    if isOn {
                        SynthManagerTJ.shared.start()
                        // SynthManager.shared.noteOn(frequency: frequency)
                        // 시작 시 현재 센서 값으로 사운드 즉시 초기화
                        updateSoundParameters()
                    } else {
                        SynthManagerTJ.shared.stop()
                        // SynthManager.shared.noteOff()
                        // 소리가 꺼지면 진폭을 0으로 리셋
                        amplitude = 0
                    }
                }
                
                // 설명 텍스트
//                Text("아이를 눌러서 깨우고\n아이가 짜증을 낼 수 있게\n핸드폰을 이리저리 움직여보세요.")
                Text("Tap the child to wake them up,\nand move your phone around\nso the child can throw a tantrum.")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.top, 10)
                
                Spacer()
            }
        }
        // MARK: - 센서 변화 감지
        .onChange(of: sensorManager.heading) { _ in
            if isOn {updateSoundParameters() }
        }
        .onChange(of: sensorManager.roll) { _ in
            if isOn {updateSoundParameters() }
        }
        .onChange(of: sensorManager.pitch) { _ in
            if isOn {updateSoundParameters() }
        }
    }
    // 눈동자 이동 매핑
    private func eyeOffset(from heading: Double) -> CGSize
    {
        let maxOffset: CGFloat = 10
        // heading(0~360)을 라디안으로 변환하고, 0도가 위쪽을 향하도록 각도 조정
        let angle = (heading * .pi / 180.0) - (.pi / 2)
        let offsetX = maxOffset * cos(angle)
        let offsetY = maxOffset * sin(angle)
        return CGSize(width: offsetX, height: offsetY)
    }
}

// MARK: - 👀 눈
struct EyeView: View {
    var isAwake: Bool
    var offset: CGSize
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 40, height: 40)
            
            if isAwake {
                Circle()
                    .fill(Color.black)
                    .frame(width: 20, height: 20)
                    .offset(offset)
                    .animation(.spring(), value: offset)
            } else {
                Capsule()
                    .fill(Color.black)
                    .frame(width: 30, height: 4)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isAwake)
    }
}

// MARK: - 👄 입
struct MouthView: View {
    var frequency: Double
    var amplitude: Double
    var body: some View {
        Capsule()
            .fill(Color.red)
            .frame(width: mouthWidth(from: frequency),
                   height: mouthHeight(from: amplitude))
            .animation(.spring(response: 0.2,
                               dampingFraction: 0.7), value: frequency)
            .animation(.spring(response: 0.2,
                               dampingFraction: 0.7), value: amplitude)
    }
    
    private func mouthWidth(from frequency: Double) ->
    CGFloat {
        let minW: CGFloat = 40
        let maxW: CGFloat = 120
        let norm = (frequency - 220) / (880 - 220)
        return minW + (maxW - minW) * CGFloat (norm.clamped(to: 0...1))
    }
    
    private func mouthHeight(from amplitude: Double) ->
    CGFloat {
        let minH: CGFloat = 10
        let maxH: CGFloat = 60
        return minH + (maxH - minH) * CGFloat (amplitude.clamped(to: 0...1))
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound),limits.upperBound)
    }
}

#Preview {
    @Previewable @StateObject var sensorManager = SensorManagerTJ()
    
    CharacterView(sensorManager: sensorManager)
}
