//
//  ConnectionLayer.swift
//  ConnectionLayer
//
//  Created by Miguel Mexicano Herrera on 16/10/20.
//

import Foundation

public class ConnectionLayer {
    let time: Int
    let isDebug: Bool
    
    public init() {
        self.time = 180
        self.isDebug = true
    }
    public init(time: Int = 180, isDebug: Bool = true) {
        self.time = time
        self.isDebug = isDebug
    }
    
    private func getSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(time)
        configuration.timeoutIntervalForResource = TimeInterval(time)
        return configuration
    }
    
    private func printResultHttpConnection(data: Data?){
        guard let data = data else {
            return
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            printEvent(event: jsonObject)
        } catch {
            printEvent(event: error)
        }
    }
    
    public func connectionRequest(url: String, method: HTTPMethod, headers: HTTPHeaders? = nil, parameters: [String: Any]? = nil, closure: @escaping (Data?,String?) -> Void) {
        guard  let request = createRequest(url: url, method: method, headers: headers, parameters: parameters) else {
            return
        }
        startRequest(request: request) { (data, error) in
            closure(data, error)
        }
    }
    public func connectionRequest(url: String, method: HTTPMethod, headers: HTTPHeaders? = nil, data: Data?, closure: @escaping (Data?,String?) -> Void) {
        guard  let request = createRequest(url: url, method: method, headers: headers, parameters: data) else {
            return
        }
        startRequest(request: request) { (data, error) in
            closure(data, error)
        }
    }
    
    private func startRequest(request: URLRequest, closure: @escaping (Data?,String?) -> Void) {
        let configuration = getSessionConfiguration()
        let session = URLSession(configuration: configuration)
        session.dataTask(with: request) { (data, response, error) in
            if(error != nil){
                closure(nil,"Error de conexion")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else{
                return
            }
            self.printResultHttpConnection(data: data)
            switch(httpResponse.statusCode){
            case 200:
                closure(data,nil)
                self.printEvent(event: "Servicio exitoso")
                break
            case 404:
                closure(nil,"Servicio no Encontrado")
                self.printEvent(event: "Servicio no Encontrado")
                break
            case 500:
                closure(nil,"Error en el Servicio")
                self.printEvent(event: "Error en el Servicio")
                break
            default:
                closure(nil,"el servicio regreso un codigo \(httpResponse.statusCode)")
                self.printEvent(event: "el servicio regreso un codigo \(httpResponse.statusCode)")
                break
            }
        }.resume()
    }
    
    private func printEvent(event: Any) {
        if isDebug {
            print(event)
        }
    }
    
    private func createRequest(url:  String, method: HTTPMethod, headers: HTTPHeaders?, parameters: Data?) -> URLRequest? {
        guard let url = URL(string: url) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers?.dictionary
        request.httpBody = parameters
        return request
    }
    
    private func createRequest(url:  String, method: HTTPMethod, headers: HTTPHeaders?, parameters: [String: Any]?) -> URLRequest? {
        guard let url = URL(string: url) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers?.dictionary
        if let param = parameters {
            do {
                let httpBody = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
                request.httpBody = httpBody
            } catch {
                printEvent(event: error)
            }
        }
        return request
    }
    
}
