import SwiftUI
import AVFoundation
import Accelerate
import Combine


// MARK: - FM Synthesizer
class FMSynthesizer {
    private var audioEngine: AVAudioEngine!
    private var playerNode: AVAudioPlayerNode!
    private var format: AVAudioFormat!
    private var carrierPhase: Float = 0
    private var modulatorPhase: Float = 0
    
    struct Params {
        static let fcMin: Float = 300.0
        static let fcMax: Float = 800.0
        static let fmRatioMin: Float = 2.0
        static let fmRatioMax: Float = 5.0
        static let indexMin: Float = 0.5
        static let indexMax: Float = 3.0
    }

    // MARK: - Blanket Sound
    func playBlanketSound() {
        let buffer = synthesize(
            carrierFreq: 500,
            modulatorFreq: 150,
            modulationIndex: 0.4,
            duration: 2.0,
            attack: 0.12,      // 더 긴 어택
            decay: 0.25,       // 더 긴 디케이
            sustain: 0.7,      // 서스테인 조금 줄임
            release: 1.5       // 더 긴 릴리즈
        )
        playerNode.scheduleBuffer(buffer, at: nil, options: [.interrupts], completionHandler: nil)
        if !playerNode.isPlaying {
            playerNode.play()
        }
    }
    
    init() {
        setupAudioEngine()
    }
    
    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        audioEngine.attach(playerNode)
        
