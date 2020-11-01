//
//  ConnectionLayer.swift
//  ConnectionLayer
//
//  Created by Miguel Mexicano Herrera on 16/10/20.
//

import Foundation

public class ConnectionLayer {
    let time: Int
    
    public init() {
        self.time = 180
    }
    public init(time: Int) {
        self.time = time
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
            print(jsonObject)
        } catch {
            print(error)
        }
    }
    
    public func conneccionRequest(url: String, method: HTTPMethod, headers: [String: String], parameters: [String: Any]?, closure: @escaping (Data?,String?) -> Void) {
        guard  let request = buildRequest(url: url, method: method, headers: headers, parameters: parameters) else {
            return
        }
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
                print("Servicio exitoso")
                break
            case 404:
                closure(nil,"Servicio no Encontrado")
                print("Servicio no Encontrado")
                break
            case 500:
                closure(nil,"Error en el Servicio")
                break
            default:
                closure(nil,"el servicio regreso un codigo \(httpResponse.statusCode)")
                print("el servicio regreso un codigo \(httpResponse.statusCode)")
                break
            }
        }.resume()
    }
    
    private func buildRequest(url:  String, method: HTTPMethod, headers: [String: String], parameters: [String: Any]?) -> URLRequest? {
        guard let url = URL(string: url) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let param = parameters {
            do{
                let httpBody = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
                request.httpBody = httpBody
            }catch {
                print(error)
            }
        }
        return request
    }
    
}
