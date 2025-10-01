import SwiftUI
import CoreMotion

// MARK: - Triangle Shape
struct Triangle: Shape {
    var cornerRadius: CGFloat = 10.0
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let top = CGPoint(x: rect.midX, y: rect.minY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        path.move(to: CGPoint(x: top.x, y: top.y + cornerRadius))
        path.addArc(tangent1End: bottomLeft, tangent2End: bottomRight, radius: cornerRadius)
        path.addArc(tangent1End: bottomRight, tangent2End: top, radius: cornerRadius)
        path.addArc(tangent1End: top, tangent2End: bottomLeft, radius: cornerRadius)
        path.closeSubpath()
        return path
    }
}

// MARK: - CicadaWing View
struct CicadaWing: View {
    @Binding var isAnimating: Bool
    let animationResponse: Double

    @State private var startTime: Date? = nil

    var body: some View {
        Group {
            if isAnimating {
                TimelineView(.animation) { context in
                    let elapsedTime = context.date.timeIntervalSince(startTime ?? context.date)
                    let rotationAngle = calculateAngle(for: elapsedTime)
                    
                    Triangle()
                        .fill(Color.primary.opacity(0.3))
                        .scaleEffect(x: 0.8, y: 1.0)
                        .rotationEffect(.degrees(rotationAngle), anchor: .top)
                }
            } else {
                Triangle()
                    .fill(Color.primary.opacity(0.3))
                    .scaleEffect(x: 0.8, y: 1.0)
                    .rotationEffect(.degrees(0), anchor: .top)
            }
        }
        .onAppear {
            if isAnimating {
                startTime = .now
            }
        }
        .onChange(of: isAnimating) { _, newIsAnimating in
            if newIsAnimating {
                startTime = .now
            } else {
                startTime = nil
            }
        }
    }

    private func calculateAngle(for elapsedTime: TimeInterval) -> Double {
        let period = animationResponse * 2.0
        guard period > 0 else { return 0 }
        let sineValue = sin(elapsedTime * (2.0 * .pi / period))
        let normalizedValue = (sineValue + 1) / 2.0
        return normalizedValue * -10.0
    }
}

// MARK: - Cicadidae View
struct Cicadidae: View {
    @State private var isPlaying = false
    @State private var dragAmount = CGSize.zero
    @State private var speedIndex: Double = 0.0
    @State private var speedIndexBeforeDrag: Double = 0.0
    @State private var animationResponse: Double = 0.5
    private let synth = SynthManagerYH.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Cicada")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack {
//                Text("여름은 지나갔지만...")
//                Text("매미는 우리 마음속에 살아있습니다...")
                
