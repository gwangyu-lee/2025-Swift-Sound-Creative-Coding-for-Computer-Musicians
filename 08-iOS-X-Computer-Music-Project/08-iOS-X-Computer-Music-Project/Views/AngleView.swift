//
//  AngleView.swift
//  07
//
//  Created by Gwangyu Lee on 8/19/25.
//

import SwiftUI

struct AngleView: View {
    @ObservedObject var sensorManager: SensorManager

    func radToDeg(_ radians: Double) -> Double {
        return radians * 180 / .pi
    }

    var body: some View {
        VStack {
            Text("Quaternion")
            Text("x: \(sensorManager.quaternion.x, specifier: "%.2f")")
            Text("y: \(sensorManager.quaternion.y, specifier: "%.2f")")
            Text("z: \(sensorManager.quaternion.z, specifier: "%.2f")")
            Text("w: \(sensorManager.quaternion.w, specifier: "%.2f")")
            
            Divider()
            
            Text("Angle (degrees)")
            Text("Roll : \(radToDeg(sensorManager.roll), specifier: "%.1f")°")
            Text("Pitch: \(radToDeg(sensorManager.pitch), specifier: "%.1f")°")
            Text("Yaw  : \(radToDeg(sensorManager.yaw), specifier: "%.1f")°")
        }
    }
}

#Preview {
    @Previewable @StateObject var sensorManager = SensorManager()
    
    AngleView(sensorManager: sensorManager)
}
