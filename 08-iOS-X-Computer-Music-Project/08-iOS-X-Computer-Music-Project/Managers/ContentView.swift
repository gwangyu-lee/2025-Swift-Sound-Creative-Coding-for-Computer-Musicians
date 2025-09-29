import SwiftUI
import AVFoundation
import CoreMotion
import simd
import Foundation   // Timer, ProcessInfo

// MARK: - FM Synth Engine (AVAudioEngine + AVAudioSourceNode)
final class FMSaberEngine {
    private let engine = AVAudioEngine()
    private var sourceNode: AVAudioSourceNode!

    // 외부 제어 파라미터 (UI/모션이 갱신)
    public var carrierFreq: Double = 220.0
    public var modFreq: Double = 90.0
    public var modIndex: Double = 2.5
    public var targetAmp: Double = 0.0
    public var vibDepth: Double = 0.0

    // 내부 상태
    private var sampleRate: Double = 48_000.0
    private var carPhase: Double = 0.0
    private var modPhase: Double = 0.0
    private var amp: Double = 0.0
    private let ampSlew: Double = 0.0015  // on/off 램핑

    init() {
        let output = engine.outputNode
        let fmt = output.inputFormat(forBus: 0)
        sampleRate = fmt.sampleRate

        sourceNode = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self = self else { return noErr }
            let abl = UnsafeMutableAudioBufferListPointer(audioBufferList)

            for frame in 0..<Int(frameCount) {
                // 앰프 스무딩(클릭 방지)
                self.amp += (self.targetAmp - self.amp) * self.ampSlew

                // 위상 증가 + 래핑
                let carInc = 2.0 * .pi * self.carrierFreq / self.sampleRate
                let modInc = 2.0 * .pi * self.modFreq     / self.sampleRate
                self.carPhase += carInc
                self.modPhase += modInc
                if self.carPhase > 2.0 * .pi { self.carPhase -= 2.0 * .pi }
                if self.modPhase > 2.0 * .pi { self.modPhase -= 2.0 * .pi }

                // 약한 바이브레이토(느린 요동)
                let vib = self.vibDepth * sin(0.5 * self.modPhase)

                // FM 합성: y = sin(car + (index+vib)*sin(mod)) * amp
                let s = sin(self.carPhase + (self.modIndex + vib) * sin(self.modPhase)) * self.amp

                // 스테레오 채우기
                for buf in abl {
                    let p = buf.mData!.assumingMemoryBound(to: Float.self)
                    p[frame] = Float(s)
                }
            }
            return noErr
        }

        // 노드 연결
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                   sampleRate: sampleRate,
                                   channels: 2,
                                   interleaved: false)!
        engine.attach(sourceNode)
        engine.connect(sourceNode, to: engine.mainMixerNode, format: format)
        engine.mainMixerNode.outputVolume = 0.9
    }

    private func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, options: [.defaultToSpeaker, .mixWithOthers])
            try session.setActive(true)
        } catch {
            print("AudioSession error:", error)
        }
    }

    func start() {
        guard !engine.isRunning else { return }
        configureAudioSession()
        do { try engine.start() } catch { print("Engine start error:", error) }
    }

    func stop() { engine.stop() }

    func saberOn()  { start(); targetAmp = 0.22 }
    func saberOff() { targetAmp = 0.0 }
}

// MARK: - Motion → FM 파라미터 매핑
final class SaberMotion: ObservableObject {
    private let motion = CMMotionManager()
    private let queue = OperationQueue()
    private let engine: FMSaberEngine

    // 기준값
    private var baseCarrier: Double = 220.0
    private var baseModFreq: Double = 90.0

    init(engine: FMSaberEngine) {
        self.engine = engine
        queue.qualityOfService = .userInteractive
    }

    func start() {
        guard motion.isDeviceMotionAvailable else { return }
        motion.deviceMotionUpdateInterval = 1.0 / 100.0 // 100 Hz
        motion.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical, to: queue) { [weak self] dm, _ in
            guard let self = self, let dm = dm else { return }

            // 회전/가속도 크기
            let r = dm.rotationRate
            let a = dm.userAcceleration
            let rotMag = simd_length(SIMD3(r.x, r.y, r.z))
            let accMag = simd_length(SIMD3(a.x, a.y, a.z))

            // 모듈레이션 인덱스 (휘두를수록 밝음)
            let idx = self.clamp(self.map(rotMag, 0.0, 12.0, 0.8, 8.0), 0.2, 10.0)

            // 캐리어 주파수 (가속도로 피치 가감, 약 ±1옥타브)
            let cents   = self.clamp(self.map(accMag, 0.0, 1.2, -150.0, 900.0), -300.0, 1200.0)
            let carrier = self.clamp(self.baseCarrier * pow(2.0, cents / 1200.0), 80.0, 1200.0)

            // 모듈레이터: 캐리어 비율 유지
            let modF = self.clamp(self.baseModFreq * (carrier / self.baseCarrier), 40.0, 400.0)

            // 바이브 깊이
            let vib = self.clamp(self.map(rotMag, 0.0, 12.0, 0.0, 0.25), 0.0, 0.5)

            // 엔진에 반영
            self.engine.carrierFreq = carrier
            self.engine.modFreq     = modF
            self.engine.modIndex    = idx
            self.engine.vibDepth    = vib
        }
    }

    func stop() { motion.stopDeviceMotionUpdates() }

    // 유틸
    private func map(_ x: Double, _ inMin: Double, _ inMax: Double, _ outMin: Double, _ outMax: Double) -> Double {
        if inMax - inMin == 0 { return outMin }
        let t = (x - inMin) / (inMax - inMin)
        return outMin + (outMax - outMin) * t
    }
    private func clamp(_ x: Double, _ lo: Double, _ hi: Double) -> Double { min(max(x, lo), hi) }
}