                Text("Summer has passed...")
                Text("But the cicada still lives on in our hearts...")
            }
            .padding()
            .multilineTextAlignment(.center)
            .foregroundColor(.secondary)
            .offset(y: -20)
            
            GeometryReader { proxy in
                let baseSize = min(proxy.size.width, proxy.size.height)
                let bodyWidth = baseSize * 0.3
                let bodyHeight = bodyWidth * 2.5
                
                ZStack {
                    let fillGradient = LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(white: 0.4), location: 0),
                            .init(color: Color(white: 0.4), location: CGFloat(speedIndex)),
                            .init(color: .gray, location: CGFloat(speedIndex)),
                            .init(color: .gray, location: 1.0)
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    )

                    Capsule()
                        .fill(fillGradient)
                        .frame(width: bodyWidth, height: bodyHeight)
                        .shadow(radius: 10)
                        .zIndex(1)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    if self.dragAmount == .zero {
                                        self.speedIndexBeforeDrag = self.speedIndex
                                    }
                                    self.dragAmount = value.translation
                                    guard self.isPlaying else { return }
                                    let locationY = value.location.y
                                    let newIndex = self.map(value: locationY, fromRange: (0, bodyHeight), toRange: (1.0, 0.0))
                                    self.speedIndex = max(0.0, min(1.0, newIndex))
                                }
                                .onEnded { _ in
                                    let dragDistance = sqrt(pow(self.dragAmount.width, 2) + pow(self.dragAmount.height, 2))
                                    if dragDistance < 10 {
                                        if self.isPlaying { self.speedIndex = self.speedIndexBeforeDrag }
                                        self.isPlaying.toggle()
                                        if self.isPlaying {
                                            self.synth.noteOn(frequency: 350)
                                        } else {
                                            self.synth.noteOff()
                                        }
                                    }
                                    self.dragAmount = .zero
                                }
                        )
                    
                    Group {
                        let eyeSize = bodyWidth * 0.12
                        let eyeOffsetX = bodyWidth * 0.2
                        let eyeOffsetY = bodyHeight * -0.36
                        
                        Circle().frame(width: eyeSize, height: eyeSize).foregroundColor(.primary.opacity(0.8)).offset(x: -eyeOffsetX, y: eyeOffsetY)
                        Circle().frame(width: eyeSize, height: eyeSize).foregroundColor(.primary.opacity(0.8)).offset(x: eyeOffsetX, y: eyeOffsetY)
                        
                        let mouthSize = bodyWidth * 0.3
                        let mouthOffsetY = self.isPlaying ? bodyHeight * -0.312 : bodyHeight * -0.272
                        
                        Capsule().trim(from: 0.0, to: 0.5).stroke(Color.primary.opacity(0.8), lineWidth: 3).frame(width: mouthSize, height: mouthSize)
                            .rotationEffect(.degrees(self.isPlaying ? 0 : 180))
                            .offset(y: mouthOffsetY)
                            .animation(.easeInOut(duration: 0.2), value: self.isPlaying)
                    }
                    .zIndex(2)
                    
                    let wingWidth = bodyWidth * 1.4
                    let wingHeight = bodyHeight * 0.7
                    let wingOffsetX = bodyWidth * 0.4
                    let wingOffsetY = bodyHeight * 0.1
                    
                    CicadaWing(isAnimating: self.$isPlaying, animationResponse: self.animationResponse)
                        .frame(width: wingWidth, height: wingHeight)
                        .offset(x: wingOffsetX, y: wingOffsetY)
                    
                    CicadaWing(isAnimating: self.$isPlaying, animationResponse: self.animationResponse)
                        .frame(width: wingWidth, height: wingHeight)
                        .scaleEffect(x: -1.0, y: 1.0)
                        .offset(x: -wingOffsetX, y: wingOffsetY)
                    
                }
                .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
            }
            
            // ✨ 요청하신 안내 문구로 정확히 복원했습니다.
            VStack {
//                Text("볼륨을 줄이고 매미를 만지세요.")
//                Text("매미를 만져서 울리거나 달래줄 수 있습니다.")
//                Text("위, 아래로 쓰다듬어서 울음 소리를 조절하세요.")
                Text("Turn down the volume and touch the cicada.")
                Text("You can make it cry or calm it down by touching it.")
                Text("Stroke it up and down to control its sound.")
             
            }
            .padding()
            .multilineTextAlignment(.center)
            .foregroundColor(.secondary)
            .offset(y: -10)
        }
        .padding()
        .onAppear(perform: setupSynthesizer)
        .onDisappear {
            if self.isPlaying {
                self.synth.noteOff()
                self.isPlaying = false
            }
        }
        .onChange(of: speedIndex) { _, newValue in
            let newRate = self.mapExponential(value: CGFloat(newValue), toRange: (1.0, 20.0))
            self.animationResponse = (1.0 / newRate) / 2.0
            
            let newDepth = self.map(value: CGFloat(newValue), fromRange: (0.0, 1.0), toRange: (20000.0, 30.0))
            let newIndex = self.map(value: CGFloat(newValue), fromRange: (0.0, 1.0), toRange: (25.0, 25.0))
            
            self.synth.updateVibrato(rate: newRate, depth: newDepth)
            self.synth.updateFMIndex(newIndex)
        }
    }
    
    private func setupSynthesizer() {
        self.synth.updateModulatorFrequency(220)
        print("View: Cicadidae.swift")
        
        self.synth.selectedWave = "sawtooth"
        self.synth.updateEnvelope(attack: 0.05, decay: 0.1, sustain: 0.9, release: 0.1)
        
        let initialRate = self.mapExponential(value: CGFloat(self.speedIndex), toRange: (1.0, 20.0))
        self.animationResponse = (1.0 / initialRate) / 2.0
        
        let initialDepth = self.map(value: CGFloat(self.speedIndex), fromRange: (0.0, 1.0), toRange: (20000.0, 30.0))
        let initialIndex = self.map(value: CGFloat(self.speedIndex), fromRange: (0.0, 1.0), toRange: (25.0, 25.0))

        self.synth.updateVibrato(rate: initialRate, depth: initialDepth)
        self.synth.updateFMIndex(initialIndex)
    }

    private func map(value: Double, fromRange: (Double, Double), toRange: (Double, Double)) -> Double {
        let fromSpan = fromRange.1 - fromRange.0
        let toSpan = toRange.1 - toRange.0
        let clampedValue = max(fromRange.0, min(value, fromRange.1))
        let valueScaled = (clampedValue - fromRange.0) / fromSpan
        return toRange.0 + (valueScaled * toSpan)
    }
    
    private func map(value: CGFloat, fromRange: (CGFloat, CGFloat), toRange: (Double, Double)) -> Double {
        let fromSpan = fromRange.1 - fromRange.0
        let toSpan = toRange.1 - toRange.0
        let clampedValue = max(fromRange.0, min(value, fromRange.1))
        let valueScaled = (clampedValue - fromRange.0) / fromSpan
        return toRange.0 + (Double(valueScaled) * toSpan)
    }
    
    private func mapExponential(value: CGFloat, toRange: (Double, Double)) -> Double {
        let minv = log(toRange.0)
        let maxv = log(toRange.1)
        let scale = (maxv - minv) * Double(value)
        return exp(minv + scale)
    }
}

// MARK: - SwiftUI Preview
#Preview {
    Cicadidae()
}
