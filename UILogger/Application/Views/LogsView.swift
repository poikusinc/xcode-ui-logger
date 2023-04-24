//
//  LogsView.swift
//  UILogger
//
//  Created by Ömer Hamid Kamışlı on 4/23/23.
//

import SwiftUI

struct LogsView: View {
    @StateObject var store = LogStore.shared
    @State var deviceID = ""
    var body: some View {
        HSplitView {
            Devices
            DeviceLogs
            SystemLogs
        }
        .onChange(of: store.devices) { val in
            if deviceID == "", val.count > 0 {
                deviceID = val.first?.deviceID ?? ""
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
    
    var SystemLogs: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(store.systemLogs) { log in
                    Text(log.log ?? "").padding(16).foregroundColor(.red).background(Color.gray)
                }
                Spacer()
            }
        }.frame(
            minWidth: 300,
            idealWidth: 300,
            maxWidth: 300,
            maxHeight: .infinity
        )
    }
    
    @ViewBuilder
    var DeviceLogs: some View {
        ScrollView {
            VStack {
                ForEach(store.logs[deviceID] ?? []) { log in
                    JSONTreeView(rootNode: log.tree)
                }
            }
        }
        .frame(
           minWidth: 800,
           maxWidth: .infinity,
           maxHeight: .infinity,
           alignment: .leading
        )
        .layoutPriority(1)
    }
    
    var Devices: some View {
        ScrollView {
            VStack {
                ForEach(store.devices) { device in
                    DeviceLogView(device: device, isSelected: device.deviceID == deviceID ? .constant(true) : .constant(false)).onTapGesture {
                        deviceID = device.deviceID
                    }
                }
                Spacer()
            }
        }.frame(
            minWidth: 300,
            idealWidth: 300,
            maxWidth: 300,
            maxHeight: .infinity
        )
    }
}

struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView()
    }
}

