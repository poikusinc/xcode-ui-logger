//
//  LogStore.swift
//  UILogger
//
//  Created by Ömer Hamid Kamışlı on 4/23/23.
//

import SwiftUI
import Combine

class LogStore: ObservableObject {
    static let shared = LogStore()
    
    @Published var logs: [String:[LogModel]] = [:]
    @Published var systemLogs: [SystemLogModel] = []
    @Published var devices: [Device] = []
    
    func addLog(log: LogModel) {
        guard let deviceID = log.deviceID else {
            addSystemLog(message: "Device ID not found. Log Message: \(String(describing: log.log))", isError: true)
            return
        }
        
        if log.isNewConnection == true {
            addSystemLog(message: "New Connection: \(String(describing: deviceID))")
        }
        logs[deviceID, default: []].insert(log, at: 0)
    }
    
    func addDevice(device: Device) {
        devices.insert(device, at: 0)
    }
    
    func addSystemLog(message: String, isError: Bool = false) {
        systemLogs.insert(SystemLogModel(log: message, isError: isError), at: 0)
    }
}
