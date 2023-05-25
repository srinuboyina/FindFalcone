//
//  ViewController.swift
//  FindFalcone
//
//  Created by apple on 20/05/23.
//

import UIKit
import Foundation
import Combine
import SwiftUI

enum Section {
    case planets
    case vehicles
}

class FalconeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: FalconeViewModel!
    var canellables: Set<AnyCancellable> = []
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PlanetViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PlanetViewModel>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Find Falcone"
        registerCells()
        setViewModel()
    }
    
    func setViewModel(viewModel: FalconeViewModel = FalconeViewModel()) {
        self.viewModel = viewModel
        self.viewModel.view = self
        self.viewModel.$plannets.sink { [weak self] _ in
            self?.collectionView.reloadData()
        }
        .store(in: &canellables)
        
        self.viewModel.$vehicles.sink { [weak self] _ in
            self?.collectionView.reloadData()
        }
        .store(in: &canellables)
    }
    
    private func registerCells() {
        collectionView.register(PlanetCell.NIB, forCellWithReuseIdentifier: PlanetCell.ID)
        collectionView.register(VehicleCell.NIB, forCellWithReuseIdentifier: VehicleCell.ID)
    }
    
    @IBAction func findFalcone() {
        viewModel.findFalcone()
    }
}

extension FalconeViewController: FalconViewProtocol {
    func falconFound(title: String, message: String, foundStatus: FalconeResultStatus) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel) { [weak self] action in
            if foundStatus != .insufficientPlanets {
                self?.viewModel.vehicles.forEach { vehicle in
                    vehicle.isSelected = false
                }
                self?.viewModel.plannets.forEach { planet in
                    planet.vehicleImageName = ""
                }
                self?.collectionView.reloadData()
            }
        }
        dialogMessage.addAction(action)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

extension FalconeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.plannets.count
        } else {
            return viewModel.vehicles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let plannetCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlanetCell.ID, for: indexPath) as? PlanetCell
            plannetCell?.delegate = self
            plannetCell?.setPlannetData(plannet: viewModel.plannets[indexPath.row])
            return plannetCell ?? UICollectionViewCell()
        } else {
            let vehicleCell = collectionView.dequeueReusableCell(withReuseIdentifier: VehicleCell.ID, for: indexPath) as? VehicleCell
            vehicleCell?.setVehicleData(vehicle: viewModel.vehicles[indexPath.row])
            return vehicleCell ?? UICollectionViewCell()
        }
    }
}

extension FalconeViewController: PlannetCellDelegate {
    func imageTapped(vehicleName: String, plannetImageName: String) {
        if let index = viewModel.vehicles.firstIndex(where: { vehicle in
            return vehicle.name == vehicleName
        }) {
            viewModel.vehicles[index].isSelected = false
            collectionView.reloadSections(IndexSet(integer: 1))
        }
        
        if let index = viewModel.plannets.firstIndex(where: { plannet in
            return plannet.name == plannetImageName
        }) {
            viewModel.plannets[index].vehicleImageName = ""
        }
    }
}

extension FalconeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 100, height: 100)
        } else {
            return CGSize(width: 90, height: 80)
        }
    }
    
}


