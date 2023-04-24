//
//  DeviceLogView.swift
//  UILogger
//
//  Created by Ömer Hamid Kamışlı on 4/23/23.
//

import SwiftUI

struct DeviceLogView: View {
    let device: Device
    @Binding var isSelected: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("ID: \(device.deviceID)")
                Spacer()
            }
            Text("Name: \(device.name)")
            Text("Simulator: \(device.isSimulator)")
            
        }
        .padding(8)
        .background(isSelected ? .orange : .clear)
    }
}

struct DeviceLogView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceLogView(device: Device(deviceID: "123456", name: "iPhone 14", model: "iPhone 14", localizedModel: "iPhone 14", systemName: "iPhone 14", systemVersion: "iPhone 14", isSimulator: "false", deviceType: "iPhone 14"), isSelected: .constant(false))
    }
}
