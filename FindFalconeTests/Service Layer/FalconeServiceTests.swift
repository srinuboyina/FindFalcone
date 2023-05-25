//
//  FalconeServiceTests.swift
//  FindFalconeTests
//
//  Created by apple on 21/05/23.
//

import XCTest
import Combine
@testable import FindFalcone

final class FalconeServiceTests: XCTestCase {

    var falconeService: FalconeService!
    var canellables: Set<AnyCancellable> = []
    
    override func setUp() {
        falconeService = FalconeService()
    }

    func testGetPlanets() {
        let expectation = self.expectation(description: "fetch planets")
        falconeService.getPlannets()
            .sink { error in
                
            } receiveValue: { planets in
                expectation.fulfill()
                XCTAssert(planets.count > 0)
            }
            .store(in: &canellables)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetVehicles() {
        let expectation = self.expectation(description: "fetch vehicles")
        falconeService.getVehicles()
            .sink { error in
                
            } receiveValue: { vehicles in
                expectation.fulfill()
                XCTAssert(vehicles.count > 0)
            }
            .store(in: &canellables)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetToken() {
        let expectation = self.expectation(description: "fetch token")
        falconeService.getToken()
            .compactMap({$0["token"]})
            .sink { error in
                
            } receiveValue: { token in
                expectation.fulfill()
                XCTAssert(token.count > 0)
            }
            .store(in: &canellables)
        waitForExpectations(timeout: 2, handler: nil)
    }
}
