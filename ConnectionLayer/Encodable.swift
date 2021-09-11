//
//  Encodable.swift
//  ConnectionLayer
//
//  Created by Miguel Mexicano Herrera on 17/11/20.
//

import Foundation
public extension Encodable {
    /// Convierte a formato JSON String.
    var toJSONString: String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try encoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
    /// Convierte un objecto a Data.
    var toData: Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try encoder.encode(self)
            return jsonData
        } catch {
            return nil
        }
    }
}
