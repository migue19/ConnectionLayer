//
//  ConnectionLayerEntity.swift
//  ConnectionLayer
//
//  Created by Miguel Mexicano Herrera on 01/11/20.
//

import Foundation

public enum HTTPMethod: String {
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case trace = "TRACE"
}
public enum ConnectionLayerError: String, Error {
    /// La url esta vacía.
    case missingURL
    /// Fallo la codificación de parametros.
    case encodingFailed
    /// Encabezados vacios.
    case headersNil
}
