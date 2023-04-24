//
//  TreeNode.swift
//  UILogger
//
//  Created by Ömer Hamid Kamışlı on 4/22/23.
//

import SwiftUI

class TreeNode: ObservableObject, Identifiable {
    var id = UUID()
    var key: String
    var value: Any
    var valueType: ValueType
    var children: [TreeNode]?
    var recivingDate: String
    
    init(key: String, value: Any) {
        self.key = key
        self.value = value
        self.valueType = ValueType(value: value)
        
        if let dictValue = value as? [String: Any] {
            self.children = dictValue.map { TreeNode(key: $0.key, value: $0.value) }
        } else if let arrayValue = value as? [Any] {
            self.children = arrayValue.enumerated().map { TreeNode(key: "Index \($0.offset)", value: $0.element) }
        } else {
            self.children = nil
        }
        recivingDate = Date().formatted()
    }
    
    enum ValueType: String {
        case string = "String"
        case int = "Int"
        case double = "Double"
        case bool = "Bool"
        case dictionary = "Dictionary"
        case array = "Array"
        case null = "Null"
        case unknown = "Unknown"
        
        init(value: Any) {
            switch value {
            case is String:
                self = .string
            case is Bool:
                self = .bool
            case is Int:
                self = .int
            case is Double:
                self = .double
            case is [String: Any]:
                self = .dictionary
            case is [Any]:
                self = .array
            case is NSNull:
                self = .null
            default:
                self = .unknown
            }
        }
        
        var color: Color {
            switch self {
            case .string:
                return Color("String")
            case .int:
                return Color("Int")
            case .double:
                return Color("Double")
            case .bool:
                return Color("Bool")
            case .null:
                return Color("Null")
            default:
                return Color("Default")
            }
        }
    }
    
    var valueDescription: String {
        if valueType == .bool, let boolValue = value as? Bool {
            return boolValue ? "true" : "false"
        }
        if valueType == .null {
            return "Null"
        }
        return String(describing: value)
    }
}
