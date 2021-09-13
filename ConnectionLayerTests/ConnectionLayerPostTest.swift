//
//  ConnectionLayerPostTest.swift
//  ConnectionLayerTests
//
//  Created by Miguel Mexicano Herrera on 12/09/21.
//

import XCTest
@testable import ConnectionLayer
class ConnectionLayerPostTest: XCTestCase {
    private var connectionLayer: ConnectionLayer?
    private var expectation: XCTestExpectation!
    private var url: String!
    private var token: String!
    override func setUp() {
        super.setUp()
        self.connectionLayer = ConnectionLayer(isDebug: true)
        self.url = "https://api.themoviedb.org/4/auth/request_token"
        self.token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3YmNiMDBiODI4YzY3OGJhYjdjNjgxZmIzM2E0MzJhYyIsInN1YiI6IjYwZjZmZTdlOGQxYjhlMDA1ZWI4NDRkMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.teYAYq8_Kou-4C15kSwIiIZhZZYBsoDgUzjFWQdmucI"
    }
    
    func testConnectionPost() {
        self.expectation = expectation(description: "TestPost")
        guard let token = token else {
            return
        }
        let headers: HTTPHeaders = HTTPHeaders([
                                                HTTPHeaders.authorization(bearerToken: token),
                                                HTTPHeaders.contentTypeJson,
                                                HTTPHeaders.acceptJson
        ])
        self.connectionLayer?.connectionRequest(url: url, method: .post, headers: headers, data: nil, closure: { [weak self] data, error in
            XCTAssertNotNil(data, "El servicio no respondió de manera exitosa")
            self?.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }
    
    override func tearDown() {
        super.tearDown()
        self.token = nil
        self.url = nil
        self.expectation = nil
        self.connectionLayer = nil
    }
}
