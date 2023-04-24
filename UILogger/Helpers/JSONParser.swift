//
//  JSONParser.swift
//  UILogger
//
//  Created by Ömer Hamid Kamışlı on 4/22/23.
//

import Foundation

class JSONParser {
    static let shared = JSONParser()
    
    
    func parse(json: String) -> Any? {
        guard let data = json.data(using: .utf8) else { return nil }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            return jsonObject
        } catch {
            #if DEBUG
            LogStore.shared.addSystemLog(message: "Error parsing JSON: \(error)")
            #endif
            return nil
        }
    }
}
