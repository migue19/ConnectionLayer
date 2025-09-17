//
//  ConnectionLayer.swift
//  ConnectionLayer
//
//  Created by Miguel Mexicano Herrera on 16/10/20.
//
import Foundation

public final class ConnectionLayer {
    private let timeout: TimeInterval 
    private let isDebug: Bool
    private let session: URLSession

    // Mantengo tu init y agrego la sesión reutilizable
    public init() {
        self.timeout = 180
        self.isDebug = true
        self.session = ConnectionLayer.makeSession(timeout: 180)
    }

    public init(timeOut: Int = 180, isDebug: Bool = true, session: URLSession? = nil) {
        self.timeout = TimeInterval(timeOut)
        self.isDebug = isDebug
        self.session = session ?? ConnectionLayer.makeSession(timeout: TimeInterval(timeOut))
    }

    private static func makeSession(timeout: TimeInterval) -> URLSession {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = timeout
        cfg.timeoutIntervalForResource = timeout
        cfg.waitsForConnectivity = true
        if #available(iOS 13.0, *) {
            cfg.allowsConstrainedNetworkAccess = true
        } else {
            // Fallback on earlier versions
        }
        return URLSession(configuration: cfg)
    }

    // MARK: - Public API (compatibles)

    public func connectionRequest(
        url: String,
        method: HTTPMethod,
        headers: HTTPHeaders? = nil,
        parameters: [String: Any]? = nil,
        closure: @escaping (Data?, Error?) -> Void
    ) {
        guard let request = createRequest(url: url, method: method, headers: headers, jsonParameters: parameters) else {
            closure(nil, URLError(.badURL))
            return
        }
        startRequest(request: request) { data, error, _ in
            closure(data, error)
        }
    }

    public func connectionRequest(
        url: String,
        method: HTTPMethod,
        headers: HTTPHeaders? = nil,
        data: Data?,
        closure: @escaping (Data?, Error?, Int?) -> Void
    ) {
        guard let request = createRequest(url: url, method: method, headers: headers, bodyData: data) else {
            closure(nil, URLError(.badURL), nil)
            return
        }
        startRequest(request: request) { data, error, status in
            closure(data, error, status)
        }
    }

    // MARK: - Core

    private func startRequest(
        request: URLRequest,
        closure: @escaping (Data?, Error?, Int?) -> Void
    ) {
        debugLog("URL: \(request.url?.absoluteString ?? "No URL")")
        debugLog("Method: \(request.httpMethod ?? "No Method")")
        debugLog("Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let body = request.httpBody {
            if let json = try? JSONSerialization.jsonObject(with: body) {
                debugLog("Body(JSON): \(json)")
            } else if let txt = String(data: body, encoding: .utf8) {
                debugLog("Body(TEXT): \(txt.prefix(1_000))")
            } else {
                debugLog("Body: <\(body.count) bytes>")
            }
        } else {
            debugLog("Body: No Body")
        }

        let task = session.dataTask(with: request) { data, response, error in
            // Error de transporte (red, cancelación, etc.)
            if let error = error {
                self.debugLog("Transport error: \(error)")
                closure(nil, error, (response as? HTTPURLResponse)?.statusCode)
                return
            }

            guard let http = response as? HTTPURLResponse else {
                self.debugLog("No HTTPURLResponse")
                closure(nil, URLError(.badServerResponse), nil)
                return
            }

            let status = http.statusCode
            self.debugLog("Status Code: \(status)")

            // Log de respuesta (solo intenta JSON si parece JSON)
            if let data = data {
                if #available(iOS 13.0, *) {
                    if let type = http.value(forHTTPHeaderField: "Content-Type"),
                       type.lowercased().contains("application/json"),
                       let json = try? JSONSerialization.jsonObject(with: data) {
                        self.debugLog("Response(JSON): \(json)")
                    } else {
                        self.debugLog("Response(Size): \(data.count) bytes")
                    }
                } else {
                    // Fallback on earlier versions
                }
            } else {
                self.debugLog("Response: <no data>")
            }

            switch status {
            case 200...299:
                // 204: no content -> data suele ser nil; lo pasamos tal cual
                closure(data, nil, status)
                self.debugLog("Servicio exitoso")
            case 400...499:
                let err = NSError(domain: "HTTPClientError", code: status,
                                  userInfo: [NSLocalizedDescriptionKey: "Cliente: código \(status)"])
                closure(data, err, status)
            case 500...599:
                let err = NSError(domain: "HTTPServerError", code: status,
                                  userInfo: [NSLocalizedDescriptionKey: "Servidor: código \(status)"])
                closure(data, err, status)
            default:
                let err = NSError(domain: "HTTPUnexpectedStatus", code: status,
                                  userInfo: [NSLocalizedDescriptionKey: "Código inesperado \(status)"])
                closure(data, err, status)
            }
        }
        task.resume()
    }

    // MARK: - Request Builders

    // Body binario (evita body si es GET)
    private func createRequest(
        url: String,
        method: HTTPMethod,
        headers: HTTPHeaders?,
        bodyData: Data?
    ) -> URLRequest? {
        guard var req = bareRequest(url: url, method: method, headers: headers) else { return nil }
        if method != .get { req.httpBody = bodyData }
        return req
    }

    // JSON / query params
    private func createRequest(
        url: String,
        method: HTTPMethod,
        headers: HTTPHeaders?,
        jsonParameters: [String: Any]?
    ) -> URLRequest? {
        guard var req = bareRequest(url: url, method: method, headers: headers) else { return nil }
        guard let params = jsonParameters, !params.isEmpty else { return req }

        do {
            if method == .get {
                try encodeRequest(parameters: params, request: &req)
            } else {
                // Content-Type por defecto si el llamador no lo mandó
                var hdrs = req.allHTTPHeaderFields ?? [:]
                if hdrs["Content-Type"] == nil { hdrs["Content-Type"] = "application/json" }
                if hdrs["Accept"] == nil { hdrs["Accept"] = "application/json" }
                req.allHTTPHeaderFields = hdrs

                req.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            }
        } catch {
            debugLog("Encoding error: \(error)")
            return nil
        }
        return req
    }

    private func bareRequest(
        url: String,
        method: HTTPMethod,
        headers: HTTPHeaders?
    ) -> URLRequest? {
        guard let u = URL(string: url) else { return nil }
        var request = URLRequest(url: u)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers?.dictionary
        request.timeoutInterval = timeout
        return request
    }

    // MARK: - Helpers (con tu firma original)

    func encodeRequest(parameters: [String: Any]?, request: inout URLRequest) throws {
        do {
            if let parameters = parameters {
                try URLEncoder.encodeParameters(urlRequest: &request, parameters: parameters)
            }
        } catch {
            throw ConnectionLayerError.encodingFailed
        }
    }

    private func debugLog(_ any: Any) {
        if isDebug { print("[ConnectionLayer] \(any)") }
    }
}

