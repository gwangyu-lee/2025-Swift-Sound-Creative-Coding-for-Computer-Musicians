//
//  AccelView.swift
//  07
//
//  Created by Gwangyu Lee on 8/19/25.
//

import SwiftUI

struct AccelView: View {
    @ObservedObject var sensorManager: SensorManager
    
    var body: some View {
        VStack {
            Text("Accelerometer")
            Text("x: \(sensorManager.accel.x, specifier: "%.2f")")
            Text("y: \(sensorManager.accel.y, specifier: "%.2f")")
            Text("z: \(sensorManager.accel.z, specifier: "%.2f")")
        }
    }
}

#Preview {
    @Previewable @StateObject var sensorManager = SensorManager()
    
    AccelView(sensorManager: sensorManager)
}
