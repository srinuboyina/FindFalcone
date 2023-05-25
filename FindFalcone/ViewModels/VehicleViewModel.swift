//
//  VehicleViewModel.swift
//  FindFalcone
//
//  Created by apple on 21/05/23.
//

import Foundation

class VehicleViewModel: Hashable {
    var id = UUID()
    static func == (lhs: VehicleViewModel, rhs: VehicleViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    var vehicle: Vehicle!
    var isSelected: Bool = false
    
    init(vehicle: Vehicle!) {
        self.vehicle = vehicle
    }
    
    var name: String {
        return vehicle.name
    }
    
    var speed: Double {
        return vehicle.speed
    }
    
    var max_distance: Double {
        return vehicle.max_distance
    }
    
    func hash(into hasher: inout Hasher) {
      // 2
      hasher.combine(id)
    }
}
