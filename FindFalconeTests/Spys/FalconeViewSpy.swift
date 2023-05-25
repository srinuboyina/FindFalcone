//
//  FalconViewSpy.swift
//  FindFalconeTests
//
//  Created by apple on 21/05/23.
//

import Foundation
@testable import FindFalcone

class FalconeViewSpy: FalconViewProtocol {
    var falconFoundCalled = false
    var falconFoundStatus = FalconeResultStatus.none
    func falconFound(title: String, message: String, foundStatus: FindFalcone.FalconeResultStatus) {
        falconFoundStatus = foundStatus
        falconFoundCalled = true
    }
    
    var plannetsFetchedCalled = false
    func plannetsFetched() {
        plannetsFetchedCalled = true
    }
    
    var vehiclesFetchedCalled = false
    func vehiclesFetched() {
        vehiclesFetchedCalled = true
    }
}
