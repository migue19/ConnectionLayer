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
    override func setUp() {
        super.setUp()
        self.connectionLayer = ConnectionLayer(isDebug: false)
    }
    
    func testConnectionGet() {
        let url = "https://api.bitso.com/v3/available_books/"
        self.expectation = expectation(description: "TestGet")
        self.connectionLayer?.connectionRequest(url: url, method: .get, headers: [:], data: nil, closure: { [weak self] data, error in
            XCTAssertNotNil(data, "El servicio no respondió de manera exitosa")
            self?.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }
    
    override func tearDown() {
        super.tearDown()
        self.expectation = nil
        self.connectionLayer = nil
    }
}