        format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: format)
        
        // 오디오 세션 설정 (틱 노이즈 방지)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session setup failed: \(error)")
        }
        
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine start failed: \(error)")
        }
    }
    
    func synthesize(
        carrierFreq: Float,
        modulatorFreq: Float,
        modulationIndex: Float,
        duration: Float,
        attack: Float,
        decay: Float,
        sustain: Float,
        release: Float
    ) -> AVAudioPCMBuffer {
        let sampleRate = Float(format.sampleRate)
        let frameCount = AVAudioFrameCount(duration * sampleRate)
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
        buffer.frameLength = frameCount

        guard let samples = buffer.floatChannelData?[0] else { return buffer }

        let totalFrames = Int(frameCount)
        let attackFrames = Int(attack * sampleRate)
        let decayFrames = Int(decay * sampleRate)
        let releaseFrames = Int(release * sampleRate)
        let sustainFrames = max(0, totalFrames - attackFrames - decayFrames - releaseFrames)

        // 위상 연속성을 위해 현재 위상 사용
        var carrierPhase = self.carrierPhase
        var modulatorPhase = self.modulatorPhase
        
        // 첫 번째 샘플에서의 위상값을 저장 (연속성 체크용)
        let initialCarrierSample = sin(2 * .pi * carrierPhase + sin(2 * .pi * modulatorPhase) * modulationIndex)

        for i in 0..<totalFrames {
            var envelope: Float = 1.0
            
            if i < attackFrames {
                // 부드러운 exponential attack (더 자연스러운 시작)
                let progress = Float(i) / Float(attackFrames)
                envelope = 1.0 - exp(-5.0 * progress) // exponential curve
            } else if i < attackFrames + decayFrames {
                let decayProgress = Float(i - attackFrames) / Float(decayFrames)
                // 부드러운 exponential decay
                envelope = sustain + (1.0 - sustain) * exp(-3.0 * decayProgress)
            } else if i < attackFrames + decayFrames + sustainFrames {
                envelope = sustain
            } else {
                let releaseProgress = Float(i - attackFrames - decayFrames - sustainFrames) / Float(releaseFrames)
                // 부드러운 exponential release
                envelope = sustain * exp(-4.0 * releaseProgress)
            }

            let modulator = sin(2 * .pi * modulatorPhase) * modulationIndex
            let carrier = sin(2 * .pi * carrierPhase + modulator)

            samples[i] = carrier * envelope * 0.3 // 볼륨 약간 낮춤

            // 위상 증가 (정확한 계산)
            carrierPhase += carrierFreq / sampleRate
            modulatorPhase += modulatorFreq / sampleRate

            // 위상 정규화 (fmod 사용으로 더 정확하게)
            carrierPhase = fmod(carrierPhase, 1.0)
            modulatorPhase = fmod(modulatorPhase, 1.0)
        }

        // DC 성분 제거를 더 정확하게
        var dcOffset: Float = 0
        for i in 0..<totalFrames {
            dcOffset += samples[i]
        }
        dcOffset /= Float(totalFrames)
        
        for i in 0..<totalFrames {
            samples[i] -= dcOffset
        }

        // 더 부드러운 페이드인/아웃 적용
        let fadeSamples = min(64, totalFrames / 4) // 페이드를 조금 늘림
        if fadeSamples > 0 {
            for i in 0..<fadeSamples {
                let fadeProgress = Float(i) / Float(fadeSamples)
                // 더 부드러운 Hann window 적용
                let hannWindow = 0.5 * (1.0 - cos(.pi * fadeProgress))
                
                // 페이드인
                samples[i] *= hannWindow
                
                // 페이드아웃
                let endIndex = totalFrames - 1 - i
                if endIndex >= 0 {
                    samples[endIndex] *= hannWindow
                }
            }
        }

        // 첫 번째와 마지막 몇 샘플을 완전히 0으로 (틱 노이즈 완전 방지)
        let zeroSamples = min(8, totalFrames / 16)
        for i in 0..<zeroSamples {
            samples[i] *= Float(i) / Float(zeroSamples)
            if totalFrames - 1 - i >= 0 {
                samples[totalFrames - 1 - i] *= Float(i) / Float(zeroSamples)
            }
        }

        // 위상 상태 저장 (다음 버퍼와의 연속성 보장)
        self.carrierPhase = carrierPhase
        self.modulatorPhase = modulatorPhase

        return buffer
    }
    
    func playDragSound(progress: Float) {
        let fc: Float = 400 + progress * 400
        let fm: Float = fc * 3.0
        let index: Float = 1.0 + progress * 1.0

        let buffer = synthesize(
            carrierFreq: fc,
            modulatorFreq: fm,
            modulationIndex: index,
            duration: 0.08,  // 짧고 날카롭게 (쾌감 유지)
            attack: 0.003,   // 매우 빠른 어택 (딱딱한 느낌)
            decay: 0.015,    // 빠른 디케이
            sustain: 0.0,
            release: 0.025   // 적당한 릴리즈
        )

        playerNode.scheduleBuffer(buffer, at: nil, options: [.interrupts], completionHandler: nil)
        if !playerNode.isPlaying {
            playerNode.play()
        }
    }
    
    func playReleaseSound(metrics: GestureMetrics, repetitionCount: Int) {
        let fc = map(metrics.length, from: 0...500, to: Params.fcMin...Params.fcMax)
        let fmRatio: Float = 3.5
        let fm = fc * fmRatio

        let modulationIndex = map(metrics.peakVelocity, from: 0...2000, to: Params.indexMin...Params.indexMax)

        let buffer = synthesize(
            carrierFreq: fc,
            modulatorFreq: fm,
            modulationIndex: modulationIndex,
            duration: 0.18,    // 조금 더 길게
            attack: 0.010,     // 더 긴 어택
            decay: 0.045,      // 더 긴 디케이
            sustain: 0.0,
            release: 0.08      // 더 긴 릴리즈
        )

        playerNode.scheduleBuffer(buffer, at: nil, options: [.interrupts], completionHandler: nil)
        if !playerNode.isPlaying {
            playerNode.play()
        }
    }
    
    private func map(_ value: Float, from: ClosedRange<Float>, to: ClosedRange<Float>) -> Float {
        let normalized = (value - from.lowerBound) / (from.upperBound - from.lowerBound)
        let clamped = min(max(normalized, 0), 1)
        return to.lowerBound + clamped * (to.upperBound - to.lowerBound)
    }

    // MARK: - Funny Song: Dumb FM melody with random notes
    func playFunnySong() {
        for i in 0..<8 {
            let delay = Double(i) * 0.2
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                guard let self = self else { return }
                let fc = Float.random(in: 200...800)
                let fm = fc * Float.random(in: 1.0...4.0)
                let index = Float.random(in: 0.5...3.0)
                let buffer = self.synthesize(
                    carrierFreq: fc,
                    modulatorFreq: fm,
                    modulationIndex: index,
                    duration: 0.18,  // 조금 더 길게
                    attack: 0.008,   // 더 긴 어택 (틱 노이즈 방지)
                    decay: 0.04,     // 더 긴 디케이
                    sustain: 0.15,   // 서스테인 줄임
                    release: 0.08    // 더 긴 릴리즈
                )
                self.playerNode.scheduleBuffer(buffer, at: nil, options: [.interrupts], completionHandler: nil)
                if !self.playerNode.isPlaying {
                    self.playerNode.play()
                }
            }
        }
    }
}

// MARK: - Gesture Metrics
struct GestureMetrics {
    var length: Float = 0
    var avgVelocity: Float = 0
    var peakVelocity: Float = 0
    var gestureDuration: Float = 0
}

class GestureMetricsCalculator: ObservableObject {
    @Published var currentMetrics = GestureMetrics()
    @Published var repetitionCount: Int = 0
    
