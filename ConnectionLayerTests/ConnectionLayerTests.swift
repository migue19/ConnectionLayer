//
//  ConnectionLayerTests.swift
//  ConnectionLayerTests
//
//  Created by Miguel Mexicano Herrera on 16/10/20.
//

import XCTest
@testable import ConnectionLayer

class ConnectionLayerTests: XCTestCase {
    private var connectionLayer: ConnectionLayer?
    private var expectation: XCTestExpectation!
    private var url: String!
    override func setUp() {
        super.setUp()
        self.connectionLayer = ConnectionLayer(isDebug: true)
        self.url = "https://api.bitso.com/v3/available_books/"
    }
    
    func testConnectionGet() {
        self.expectation = expectation(description: "TestGet")
        self.connectionLayer?.connectionRequest(url: url, method: .get, data: nil, closure: { [weak self] data, error in
            XCTAssertNotNil(data, "El servicio no respondió de manera exitosa")
            self?.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testConnectionGetParams() {
        self.expectation = expectation(description: "TestGetParams")
        self.connectionLayer?.connectionRequest(url: url, method: .get, closure: { [weak self] data, _ in
            XCTAssertNotNil(data, "El servicio no respondió de manera exitosa")
            self?.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }
    
    override func tearDown() {
        super.tearDown()
        self.url = nil
        self.expectation = nil
        self.connectionLayer = nil
    }
}
