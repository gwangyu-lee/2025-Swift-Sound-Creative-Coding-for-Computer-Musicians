import SwiftUI
import AVFoundation
import simd
import Foundation
import Combine

// MARK: - FM Synth Engine (AVAudioEngine + AVAudioSourceNode)
final class FMSaberEngine {
    private let engine = AVAudioEngine()
    private var sourceNode: AVAudioSourceNode!

    public var targetCarrier: Double = 220.0
    public var targetModFreq: Double = 90.0
    public var targetIndex: Double = 2.5
    public var targetVibDepth: Double = 0.0
    public var targetAmp: Double = 0.0

    private var carrierFreq: Double = 220.0
    private var modFreq: Double = 90.0
    private var modIndex: Double = 2.5
    private var vibDepth: Double = 0.0
    private var amp: Double = 0.0

    private var sampleRate: Double = 48_000.0
    private var carPhase: Double = 0.0
    private var modPhase: Double = 0.0

    // Interpolation
    private let ampSlew: Double = 0.0015
    private let slew: Double = 0.002

    init() {
        let output = engine.outputNode
        let fmt = output.inputFormat(forBus: 0)
        sampleRate = fmt.sampleRate

        sourceNode = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self = self else { return noErr }
            let abl = UnsafeMutableAudioBufferListPointer(audioBufferList)

            for frame in 0..<Int(frameCount) {
                
                // Interpolation
                self.amp        += (self.targetAmp      - self.amp)        * self.ampSlew
                self.carrierFreq += (self.targetCarrier - self.carrierFreq) * self.slew
                self.modFreq    += (self.targetModFreq  - self.modFreq)    * self.slew
                self.modIndex   += (self.targetIndex    - self.modIndex)   * self.slew
                self.vibDepth   += (self.targetVibDepth - self.vibDepth)   * self.slew

                let carInc = 2.0 * .pi * self.carrierFreq / self.sampleRate
                let modInc = 2.0 * .pi * self.modFreq    / self.sampleRate
                self.carPhase += carInc
                self.modPhase += modInc
                if self.carPhase > 2.0 * .pi { self.carPhase -= 2.0 * .pi }
                if self.modPhase > 2.0 * .pi { self.modPhase -= 2.0 * .pi }

                let vib = self.vibDepth * sin(0.5 * self.modPhase)

                // FM
                let s = sin(self.carPhase + (self.modIndex + vib) * sin(self.modPhase)) * self.amp

                for buf in abl {
                    let p = buf.mData!.assumingMemoryBound(to: Float.self)
                    p[frame] = Float(s)
                }
            }
            return noErr
        }

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

// MARK: - SwiftUI
struct SaberView: View {
    @StateObject private var vm = SaberViewModel()
    @State private var previewTimer: Foundation.Timer?

    private var isXcodePreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // 붉은 빛
            RadialGradient(
                gradient: Gradient(colors: [
                    .red.opacity(vm.isOn ? 0.9 : 0.0),
                    .red.opacity(vm.isOn ? 0.35 : 0.0),
                    .black.opacity(0.0)
                ]),
                center: .center,
                startRadius: 20,
                endRadius: 500
            )
            .blur(radius: vm.isOn ? 16 : 0)
            .animation(.easeInOut(duration: 0.15), value: vm.isOn)
            .allowsHitTesting(false)

            VStack {
                Text(vm.isOn ? "LIGHTSABER ON" : "Tap & Hold to Ignite")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundStyle(vm.isOn ? .white : .gray)
                    .padding(.top, 40)

                Spacer()

//                VStack(spacing: 8) {
//                    HStack {
//                        label("Carrier", "\(Int(vm.engine.targetCarrier)) Hz")
//                        label("Mod",     "\(Int(vm.engine.targetModFreq)) Hz")
//                    }
//                    label("Index", String(format: "%.2f", vm.engine.targetIndex))
//                }
//                .font(.system(.footnote, design: .monospaced))
//                .foregroundStyle(vm.isOn ? .white.opacity(0.9) : .gray)
//                .padding(.bottom, 40)
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
                startPreviewAnimation()   // UI only
            } else {
                vm.start()
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

    private func startPreviewAnimation() {
        stopPreviewAnimation()
        let baseCar = 220.0, baseMod = 90.0, baseIdx = 2.5
        var t = 0.0
        previewTimer = Foundation.Timer.scheduledTimer(withTimeInterval: 1.0/30.0, repeats: true) { [weak vm] _ in
            guard let vm = vm else { return }
            t += 1.0/30.0
            vm.engine.targetCarrier = baseCar * (1.0 + 0.1 * sin(t * 1.7))
            vm.engine.targetModFreq = baseMod * (1.0 + 0.1 * cos(t * 1.3))
            vm.engine.targetIndex   = baseIdx + 1.2 * abs(sin(t * 0.9))
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

// MARK: - ViewModel (SensorManager 기반)
final class SaberViewModel: ObservableObject {
    let engine = FMSaberEngine()
    @ObservedObject var sensor = SensorManager()
    @Published var isOn: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        sensor.$accel.combineLatest(sensor.$gyro)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] accel, gyro in
                guard let self = self else { return }

                let rotMag = simd_length(SIMD3(gyro.x, gyro.y, gyro.z))
                let accMag = simd_length(SIMD3(accel.x, accel.y, accel.z))

                let idx = self.clamp(self.map(rotMag, 0.0, 12.0, 0.8, 8.0), 0.2, 10.0)
                let cents   = self.clamp(self.map(accMag, 0.0, 1.2, -150.0, 900.0), -300.0, 1200.0)
                let baseCar = 220.0
                let baseMod = 90.0
                let carrier = self.clamp(baseCar * pow(2.0, cents / 1200.0), 80.0, 1200.0)
                let modF = self.clamp(baseMod * (carrier / baseCar), 40.0, 400.0)
                let vib = self.clamp(self.map(rotMag, 0.0, 12.0, 0.0, 0.25), 0.0, 0.5)

                // target 값만 업데이트 (엔진 내부에서 보간)
                self.engine.targetCarrier = carrier
                self.engine.targetModFreq = modF
                self.engine.targetIndex   = idx
                self.engine.targetVibDepth = vib
            }
            .store(in: &cancellables)
    }

    func start()    { engine.start() }
    func stop()     { engine.saberOff(); engine.stop() }
    func touchDown(){ guard !isOn else { return }; isOn = true; engine.saberOn() }
    func touchUp()  { isOn = false; engine.saberOff() }

    private func map(_ x: Double, _ inMin: Double, _ inMax: Double, _ outMin: Double, _ outMax: Double) -> Double {
        if inMax - inMin == 0 { return outMin }
        let t = (x - inMin) / (inMax - inMin)
        return outMin + (outMax - outMin) * t
    }
    private func clamp(_ x: Double, _ lo: Double, _ hi: Double) -> Double { min(max(x, lo), hi) }
}

#Preview {
    SaberView()
}

