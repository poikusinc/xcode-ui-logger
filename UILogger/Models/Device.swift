//
//  Device.swift
//  UILogger
//
//  Created by Ömer Hamid Kamışlı on 4/23/23.
//

import Foundation

struct Device: Hashable, Codable, Equatable, Identifiable {
    let deviceID: String
    let name: String
    let model: String
    let localizedModel: String
    let systemName: String
    let systemVersion: String
    let isSimulator: String
    let deviceType: String
    
    var id: String {
        return deviceID
    }
}


