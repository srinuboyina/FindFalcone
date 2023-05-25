//
//  Vehicle.swift
//  FindFalcone
//
//  Created by apple on 20/05/23.
//

import Foundation

struct Vehicle: Decodable, Hashable {
    var name: String
    var total_no: Int
    var max_distance: Double
    var speed: Double
}