    private var startY: CGFloat = 0
    private var startTime: Date = Date()
    private var velocities: [Float] = []
    private var lastGestureTime: Date?
    private var recentGestures: [Date] = []
    private var lastSoundTrigger: Date?
    
    private let minLength: CGFloat = 20
    private let rollingWindow: TimeInterval = 10.0
    
    func startGesture(at location: CGPoint) {
        startY = location.y
        startTime = Date()
        velocities.removeAll()
        currentMetrics = GestureMetrics()
        lastSoundTrigger = nil
    }
    
    func updateGesture(at location: CGPoint) {
        let deltaY = startY - location.y
        let elapsed = Date().timeIntervalSince(startTime)
        
        guard elapsed > 0 else { return }
        
        currentMetrics.length = Float(max(0, deltaY))
        currentMetrics.gestureDuration = Float(elapsed)
        
        let velocity = Float(deltaY) / Float(elapsed)
        velocities.append(velocity)
        
        currentMetrics.avgVelocity = velocities.reduce(0, +) / Float(velocities.count)
        currentMetrics.peakVelocity = velocities.max() ?? 0
    }
    
    func shouldTriggerDragSound() -> Bool {
        let now = Date()
        if let last = lastSoundTrigger, now.timeIntervalSince(last) < 0.08 {
            return false
        }
        lastSoundTrigger = now
        return true
    }
    
    func endGesture() -> Bool {
        let now = Date()
        
        guard currentMetrics.length >= Float(minLength) else {
            return false
        }
        
        if let last = lastGestureTime, now.timeIntervalSince(last) < 0.05 {
            return false
        }
        
        recentGestures.append(now)
        recentGestures = recentGestures.filter { now.timeIntervalSince($0) <= rollingWindow }
        repetitionCount = recentGestures.count
        
        lastGestureTime = now
        return true
    }
    
    func getDebugString() -> String {
        """
        L: \(String(format: "%.1f", currentMetrics.length))
        V: \(String(format: "%.1f", currentMetrics.avgVelocity))
        Vmax: \(String(format: "%.1f", currentMetrics.peakVelocity))
        N: \(repetitionCount)
        T: \(String(format: "%.2f", currentMetrics.gestureDuration))
        """
    }
}

// MARK: - TissueItem Model
struct TissueItem: Identifiable, Equatable {
    let id = UUID()
    var offset: CGFloat
    var rotation: Double
    var horizontalOffset: CGFloat
    var opacity: Double
    var isFalling: Bool
}

// MARK: - TissueView (refactored for independent state)
struct TissueView: View {
    var offset: CGFloat
    var rotation: Double
    var horizontalOffset: CGFloat
    var opacity: Double
    var tissueColor: Color

    @State private var animatingOffset: CGFloat = 0
    @State private var animatingHorizontal: CGFloat = 0
    @State private var animatingRotation: Double = 0
    @State private var animatingOpacity: Double = 1.0

    var body: some View {
        // Animate with spring for a more natural curved pull
        Rectangle()
            .fill(tissueColor.gradient)
            .frame(width: 70, height: 200)
            .cornerRadius(8)
            .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
            .overlay(
                Rectangle()
                    .stroke(Color.gray.opacity(0.15), lineWidth: 0.5)
            )
            // Curve the pull: sideways arc based on upward pull distance
            .offset(
                x: horizontalOffset + sin(offset / 80) * 20,
                y: -offset + 20
            )
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .animation(.interactiveSpring(response: 0.38, dampingFraction: 0.68), value: offset)
    }
}

// MARK: - TissueBoxView
struct TissueBoxView: View {
    var isNightMode: Bool
    var body: some View {
        ZStack(alignment: .top) {
            // Main box back and shadow
            RoundedRectangle(cornerRadius: 20)
                .fill(isNightMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : Color(red: 0.9, green: 0.9, blue: 0.85))
                .frame(width: 250, height: 120)
                .shadow(radius: 5)
            // (Removed Ellipse slot shadow)
            // Main box front (covers lower part, hides tissue below slot)
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 20)
                    .fill(isNightMode ? Color(red: 0.2, green: 0.2, blue: 0.25) : Color(red: 0.9, green: 0.9, blue: 0.85))
                    .frame(width: 250, height: 120)
                    .mask(
                        Rectangle()
                            .frame(width: 250, height: 120)
                            .offset(y: 18) // Only lower part, adjust for slot opening
                    )
                    .overlay(
                        // Text label
                        VStack {
                            Spacer()
                            Text("힘들 때 웃는 자가 1류다")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(isNightMode ? .white : .black)
                                .padding(.bottom, 50)
                        }
                    )
            }
            .frame(width: 250, height: 120)
        }
    }
}

