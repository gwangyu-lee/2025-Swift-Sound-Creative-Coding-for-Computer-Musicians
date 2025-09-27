import AVFoundation

class SynthManager {
    static let shared = SynthManager()
    
    private var engine = AVAudioEngine()
    private var sourceNode: AVAudioSourceNode!
    private var sampleRate: Double = 44100.0
    
    private var targetGain: Double = 1.0
    private let gainSmoothingFactor: Double = 0.001
    
    private var targetModulationIndex: Double = 0.0
    private let modulationSmoothingFactor: Double = 0.001
    
    private var phase: Double = 0.0
    public private(set) var frequency: Double = 440.0
    public private(set) var gain: Double = 1.0
    
    private var envelope: Double = 0.0
    private var isNoteOn = false
    private var envelopePhase: String = "idle"
    
    public var selectedWave: String = "sine"
    
    // MARK: FM Modulator
    private var modulationIndex: Double = 0.0
    private var modulatorFrequency: Double = 220.0
    
    private var modulatorPhase: Double = 0.0
    
    // MARK: Vibrato
    private var vibratoRate: Double = 0.0
    private var vibratoDepth: Double = 20.0
    private var vibratoPhase: Double = 0.0
    
    // MARK: Envelope
    private var attackTime: Double = 0.2
    private var decayTime: Double = 0.5
    private var sustainLevel: Double = 0.5
    private var releaseTime: Double = 0.5
    
    private init() {
        setupAudioSession()
        setupEngine()
        setupNotifications()
    }
    
    func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
            print("✅ Audio session activated")
        } catch {
            print("❌ Audio session error: \(error)")
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(forName: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance(), queue: .main) { notification in
            guard let userInfo = notification.userInfo,
                  let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                  let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }
            
            if type == .ended {
                self.tryRestartEngine()
            }
        }
    }
    
    private func tryRestartEngine() {
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            try engine.start()
            print("✅ Audio engine restarted after interruption")
        } catch {
            print("❌ Failed to restart audio engine: \(error)")
        }
    }
    
    private func stopAudioEngine() {
        engine.stop()
        engine.reset()
        if let existingNode = sourceNode {
            engine.detach(existingNode)
        }
        print("🛑 Audio engine stopped and cleaned up")
    }
    
    private func setupEngine() {
        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        
        let newSourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            guard let buffer = ablPointer.first else { return noErr }
            let samples = buffer.mData!.assumingMemoryBound(to: Float.self)
            
            for frame in 0..<Int(frameCount) {
                self.updateEnvelope()
                let delta = 1.0 / self.sampleRate
                
                let vibrato = sin(self.vibratoPhase) * self.vibratoDepth
                self.vibratoPhase += 2.0 * .pi * self.vibratoRate * delta
                if self.vibratoPhase > 2.0 * .pi {
                    self.vibratoPhase -= 2.0 * .pi
                }
                
                self.modulationIndex += (self.targetModulationIndex - self.modulationIndex) * self.modulationSmoothingFactor
                let modulator = sin(self.modulatorPhase) * self.modulationIndex
                self.modulatorPhase += 2.0 * .pi * self.modulatorFrequency * delta
                if self.modulatorPhase > 2.0 * .pi {
                    self.modulatorPhase -= 2.0 * .pi
                }
                
                let modulatedFreq = self.frequency + vibrato + modulator
                let time = self.phase + modulator
                
                self.gain += (self.targetGain - self.gain) * self.gainSmoothingFactor
                
                let sample: Double
                switch self.selectedWave {
                case "sine":
                    sample = sin(time) * self.envelope * self.gain
                case "sawtooth":
                    sample = 2.0 * (time / (2.0 * .pi) - floor(0.5 + time / (2.0 * .pi))) * self.envelope * self.gain
                case "triangle":
                    sample = (2.0 / .pi) * asin(sin(time)) * self.envelope * self.gain
                case "rectangle":
                    sample = (sin(time) >= 0 ? 1.0 : -1.0) * self.envelope * self.gain
                case "noise":
                    sample = (Double.random(in: -1.0...1.0)) * self.envelope * self.gain
                default:
                    sample = sin(time) * self.envelope * self.gain
                }
                
                samples[frame] = Float(sample)
                
                self.phase += 2.0 * .pi * modulatedFreq / self.sampleRate
                if self.phase > 2.0 * .pi {
                    self.phase -= 2.0 * .pi
                }
            }
            
            return noErr
        }
        
        engine.attach(newSourceNode)
        engine.connect(newSourceNode, to: engine.mainMixerNode, format: format)
        self.sourceNode = newSourceNode
        
        do {
            try engine.start()
            print("✅ Audio engine started")
        } catch {
            print("❌ Audio engine failed to start: \(error)")
        }
    }
    
    func restartAudioSystem() {
        stopAudioEngine()
        setupAudioSession()
        setupEngine()
        setupNotifications()
    }
    
    // MARK: Function
    
    func updateVibratoRate(_ rate: Double) {
        self.vibratoRate = max(0.0, min(rate, 20.0))
    }
    
    func noteOn(frequency: Double) {
        self.frequency = frequency
        isNoteOn = true
        envelopePhase = "attack"
    }
    
    func noteOff() {
        if isNoteOn {
            envelopePhase = "release"
            isNoteOn = false
        }
    }
    
    func updateFrequency(frequency: Double) {
        self.frequency = frequency
    }
    
    func updateAmplitude(_ amplitude: Double) {
        self.targetGain = max(0.0, min(amplitude, 1.0))
    }
    
    func updateVibrato(rate: Double, depth: Double) {
        self.vibratoRate = rate
        self.vibratoDepth = depth
    }
    
    func updateFMIndex(_ index: Double) {
        self.targetModulationIndex = index
        print("SynthManager: Received FM Index: \(index)")
    }
    
    func updateModulatorFrequency(_ frequency: Double) {
        // Clamp to a safe range: 0 Hz up to Nyquist frequency
        let nyquist = sampleRate / 2.0
        let clamped = max(0.0, min(frequency, nyquist))
        self.modulatorFrequency = clamped
        print("SynthManager: Modulator frequency set to \(clamped) Hz")
    }
    
    func updateEnvelope(attack: Float, decay: Float, sustain: Float, release: Float) {
        self.attackTime = Double(attack)
        self.decayTime = Double(decay)
        self.sustainLevel = Double(sustain)
        self.releaseTime = Double(release)
    }
    
    private func updateEnvelope() {
        switch envelopePhase {
        case "attack":
            envelope += 1.0 / (sampleRate * attackTime)
            if envelope >= 1.0 {
                envelope = 1.0
                envelopePhase = "decay"
            }
        case "decay":
            envelope -= (1.0 - sustainLevel) / (sampleRate * decayTime)
            if envelope <= sustainLevel {
                envelope = sustainLevel
                envelopePhase = "sustain"
            }
        case "sustain":
            envelope = sustainLevel
        case "release":
            envelope -= sustainLevel / (sampleRate * releaseTime)
            if envelope <= 0.0 {
                envelope = 0.0
                envelopePhase = "idle"
            }
        default:
            break
        }
    }
}
