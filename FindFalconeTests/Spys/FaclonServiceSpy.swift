//
//  FaclonServiceSpy.swift
//  FindFalconeTests
//
//  Created by apple on 21/05/23.
//

import Foundation
import Combine
@testable import FindFalcone

class FalconeServiceSpy: FalconeServiceProtocol {

    var getPlannetsCalled = false
    func getPlannets() -> AnyPublisher<[Planet], Error> {
        getPlannetsCalled  = true
        return  Future<[Planet],Error> { promise in
            
        }.eraseToAnyPublisher()
    }
    
    var getVehiclesCalled = false
    func getVehicles() -> AnyPublisher<[Vehicle], Error> {
        getVehiclesCalled = true
        return  Future<[Vehicle],Error> { promise in
                   
        }.eraseToAnyPublisher()
    }
    
    var getTokenCalled = false
    func getToken() -> AnyPublisher<[String: String], Error>{
        getTokenCalled = true
        return Future<[String: String], Error> { promise in
            promise(.success(["token": "token"]))
        }.eraseToAnyPublisher()
    }
    
    var findFalconeCalled = false
    var findFalconeResponseDict = ["status": "success", "planet_name": "Jebing"]
    func findFalcone(params: [String: Any]) -> AnyPublisher<[String: String], Error> {
        findFalconeCalled = true
        return Future<[String: String], Error> { promise in
            promise(.success(self.findFalconeResponseDict))
        }.eraseToAnyPublisher()
    }
    
}