// MARK: - Main View
// MARK: - 메인 뷰 (ContentView)
@MainActor
struct TissueContentView: View {
    // 휴지 뽑기 제스처 측정기 (ObservableObject)
    @StateObject private var metricsCalculator = GestureMetricsCalculator() // 제스처 측정기 상태 객체
    // FM 합성 사운드 생성기
    @State private var synthesizer = FMSynthesizer() // FM 신스 사운드 객체

    @State private var showBlanket = false
    @State private var blanketPending = false
    @State private var showDogEmoji = false
    @State private var showCatEmoji = false
    @State private var receiptPending = false
    @State private var showReceipt = false
    @State private var hairPending = false
    @State private var showHair = false

    // 현재 화면에 표시되는 휴지 아이템 배열 (각 휴지의 위치, 회전 등 상태 포함)
    @State private var tissueItems: [TissueItem] = [
        TissueItem(offset: 60, rotation: 0, horizontalOffset: 0, opacity: 1.0, isFalling: false)
    ]
    @State private var tissueColor: Color = .white // 휴지 색상 상태
    @State private var isDragging = false // 사용자가 현재 드래그 중인지 여부
    @State private var animationPhase: AnimationPhase = .idle // 현재 애니메이션 단계

    @State private var nightMessage: String? = nil // 밤에 표시할 멘트(이스터에그/유머)
    @State private var pullCount: Int = 0 // 휴지 뽑기 누적 횟수

    @State private var nextHumorTrigger: Int = Int.random(in: 2...3) // 다음 유머 멘트 트리거 카운트

    // Night mode state
    @State private var isNightMode: Bool = false
    
    // 초기 애니메이션 상태
    @State private var isAppStarting: Bool = true
    @State private var introMessageOffset: CGFloat = 0

    // 밤 시간대에 표시할 멘트 배열
    private let nightTimeMentions: [String] = [
        "이 시간엔… 자야 하지 않나요?",
        "새벽 감성 좋아… 근데 눈 감고 느껴봐요.",
        "휴지 말고 이불을 뽑으세요.",
        "이쯤이면 당신도 알고 있을 거예요. 그만해야 할 시간이라는 걸.",
        "이 시간엔 휴지도 졸려요.",
        "우린 지금 새벽에… 휴지를 뽑고 있어요.",
        "자자. 자요. 제발 자요.",
        "지금… 당신 뒤에 졸음이 있어요.",
        "그만 뽑아… 나 오늘 꿈에 나올 거야.",
        "한 장 더 뽑으면 이불 깔아줄게.",
        "그만 자요. 안 그러면 당신 꿈에 휴지 요정이 나타나 잔소리할 거예요.",
        "이렇게 늦은 시간에 뽑는 휴지는… 사실 과거의 후회를 닦는 용도입니다.",
        "이제 뽑으면 자동으로 영수증이 나올지도…",
        "속보: 휴지, 주인의 손길을 피해 망명 시도.",
        "이제 뽑은 건 휴지가 아니라… 인생의 잔여 털입니다."
        
    ]
    // 유머 멘트 배열
    private let humorMentions: [String] = [
        "이제 그만 뽑아줘… 내 삶이 갈기갈기야…",
        "휴지곽이 속삭임: '살려줘…'",
        "당신의 리듬, 드러머가 질투함.",
        "조심해요! 휴지가 도망가고 싶어해요.",
        "방금 휴지가 숨을 헐떡였어요.",
        "다 쓴 줄 알았지? 하지만 인생도 리필돼.",
        "가장 필요한 순간에 나타나는 것. 그것이 휴지의 존재 이유.",
        "당신이 뽑은 것은 휴지가 아니라, 사실 '오늘의 운세'였습니다.",
        "대길(大吉)! 오늘 복권 당첨 대신 잃어버린 양말을 찾을 운명입니다.",
        "뽑은 휴지의 질감이 매우 부드럽습니다. 오늘 커피는 공짜입니다.",
        "경고: 오늘 안에 겪을 '이불 밖은 위험해' 지수가 300% 상승했습니다.",
        "오늘의 행운 색깔은 흰색입니다. 휴지 색깔이 흰색이 아니라면... 조심하세요.",
        "대길(大吉)! 오늘 복권 당첨 대신 잃어버린 양말을 찾을 운명입니다.",
        "재물운 상승! 하지만 지갑을 열 때마다 먼지만 보게 될 것입니다.",
        "오늘 당신의 책상 위에서 잃어버린 '작년의 영수증'을 발견할 운명입니다.",
        "오늘 만날 사람은... 어제 편의점에서 마주친 그 고양이일 확률이 높습니다.",
        "야옹^^!*",
        "대학원은 휴지 심과 같아요. 끝은 있는데 리필해도 또 끝이 없죠.",
        "세상 모든 털복숭이에게 거부당하는 운명. 전 강아지와 고양이 알러지가 둘다있거든요. 저주받았죠."
        
    ]

