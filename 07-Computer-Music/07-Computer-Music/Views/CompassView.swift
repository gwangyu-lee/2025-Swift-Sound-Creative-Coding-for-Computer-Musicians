//
//  CompassView.swift
//  07
//
//  Created by Gwangyu Lee on 8/19/25.
//

import SwiftUI

struct CompassView: View {
    @ObservedObject var sensorManager: SensorManager

    var body: some View {
        VStack {
            Text("Compass Heading")
            Text("\(sensorManager.heading, specifier: "%.2f")°")
        }
    }
}

#Preview {
    @Previewable @StateObject var sensorManager = SensorManager()
    
    CompassView(sensorManager: sensorManager)
}
