import Foundation
import AudioKit
import SoundpipeAudioKit   // 여기 꼭 필요!
import AVFoundation

class SynthManagerTJ {
    static let shared = SynthManagerTJ()
    
    let engine = AudioEngine()
    let carrier = FMOscillator()   // FM 오실레이터
    let mixer = Mixer()
    
    private init() {
        mixer.addInput(carrier)
        engine.output = mixer
        
    }
    
    func start() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AV Error")
        }
        
        do {
            try engine.start()
            carrier.start()
        } catch {
            print("Error starting engine: \(error)")
        }
    }
    
    func stop() {
        carrier.stop()
        engine.stop()
    }
    
    func updateFrequency(frequency: Double) {
        carrier.baseFrequency = AUValue(frequency)
    }
    
    func updateAmplitude(_ amp: Double) {
        carrier.amplitude = AUValue(amp)
    }
    
    func updateFMIndex(_ index: Double) {
        carrier.modulationIndex = AUValue(index)
    }
}
