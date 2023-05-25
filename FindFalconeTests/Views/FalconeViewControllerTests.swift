//
//  FalconeViewControllerTests.swift
//  FindFalconeTests
//
//  Created by apple on 21/05/23.
//

import XCTest
@testable import FindFalcone

final class FalconeViewControllerTests: XCTestCase {
    
    var viewModel: FalconeViewModel!
    var viewSpy: FalconeViewSpy!
    var serviceSpy: FalconeServiceSpy!
    var planetsData: [PlanetViewModel] = []
    var vehicleData: [VehicleViewModel] = []
    
    var viewController: FalconeViewController!

    override func setUp() {
        viewSpy = FalconeViewSpy()
        serviceSpy = FalconeServiceSpy()
        viewModel = FalconeViewModel(view: viewSpy, service: serviceSpy)
        
        let planetViewModel1 = PlanetViewModel(plannet: Planet(name: "Donlon", distance: 100))
        planetViewModel1.vehicleImageName = "Space pod"
        let planetViewModel2 = PlanetViewModel(plannet: Planet(name: "Enchai", distance: 200))
        planetViewModel2.vehicleImageName = "Space rocket"
        let planetViewModel3 = PlanetViewModel(plannet: Planet(name: "Jebing", distance: 300))
        planetViewModel3.vehicleImageName = "Space shuttle"
        let planetViewModel4 = PlanetViewModel(plannet: Planet(name: "Sapir", distance: 400))
        planetViewModel4.vehicleImageName = "Space ship"
        
        planetsData = [planetViewModel1, planetViewModel2, planetViewModel3, planetViewModel4]
        
        let vehicle1 = VehicleViewModel(vehicle: Vehicle(name: "Space pod", total_no: 2, max_distance: 200, speed: 2))
        vehicle1.isSelected = true
        let vehicle2 = VehicleViewModel(vehicle: Vehicle(name: "Space rocket", total_no: 2, max_distance: 200, speed: 2))
        vehicle2.isSelected = true
        let vehicle3 = VehicleViewModel(vehicle: Vehicle(name: "Space shuttle", total_no: 2, max_distance: 200, speed: 2))
        vehicle3.isSelected = true
        let vehicle4 = VehicleViewModel(vehicle: Vehicle(name: "Space ship", total_no: 2, max_distance: 200, speed: 2))
        vehicle4.isSelected = true
        
        vehicleData = [vehicle1, vehicle2, vehicle3, vehicle4]
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        viewController =  storyBoard.instantiateViewController(withIdentifier: "FalconeViewController") as? FalconeViewController
        _ = viewController.view
        viewController.viewModel = viewModel
        XCTAssertNotNil(viewController.collectionView)
        
    }

    func testFindFalcone() {
        viewController.findFalcone()
    }
    
    func testImageTapped() {
        viewController.imageTapped(vehicleName: "Space pod", plannetImageName: "Donlon")
    }
    
    func testFalconFound() {
        viewController.falconFound(title: "Congratulations", message: "Falcone Found", foundStatus: .found)
    }
    
    override func tearDown() {
        viewController = nil
    }
}