// MARK: - SwiftUI
struct ContentView: View {
    @StateObject private var vm = SaberViewModel()
    @State private var previewTimer: Timer?

    // 프리뷰 감지: 프리뷰에서는 오디오/모션을 돌리지 않음
    private var isXcodePreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // 붉은 빛
            RadialGradient(gradient: Gradient(colors: [
                .red.opacity(vm.isOn ? 0.9 : 0.0),
                .red.opacity(vm.isOn ? 0.35 : 0.0),
                .black.opacity(0.0)
            ]), center: .center, startRadius: 20, endRadius: 500)
            .blur(radius: vm.isOn ? 16 : 0)
            .animation(.easeInOut(duration: 0.15), value: vm.isOn)
            .allowsHitTesting(false)

            VStack {
                Text(vm.isOn ? "LIGHTSABER ON" : "Tap & Hold to Ignite")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundStyle(vm.isOn ? .white : .gray)
                    .padding(.top, 40)

                Spacer()

                VStack(spacing: 8) {
                    HStack {
                        label("Carrier", "\(Int(vm.engine.carrierFreq)) Hz")
                        label("Mod",     "\(Int(vm.engine.modFreq)) Hz")
                    }
                    label("Index", String(format: "%.2f", vm.engine.modIndex))
                }
                .font(.system(.footnote, design: .monospaced))
                .foregroundStyle(vm.isOn ? .white.opacity(0.9) : .gray)
                .padding(.bottom, 40)
            }
            .padding()
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in vm.touchDown() }
                .onEnded   { _ in vm.touchUp() }
        )
        .onAppear {
            if isXcodePreview {
                vm.isOn = true
                startPreviewAnimation()   // UI만 살짝 흔들어 보이기
            } else {
                vm.start()                // 실제 오디오/모션
            }
        }
        .onDisappear {
            if isXcodePreview {
                stopPreviewAnimation()
            } else {
                vm.stop()
            }
        }
        .statusBarHidden(true)
    }

    // 프리뷰 전용 애니메이션 (UI 확인용)
    private func startPreviewAnimation() {
        stopPreviewAnimation()
        let baseCar = 220.0, baseMod = 90.0, baseIdx = 2.5
        var t = 0.0
        previewTimer = Timer.scheduledTimer(withTimeInterval: 1.0/30.0, repeats: true) { _ in
            t += 1.0/30.0
            vm.engine.carrierFreq = baseCar * (1.0 + 0.1 * sin(t*1.7))
            vm.engine.modFreq     = baseMod * (1.0 + 0.1 * cos(t*1.3))
            vm.engine.modIndex    = baseIdx + 1.2 * abs(sin(t*0.9))
        }
    }
    private func stopPreviewAnimation() {
        previewTimer?.invalidate()
        previewTimer = nil
    }

    @ViewBuilder
    private func label(_ title: String, _ value: String) -> some View {
        HStack { Text(title).opacity(0.7); Spacer(); Text(value) }
            .frame(maxWidth: 320)
    }
}

// MARK: - ViewModel
final class SaberViewModel: ObservableObject {
    let engine = FMSaberEngine()
    private lazy var motion = SaberMotion(engine: engine)
    @Published var isOn: Bool = false

    func start()    { engine.start();    motion.start() }
    func stop()     { engine.saberOff(); engine.stop(); motion.stop() }
    func touchDown(){ guard !isOn else { return }; isOn = true;  engine.saberOn() }
    func touchUp()  { isOn = false; engine.saberOff() }
}

// --- 프리뷰 (구형/신형 모두 호환) ---
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDisplayName("Saber – UI Only")
            .previewDevice("iPhone 15 Pro")
    }
}
#endif
/* import SwiftUI
 
 @main
 struct FMLightSaberApp: App {
     var body: some Scene {
         WindowGroup {
             ContentView()
         }
     }
 } */
