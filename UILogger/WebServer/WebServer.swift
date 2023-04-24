//
//  WebServer.swift
//  UILogger
//
//  Created by Ömer Hamid Kamışlı on 4/23/23.
//

import Cocoa
import SwiftUI
import Network

class WebSocketServer {
    static let shared = try? WebSocketServer()
    private let listener: NWListener
    private var connections: [UUID: NWConnection] = [:]
    private var port: UInt16 = 8082
    
    private init() throws {
        let parameters = NWParameters.tcp
        parameters.allowLocalEndpointReuse = true
        parameters.acceptLocalOnly = true
        let websocketOptions = NWProtocolWebSocket.Options()
        websocketOptions.autoReplyPing = true
        parameters.defaultProtocolStack.applicationProtocols.insert(websocketOptions, at: 0)

        listener = try NWListener(using: parameters, on: NWEndpoint.Port(rawValue: port)!)
        listener.stateUpdateHandler = self.stateDidChange(to:)
        listener.newConnectionHandler = self.didAccept(nwConnection:)
    }

    public func setPort(port: UInt16) {
        self.port = port
    }
    
    public func start() {
        listener.start(queue: .main)
    }
    
    private func stateDidChange(to newState: NWListener.State) {
        switch newState {
        case .ready:
            LogStore.shared.addSystemLog(message: "WebSocket server is ready")
        case .failed(let error):
            LogStore.shared.addSystemLog(message: "WebSocket server failed with error: \(error)", isError: true)
        default:
            break
        }
    }

    private func didAccept(nwConnection: NWConnection) {
        let id = UUID()
        connections[id] = nwConnection
        nwConnection.stateUpdateHandler = { [weak self] newState in
            self?.connectionStateDidChange(id: id, newState: newState)
        }
        receiveMessage(id: id, connection: nwConnection)
        nwConnection.start(queue: .main)
    }

    private func receiveMessage(id: UUID, connection: NWConnection) {
        connection.receiveMessage { [weak self] (data, context, isComplete, error) in
            self?.didReceiveMessage(id: id, data: data, error: error)
            if connection.state != .cancelled {
                self?.receiveMessage(id: id, connection: connection)
            }
        }
    }


    private func connectionStateDidChange(id: UUID, newState: NWConnection.State) {
        switch newState {
        case .ready:
            LogStore.shared.addSystemLog(message: "Connection \(id) is ready")
        case .failed(let error):
            LogStore.shared.addSystemLog(message: "Connection \(id) failed with error: \(error)", isError: true)
            connections.removeValue(forKey: id)
        case .cancelled:
            LogStore.shared.addSystemLog(message: "Connection \(id) was cancelled")
            connections.removeValue(forKey: id)
        default:
            break
        }
    }


    private func didReceiveMessage(id: UUID, data: Data?, error: NWError?) {
        if case let .posix(code) = error, code.rawValue == 96 {
            // No message available on STREAM, ignore the error
            return
        } else if let error = error {
            LogStore.shared.addSystemLog(message: "Error receiving message: \(error)", isError: true)
            return
        }

        guard let data = data else { return }

        let message = String(data: data, encoding: .utf8) ?? ""
        print(message)
        let decoder = JSONDecoder()

        do {
            let device = try decoder.decode(Device.self, from: data)
            LogStore.shared.addDevice(device: device)
        } catch {
            do {
                let log = try decoder.decode(LogModel.self, from: data)
                LogStore.shared.addLog(log: log)
            } catch {
                debugPrint(error)
                LogStore.shared.addSystemLog(message: "\(error)", isError: true)
            }
        }
    }

}

