//
//  PlannetCell.swift
//  FindFalcone
//
//  Created by apple on 21/05/23.
//

import UIKit

protocol PlannetCellDelegate: AnyObject {
    func imageTapped(vehicleName: String, plannetImageName: String)
}

class PlanetCell: UICollectionViewCell {
    
    @IBOutlet weak var plannetImage: UIImageView!
    @IBOutlet weak var vehicleImage: UIImageView!
    var vehicleImageName: String = ""
    var plannetImageName: String = ""
    
    weak var delegate:  PlannetCellDelegate?
    
    func setPlannetData(plannet: PlanetViewModel){
        plannetImage.image = UIImage(named: plannet.plannet.name.lowercased())
        self.vehicleImageName = plannet.vehicleImageName
        let vImage = UIImage(named: plannet.vehicleImageName.lowercased())
        vehicleImage.image = vImage
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(vehicleImageTapped(gesture:)))
        vehicleImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func vehicleImageTapped(gesture: UIGestureRecognizer) {
        if vehicleImage.image != nil {
            vehicleImage.image = nil
            delegate?.imageTapped(vehicleName: vehicleImageName, plannetImageName: plannetImageName)
        }
    }
 
}
