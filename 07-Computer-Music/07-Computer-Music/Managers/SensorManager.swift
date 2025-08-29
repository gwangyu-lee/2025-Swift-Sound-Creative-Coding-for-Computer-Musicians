//
//  SensorManager.swift
//  07
//
//  Created by Gwangyu Lee on 8/19/25.
//
import SwiftUI
import CoreMotion
import CoreLocation

class SensorManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // Motion properties
    private let motionManager = CMMotionManager()
    @Published var accel: (x: Double, y: Double, z: Double) = (0,0,0)
    @Published var gyro: (x: Double, y: Double, z: Double) = (0,0,0)
    
    @Published var quaternion: (x: Double, y: Double, z: Double, w: Double) = (0,0,0,0)
    @Published var roll: Double = 0  // rad 단위
    @Published var pitch: Double = 0
    @Published var yaw: Double = 0
    
    // Location & compass properties
    private let locationManager = CLLocationManager()
    @Published var heading: Double = 0
    
    override init() {
        super.init()
        setupMotion()
        setupLocation()
    }
    
    // MARK: - Motion setup
    private func setupMotion() {
        // Accelerometer
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: .main) { data, _ in
                guard let data = data else { return }
                self.accel = (data.acceleration.x, data.acceleration.y, data.acceleration.z)
                print("Accelerometer:", data.acceleration)
            }
        }
        
        // Quaternion to 360
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main) { data, _ in
                guard let data = data else { return }
                let q = data.attitude.quaternion
                self.quaternion = (q.x, q.y, q.z, q.w)
                self.roll = data.attitude.roll
                self.pitch = data.attitude.pitch
                self.yaw = data.attitude.yaw
            }
        }
        
        // Gyro
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates(to: .main) { data, _ in
                guard let data = data else { return }
                self.gyro = (data.rotationRate.x, data.rotationRate.y, data.rotationRate.z)
                print("Gyro:", data.rotationRate)
            }
        }
    }
    
    // MARK: - Location setup
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.heading = newHeading.trueHeading
        print("Heading:", newHeading.trueHeading)
    }
}