    private let maxPullLength: CGFloat = 400 // 휴지 최대 뽑기 길이
    private let cutThreshold: CGFloat = 150  // 휴지 절단(분리) 임계값

    // 애니메이션 단계 정의
    enum AnimationPhase {
        case idle, pulling, cutting, retracting // 대기, 뽑기 중, 잘라내기, 복귀
    }

    var body: some View {
        ZStack { // MARK: - 전체 레이아웃 ZStack (배경, 휴지곽, 휴지, 멘트)
            (isNightMode ? Color.black : Color(hex: "#F5F5F0")).ignoresSafeArea() // 배경색

            // MARK: - 하단 안내 문구 및 총 뽑은 횟수 표시 (애니메이션 포함)
            VStack {
                Spacer()
                Text("슬플 땐 휴지를 뽑아 눈물을 닦아보세요… :)")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isNightMode ? .white : .gray)
                    .offset(y: introMessageOffset)
                    .opacity(isAppStarting ? 0 : 1)
                    .animation(.easeInOut(duration: 1.5).delay(2.0), value: isAppStarting)
                    .animation(.spring(response: 1.2, dampingFraction: 0.8).delay(1.5), value: introMessageOffset)
                    .padding(.bottom, 50)
            }

            // MARK: - 휴지곽 + 휴지 (화면 중앙 배치)
            VStack {
                ZStack(alignment: .top) {
                    // 1. 휴지(들) 표시 (휴지곽 앞면 아래에 위치, 마스킹으로 위쪽만 보임)
                    ZStack {
                        ForEach(tissueItems) { tissue in
                            TissueView(
                                offset: tissue.offset,
                                rotation: tissue.rotation,
                                horizontalOffset: tissue.horizontalOffset,
                                opacity: tissue.opacity,
                                tissueColor: tissueColor
                            )
                            .zIndex(tissue.isFalling ? 20 : 5) // 떨어지는 휴지는 zIndex를 높임
                        }
                    }
                    .mask(
                        Rectangle()
                            .frame(width: 250, height: 500) // 휴지 최대 뽑기 길이만큼 마스킹
                            .offset(y: -250) // 위로 이동하여 상단만 노출
                    )
                    // 2. 휴지곽 (앞면 포함, 휴지 마스킹 역할)
                    TissueBoxView(isNightMode: isNightMode)
                        .zIndex(10)
                }
                .frame(width: 250)
                .frame(maxHeight: .infinity)
                .contentShape(Rectangle())
                .opacity(isAppStarting ? 0 : 1)
                .scaleEffect(isAppStarting ? 0.8 : 1.0)
                .animation(.easeInOut(duration: 1.0).delay(0.5), value: isAppStarting)
                .gesture(
                    // MARK: - 휴지 뽑기 제스처 처리
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            // 휴지 뽑기 제스처가 시작되거나 진행 중일 때
                            if animationPhase == .idle || animationPhase == .pulling {
                                if !isDragging {
                                    isDragging = true
                                    metricsCalculator.startGesture(at: value.startLocation) // 제스처 측정 시작
                                    animationPhase = .pulling
                                }

                                let delta = max(0, -value.translation.height) // 위로 뽑을 때만 양수
                                // 가장 위(최신)의 휴지 아이템만 위치 갱신
                                updateTopTissue { tissue in
                                    tissue.offset = min(delta, maxPullLength)
                                }

                                metricsCalculator.updateGesture(at: value.location) // 속도 등 측정 갱신

                                // 일정 시간마다 드래그 사운드 재생
                                if metricsCalculator.shouldTriggerDragSound() {
                                    let progress = Float((tissueItems.last?.offset ?? 0) / maxPullLength)
                                    synthesizer.playDragSound(progress: progress) // 드래그 사운드 재생
                                }
                            }
                        }
                        .onEnded { _ in
                            isDragging = false

                            // 제스처 종료: 충분히 뽑았는지/속도 등 체크
                            if metricsCalculator.endGesture() {
                                synthesizer.playReleaseSound(
                                    metrics: metricsCalculator.currentMetrics,
                                    repetitionCount: metricsCalculator.repetitionCount
                                ) // 휴지 뽑기 사운드 재생

                                if (tissueItems.last?.offset ?? 0) >= cutThreshold {
                                    performCut() // 충분히 뽑았으면 휴지 분리 애니메이션
                                } else {
                                    retractTissue() // 부족하면 휴지 복귀 애니메이션
                                }
                            } else {
                                playInvalidSound() // 유효하지 않은 제스처 사운드
                                retractTissue()
                            }
                        }
                )
            }

