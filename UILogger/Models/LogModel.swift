//
//  LogModel.swift
//  UILogger
//
//  Created by Ömer Hamid Kamışlı on 4/23/23.
//

import Foundation

struct LogModel: Identifiable, Equatable, Codable {
    var id: UUID = UUID()
    let log: String?
    let deviceID: String?
    let isNewConnection: Bool?
    
    enum CodingKeys: CodingKey {
        case log
        case deviceID
        case isNewConnection
    }
    
    init(log: String?, deviceID: String?, isNewConnection: Bool?) {
        self.log = log
        self.deviceID = deviceID
        self.isNewConnection = isNewConnection
    }
    
    var tree: TreeNode {
        if let jsonObject = JSONParser.shared.parse(json: log ?? "") {
            return TreeNode(key: "root", value: jsonObject)
        } else {
            return TreeNode(key: "root", value: log ?? "")
        }
    }
}



struct SystemLogModel: Identifiable, Equatable {
    var id: UUID = UUID()
    let log: String?
    var isError: Bool
}
