//
//  FalconeViewModel.swift
//  FindFalcone
//
//  Created by apple on 20/05/23.
//

import Foundation
import Combine

protocol FalconViewProtocol: AnyObject {
    func falconFound(title: String, message: String, foundStatus: FalconeResultStatus)
}

protocol FalconeViewModelProtocol {
    var view: FalconViewProtocol? {get set}
    var plannets: [PlanetViewModel] {get set}
    var vehicles: [VehicleViewModel] {get set}
    var service: FalconeServiceProtocol! {get set}
    func getPlannets()
    func getVehicles()
    func findFalcone()
}

class FalconeViewModel: FalconeViewModelProtocol  {
    
    weak var view: FalconViewProtocol?
    @Published var plannets: [PlanetViewModel] = []
    @Published var vehicles: [VehicleViewModel] = []
    var canellables: Set<AnyCancellable> = []
    
    var service: FalconeServiceProtocol!
    
    init(view: FalconViewProtocol, service: FalconeServiceProtocol = FalconeService()){
        self.view = view
        self.service = service
        getPlannets()
        getVehicles()
    }
    
    init(service: FalconeServiceProtocol = FalconeService()) {
        self.service = service
        getPlannets()
        getVehicles()
    }
    
    func getPlannets() {
        service.getPlannets()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished: break
                case .failure(let error): self?.handleError(error: error)
                }
            }) { [weak self] (planets) in
                
                guard let `self` = self else {
                    return
                }
                
                self.plannets = planets.map({return PlanetViewModel(plannet: $0)})
            }
            .store(in: &canellables)
    }
    
    func getVehicles() {
        service.getVehicles()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished: break
                case .failure(let error): self?.handleError(error: error)
                }
            }) { [weak self] (vehicles) in
                
                guard let `self` = self else {
                    return
                }
                
                self.vehicles = vehicles.map({return VehicleViewModel(vehicle: $0)})
            }
            .store(in: &canellables)
    }

    func findFalcone() {
        var plannetsAndVehiclesDictionary: [String: Any] = [:]
        let selectedPlannets = self.plannets.filter({ plannet in
            return !plannet.vehicleImageName.isEmpty
        })
        if selectedPlannets.count < 4 {
            let touple = getMessage(foundStatus: .insufficientPlanets, planet: nil)
            self.view?.falconFound(title: touple.0, message: touple.1, foundStatus: .insufficientPlanets)
            return
        }
        plannetsAndVehiclesDictionary["planet_names"] = selectedPlannets.map({$0.name})
        plannetsAndVehiclesDictionary["vehicle_names"] = vehicles.filter({$0.isSelected}).map({$0.name})
        service.getToken()
            .compactMap({$0["token"]})
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished: break
                case .failure(let error): self?.handleError(error: error)
                }
            }, receiveValue: {  [weak self] token in
                plannetsAndVehiclesDictionary["token"] = token
                self?.findFalcone(params: plannetsAndVehiclesDictionary)
            })
            .store(in: &canellables)
    }
    
    private func findFalcone(params: [String: Any]) {
        self.service.findFalcone(params: params)
            .sink(receiveCompletion: {[weak self] result in
                switch result {
                case .finished: break
                case .failure(let error): self?.handleError(error: error)
                }
                
            }, receiveValue: { [weak self] result in
                if let status = result["status"], status == "success",
                    let planet = result["planet_name"],
                    let touple = self?.getMessage(foundStatus: .found, planet: planet) {
                    self?.view?.falconFound(title: touple.0, message: touple.1, foundStatus: .found)
                } else {
                    if let touple = self?.getMessage(foundStatus: .notFound, planet: nil) {
                        self?.view?.falconFound(title: touple.0, message: touple.1, foundStatus: .notFound)
                    }
                }
            })
            .store(in: &canellables)
    }
    
    func getMessage(foundStatus: FalconeResultStatus, planet: String?) -> (String, String) {
        var title = "Congratulations"
        var message = "Falcone found"
        switch foundStatus {
        case .insufficientPlanets:
            title = "OOPS!"
            message = "Select at least 4 planets"
        case .notFound:
            title = "OOPS!"
            message = "Better luck next time"
        case .found:
            title = "Congratulations"
            message = "Falcone found at \(String(describing: planet!))"
        case .none:
            break
        }
        return (title, message)
    }
    
    func handleError(error: Error) {
        // handle the error here
    }
}