            // MARK: - 밤/이스터에그 멘트 오버레이
            if let nightMessage = nightMessage {
                Text(nightMessage)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isNightMode ? .white : .gray)
                    .padding()
                    .background(isNightMode ? Color.white.opacity(0.15) : Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 4)
                    .transition(.opacity)
                    .zIndex(100)
                    .padding(.top, 150) // 팝업 멘트위치
            }

            if showBlanket {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.9, green: 0.95, blue: 1.0),
                                Color(red: 0.8, green: 0.9, blue: 0.95)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 250)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 2)
                    )
                    .transition(.move(edge: .bottom))
                    .zIndex(80)
            }

            // 강아지 이모지
            if showDogEmoji {
                Text("🐶")
                    .font(.system(size: 60))
                    .offset(x: -100, y: -50)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.1).combined(with: .opacity),
                        removal: .scale(scale: 2.0).combined(with: .opacity)
                    ))
                    .zIndex(90)
            }

            // 고양이 이모지
            if showCatEmoji {
                Text("🐱")
                    .font(.system(size: 60))
                    .offset(x: 100, y: -50)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.1).combined(with: .opacity),
                        removal: .scale(scale: 2.0).combined(with: .opacity)
                    ))
                    .zIndex(90)
            }

            // 털 이펙트
            if showHair {
                VStack {
                    HStack(spacing: 8) {
                        ForEach(0..<5, id: \.self) { _ in
                            Text("💩")
                                .font(.system(size: CGFloat.random(in: 20...40)))
                                .rotationEffect(.degrees(Double.random(in: -30...30)))
                        }
                    }
                    HStack(spacing: 8) {
                        ForEach(0..<6, id: \.self) { _ in
                            Text("🪶")
                                .font(.system(size: CGFloat.random(in: 15...30)))
                                .rotationEffect(.degrees(Double.random(in: -45...45)))
                        }
                    }
                    HStack(spacing: 8) {
                        ForEach(0..<4, id: \.self) { _ in
                            Text("☕️")
                                .font(.system(size: CGFloat.random(in: 18...35)))
                                .rotationEffect(.degrees(Double.random(in: -20...20)))
                        }
                    }
                    Text("인생의 잔여 털이에요... 😰")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                }
                .offset(x: 0, y: -50)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.1).combined(with: .opacity),
                    removal: .scale(scale: 2.0).combined(with: .opacity)
                ))
                .zIndex(85)
            }

            // 영수증
            if showReceipt {
                VStack(alignment: .leading, spacing: 4) {
                    Text("🧾 영수증")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    
                    Divider()
                        .background(Color.black)
                        .frame(height: 1)
                    
                    Text("휴지곽 전문점")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("상품: 프리미엄 휴지 1매")
                        .font(.system(size: 12))
                        .foregroundColor(.black)
                    
                    Text("가격: ₩0 (무료)")
                        .font(.system(size: 12))
                        .foregroundColor(.black)
                    
                    Text("할인: -₩0 (감정 할인)")
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                    
                    Divider()
                        .background(Color.black)
                        .frame(height: 1)
                    
                    Text("총액: ₩0")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("감사합니다! 🙏")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .padding(.top, 2)
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.3), radius: 4, x: 2, y: 2)
                .frame(width: 200)
                .offset(x: 0, y: -100)
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .bottom).combined(with: .opacity)
                ))
                .zIndex(95)
            }

            // MARK: - 초기 인트로 멘트 (화면 중앙에서 시작)
            if isAppStarting {
                Text("슬플 땐 휴지를 뽑아 눈물을 닦아보세요… :)")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isNightMode ? .white : .gray)
                    .multilineTextAlignment(.center)
                    .opacity(isAppStarting ? 1 : 0)
                    .scaleEffect(isAppStarting ? 1.1 : 0.8)
                    .animation(.easeInOut(duration: 1.0), value: isAppStarting)
                    .zIndex(300)
            }
            VStack {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Button(action: { withAnimation { isNightMode.toggle() } }) {
                            Image(systemName: isNightMode ? "moon.fill" : "sun.max.fill")
                                .foregroundColor(isNightMode ? .yellow : .orange)
                                .font(.system(size: 20))
                                .padding()
                        }
                        
                        Button(action: {
                            synthesizer.playFunnySong()
                        }) {
                            Image(systemName: "music.note")
                                .foregroundColor(isNightMode ? .gray : .orange)
                                .font(.system(size: 18))
                                .padding()
                        }
                    }
                }
                Spacer()
            }
            .zIndex(200)
        }
        .onAppear {
            // 초기 애니메이션 시작
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    isAppStarting = false
                    introMessageOffset = 0
                }
            }
            
            // 시간별 이스터에그 체크
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                checkNightTimeEasterEgg()
            }
        }
    }

    // MARK: - 가장 위의 휴지 아이템만 갱신 (inout 클로저)
    private func updateTopTissue(_ update: (inout TissueItem) -> Void) {
        guard !tissueItems.isEmpty else { return }
        var current = tissueItems.removeLast()
        update(&current)
        tissueItems.append(current)
    }

    // MARK: - 휴지 분리(컷) 애니메이션 및 로직
    @MainActor
    private func performCut() {
        animationPhase = .cutting

        // --- 영수증 이스터에그 처리 ---
        if receiptPending {
            showReceipt = true
            receiptPending = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                withAnimation {
                    showReceipt = false
                }
            }
        }

        // --- 털 이스터에그 처리 ---
        if hairPending {
            showHair = true
            hairPending = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                withAnimation {
                    showHair = false
                }
            }
        }

        let fallOffset: CGFloat = 800 // 휴지 떨어지는 거리
        let swayRange: CGFloat = 10   // 좌우 흔들림 범위
        let randomSway = CGFloat.random(in: -swayRange...swayRange) // 랜덤 좌우 흔들림
        let randomRotation = Double.random(in: -30...30) // 랜덤 회전

        if !tissueItems.isEmpty {
            let lastId = tissueItems.last!.id

            // 1단계: 휴지 위로 튕기며 살짝 흔들림
            withAnimation(.interpolatingSpring(stiffness: 80, damping: 6)) {
                tissueItems = tissueItems.map { t in
                    if t.id == lastId {
                        var tt = t
                        tt.offset = fallOffset * 0.6
                        tt.rotation = randomRotation * 0.5
                        tt.opacity = 1.0
                        tt.isFalling = true
                        return tt
                    }
                    return t
                }
            }

            // 2단계: 약간의 딜레이 후, 아래로 떨어지며 투명도 감소 및 좌우 흔들림
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.72)) {
                    tissueItems = tissueItems.map { t in
                        if t.id == lastId {
                            var tt = t
                            tt.offset = fallOffset
                            tt.rotation = randomRotation
                            tt.opacity = 0.0
                            return tt
                        }
                        return t
                    }
                }
                // 좌우 흔들리는 애니메이션 (플로피 효과)
                withAnimation(Animation.easeInOut(duration: 0.3).repeatCount(3, autoreverses: true)) {
                    tissueItems = tissueItems.map { t in
                        if t.id == lastId {
                            var tt = t
                            tt.horizontalOffset = randomSway
                            return tt
                        }
                        return t
                    }
                }
            }
        }

        // 3단계: 새로운 휴지 생성(스폰) 및 자리로 애니메이션
        let newTissue = TissueItem(offset: 0, rotation: 0, horizontalOffset: 0, opacity: 0.0, isFalling: false)
        tissueItems.append(newTissue)
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            updateTopTissue { t in
                t.offset = 20
                t.opacity = 1.0
                t.rotation = 0
                t.horizontalOffset = 0
            }
            animationPhase = .idle
        }

        // 4단계: 일정 시간 후, 떨어진 휴지 제거
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            if tissueItems.count > 1 {
                tissueItems.removeFirst(tissueItems.count - 1)
            }
        }

        // --- Blanket overlay/sound trigger if pending ---
        if blanketPending {
            showBlanket = true
            synthesizer.playBlanketSound()
            blanketPending = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                withAnimation {
                    showBlanket = false
                }
            }
        }

        // --- 시간대별 유머/밤 멘트 출력 로직 ---
        pullCount += 1
        if pullCount == nextHumorTrigger {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: Date())
            let sourceMentions: [String]
            if hour >= 23 || hour < 7 {
                sourceMentions = nightTimeMentions
            } else {
                sourceMentions = humorMentions
            }
            let allMentions = sourceMentions.filter { $0 != nightMessage }
            if let random = allMentions.randomElement() {
                nightMessage = random
                // Blanket overlay and sound for specific message: now only set pending
                if random == "한 장 더 뽑으면 이불 깔아줄게." {
                    blanketPending = true
                }
                // 영수증 이스터에그: 다음번에 뽑으면 영수증 나옴
                if random == "이제 뽑으면 자동으로 영수증이 나올지도…" {
                    receiptPending = true
                }
                
                // 털 이스터에그: 다음번에 뽑으면 털 나옴
                if random == "이제 뽑은 건 휴지가 아니라… 인생의 잔여 털입니다." {
                    hairPending = true
                }
                // 휴지 색깔 이스터에그: 흰색 행운 메시지 → 휴지 색상을 파랑으로 애니메이션
                if random == "오늘의 행운 색깔은 흰색입니다. 휴지 색깔이 흰색이 아니라면... 조심하세요." {
                    withAnimation(.easeInOut(duration: 0.7)) {
                        tissueColor = .blue
                    }
                }
                // 털복숭이 알레르기 이스터에그: 강아지와 고양이 이모지 띄우기
                if random == "세상 모든 털복숭이에게 거부당하는 운명. 전 강아지와 고양이 알러지가 둘다있거든요. 저주받았죠." {
                    // 강아지 이모지
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            showDogEmoji = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                showDogEmoji = false
                            }
                        }
                    }
                    // 고양이 이모지
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            showCatEmoji = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                showCatEmoji = false
                            }
                        }
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    withAnimation {
                        nightMessage = nil
                    }
                }
            }
            nextHumorTrigger = pullCount + Int.random(in: 2...3)
        }
    }

    // MARK: - 휴지 복귀(원위치) 애니메이션
    @MainActor
    private func retractTissue() {
        animationPhase = .retracting
        withAnimation(.spring(response: 0.4, dampingFraction: 0.65)) {
            updateTopTissue { t in
                t.offset = 0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            animationPhase = .idle
        }
    }

    // MARK: - 시간별 이스터에그/멘트 체크 (정각마다 메시지)
    private func checkNightTimeEasterEgg() {
        let calendar = Calendar.current
        let now = Date()
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)

        if minute == 0 {
            switch hour {
            case 0:
                nightMessage = "00:00 AM — 새로운 하루가 시작됐어요."
            case 1:
                nightMessage = "01:00 AM — 아직도 깨어 있네요?"
            case 2:
                nightMessage = "02:00 AM — 오늘은 너무 늦었어요."
            case 3:
                nightMessage = "03:00 AM — 아직도 안 자요?"
            case 4:
                nightMessage = "04:00 AM — 새벽이 깊어가네요."
            case 5:
                nightMessage = "05:00 AM — 이건 새벽이 아니라 그냥 아침이에요. 인정하시죠?"
            case 6:
                nightMessage = "06:00 AM — 알람: ‘일어나세요.’ 나: ‘ㅋㅋ 그럴리가요’."
            case 7:
                nightMessage = "07:00 AM — 좋은 아침!"
            case 8:
                nightMessage = "08:00 AM — 오늘도 힘내요!"
            case 9:
                nightMessage = "09:00 AM — 뇌가 '커피'를 외치는 시간. 물 대신 카페인을 넣어주세요."
            case 10:
                nightMessage = "10:00 AM — 집중하기 좋은 시간이에요."
            case 11:
                nightMessage = "11:00 AM — 곧 점심시간!"
            case 12:
                nightMessage = "12:00 PM — 점심 메뉴는 인류의 영원한 난제. 혹시 메뉴 고민중?"
            case 13:
                nightMessage = "01:00 PM — 식곤증 vs 커피의 대결. 승리자는 늘 침대죠."
            case 14:
                nightMessage = "02:00 PM — 졸음 방지 스트레칭 타임! (하지만 마음은 이미 침대에)"
            case 15:
                nightMessage = "03:00 PM — 졸리면 눈을 감고 '명상'이라 합시다. 들키면 그냥 '생각 중'이라고 하세요."
            case 16:
                nightMessage = "04:00 PM — 인류가 잠든 시간. 당신은 이 우주에서 유일한 깨어있는 생명체."
            case 17:
                nightMessage = "05:00 PM — 퇴근 시간이 다가와요."
            case 18:
                nightMessage = "06:00 PM — 오늘 하루도 고생했어요."
            case 19:
                nightMessage = "07:00 PM — 저녁은 맛있게 드셨나요?"
            case 20:
                nightMessage = "08:00 PM — 여유로운 저녁 시간."
            case 21:
                nightMessage = "09:00 PM — 하루를 정리할 시간이에요."
            case 22:
                nightMessage = "10:00 PM — 냉장고 탐험은 일찍 마치고 침대로 직행하세요."
            case 23:
                nightMessage = "11:00 PM — 폰을 내려놓으세요! 휴지가 '제발 좀 자라'고 말하고 있어요."
            default:
                break
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                withAnimation {
                    nightMessage = nil
                }
            }
        }

        // 30초마다 재확인
        DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) {
            checkNightTimeEasterEgg()
        }
    }

    // MARK: - 유효하지 않은 제스처(짧게 뽑기 등) 사운드 재생
    @MainActor
    private func playInvalidSound() {
        synthesizer.playDragSound(progress: 0.1)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    TissueContentView()
}
