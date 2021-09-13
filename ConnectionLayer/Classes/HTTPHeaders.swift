//
//  HTTPHeaders.swift
//  ConnectionLayer
//
//  Created by Miguel Mexicano Herrera on 13/09/21.
//

import Foundation
public struct HTTPHeaders {
    private var headers: [HTTPHeader]
    public init() {
        self.headers = []
    }
    public init(_ headers: [HTTPHeader]) {
        self.headers = headers
    }
    public static func authorization(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: "Authorization", value: value)
    }
    public static func authorization(bearerToken: String) -> HTTPHeader {
        authorization("Bearer \(bearerToken)")
    }
    public static func authorization(username: String, password: String) -> HTTPHeader {
        let credential = Data("\(username):\(password)".utf8).base64EncodedString()
        return authorization("Basic \(credential)")
    }
    public static func contentType(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: "Content-Type", value: value)
    }
    public var dictionary: [String: String] {
        let namesAndValues = headers.map { ($0.name, $0.value) }
        return Dictionary(namesAndValues, uniquingKeysWith: { _, last in last })
    }
    public static func accept(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Accept", value: value)
    }
}
extension HTTPHeaders {
    public static let applicationJson: String = "application/json"
}
extension HTTPHeaders {
    public static var contentTypeJson: HTTPHeader {
        return contentType(applicationJson)
    }
    public static var acceptJson: HTTPHeader {
        return accept(applicationJson)
    }
}
/// A representation of a single HTTP header's name / value pair.
public struct HTTPHeader: Hashable {
    /// Name of the header.
    public let name: String
    /// Value of the header.
    public let value: String
    /// Creates an instance from the given `name` and `value`.
    ///
    /// - Parameters:
    ///   - name:  The name of the header.
    ///   - value: The value of the header.
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
