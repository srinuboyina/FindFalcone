//
//  VehicleCell.swift
//  FindFalcone
//
//  Created by apple on 21/05/23.
//

import UIKit

class VehicleCell: UICollectionViewCell {
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    func setVehicleData(vehicle: VehicleViewModel) {
        self.vehicleImage.image = UIImage(named: vehicle.name.lowercased())
        self.nameLabel.text = vehicle.name
        self.speedLabel.text = String(vehicle.vehicle.max_distance)
        if vehicle.isSelected {
            self.vehicleImage.layer.opacity = 0.5
        } else {
            self.vehicleImage.layer.opacity = 1
        }
    }
}
