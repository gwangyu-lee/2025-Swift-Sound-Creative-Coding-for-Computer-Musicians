//
//  SensorManager.swift
//  07
//

import SwiftUI
import CoreMotion
import CoreLocation
import Combine

class SensorManagerTJ: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let motionManager = CMMotionManager()
    private let locationManager = CLLocationManager()
    
    // Accelerometer
    @Published var accel: (x: Double, y: Double, z: Double) = (0,0,0)
    
    // Gyro
    @Published var gyro: (x: Double, y: Double, z: Double) = (0,0,0)
    
    // Orientation
    @Published var roll: Double = 0   // X축 기울기
    @Published var pitch: Double = 0  // Y축 기울기
    @Published var yaw: Double = 0    // Z축 회전값
    
    // Compass
    @Published var heading: Double = 0   // 방위각 (0~360°)
    
    override init() {
        super.init()
        setupMotion()
        setupLocation()
    }
    
    // MARK: - Motion
    private func setupMotion() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: .main) { data, _ in
                guard let data = data else { return }
                self.accel = (data.acceleration.x,
                              data.acceleration.y,
                              data.acceleration.z)
            }
        }
        
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates(to: .main) { data, _ in
                guard let data = data else { return }
                self.gyro = (data.rotationRate.x,
                             data.rotationRate.y,
                             data.rotationRate.z)
            }
        }
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main) { data, _ in
                guard let data = data else { return }
                self.roll = data.attitude.roll
                self.pitch = data.attitude.pitch
                self.yaw = data.attitude.yaw
            }
        }
    }
    
    // MARK: - Compass
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.heading = newHeading.trueHeading
    }
}
