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
    /// Variable opcional que retorna la estructura Encodable en diccionario
    var toDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap {
            $0 as? [String: Any]
        }
    }
}
struct URLEncoder {
    /// Método que codifica los parámetros de la petición.
    ///
    /// - Parameters:
    ///   - urlRequest: Petición que se enviará al server.
    ///   - parameters: Es el diccionario con todos los parametros enviados al server.
    /// - Throws: Arroja un a excepción de tipo BBDaggerError.
    static func encodeParameters(urlRequest: inout URLRequest, parameters: [String: Any]?) throws {
        if parameters == nil { return }
        guard let url = urlRequest.url, let unwrappedParameters = parameters else { throw ConnectionLayerError.missingURL }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !unwrappedParameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value) in unwrappedParameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
    }
}
