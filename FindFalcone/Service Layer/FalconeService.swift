//
//  FalconeService.swift
//  FindFalcone
//
//  Created by apple on 21/05/23.
//

import Foundation
import Combine

protocol FalconeServiceProtocol {
    func getPlannets() -> AnyPublisher<[Planet], Error>
    func getVehicles() -> AnyPublisher<[Vehicle], Error>
    func getToken() -> AnyPublisher<[String: String], Error>
    func findFalcone(params: [String: Any]) -> AnyPublisher<[String: String], Error>
}

class FalconeService: FalconeServiceProtocol {
    
    var network: Network!
    
    init(network: Network = NetworkManager()) {
        self.network = network
    }
    
    func getPlannets() -> AnyPublisher<[Planet], Error> {
        guard let url = URL(string: Constants.ApiConstant.plannets) else {
            return Fail(error: APIFailureCondition.invalidURL).eraseToAnyPublisher()
        }
        return network.fetchApiData(url: url)
                        .map(\.value)
                        .eraseToAnyPublisher()
    }
    
    func getVehicles() -> AnyPublisher<[Vehicle], Error> {
        guard let url = URL(string: Constants.ApiConstant.vehicles) else {
            return Fail(error: APIFailureCondition.invalidURL).eraseToAnyPublisher()
        }
        return network.fetchApiData(url: url)
                        .map(\.value)
                        .eraseToAnyPublisher()
    }
    
    func getToken() -> AnyPublisher<[String: String], Error> {
        guard let url = URL(string: Constants.ApiConstant.token) else {
            return Fail(error: APIFailureCondition.invalidURL).eraseToAnyPublisher()
        }
        return network.requestWithParams(url: url, params: [:])
                        .eraseToAnyPublisher()
    }
    
    func findFalcone(params: [String: Any]) -> AnyPublisher<[String: String], Error> {
        guard let url = URL(string: Constants.ApiConstant.findFalcone) else {
            return Fail(error: APIFailureCondition.invalidURL).eraseToAnyPublisher()
        }
        return network.requestWithParams(url: url, params: params)
                        .eraseToAnyPublisher()
    }
    
}
