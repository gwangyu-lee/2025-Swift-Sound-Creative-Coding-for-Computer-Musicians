//
//  GyroView.swift
//  07
//
//  Created by Gwangyu Lee on 8/19/25.
//


import SwiftUI

struct GyroView: View {
    @ObservedObject var sensorManager: SensorManager

    var body: some View {
        VStack {
            Text("Gyroscope")
            Text("x: \(sensorManager.gyro.x, specifier: "%.2f")")
            Text("y: \(sensorManager.gyro.y, specifier: "%.2f")")
            Text("z: \(sensorManager.gyro.z, specifier: "%.2f")")
        }
    }
}

#Preview {
    @Previewable @StateObject var sensorManager = SensorManager()
    
    GyroView(sensorManager: sensorManager)
}
