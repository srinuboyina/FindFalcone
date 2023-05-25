//
//  PlannetViewModel.swift
//  FindFalcone
//
//  Created by apple on 21/05/23.
//

import Foundation

class PlanetViewModel: Hashable {
    var id = UUID()
    static func == (lhs: PlanetViewModel, rhs: PlanetViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    var plannet: Planet!
    var isHighlighted: Bool = false
    var vehicleImageName: String = ""
    
    init(plannet: Planet!) {
        self.plannet = plannet
        isHighlighted = false
    }
    
    var name: String {
        return plannet.name
    }
    
    var distance: Double {
        return plannet.distance
    }
    
    func hash(into hasher: inout Hasher) {
      // 2
      hasher.combine(id)
    }
}
