//
//  ViewController + DragDropDelegate.swift
//  FindFalcone
//
//  Created by apple on 21/05/23.
//

import UIKit

// MARK: - UICollectionViewDragDelegate Methods
extension FalconeViewController: UICollectionViewDragDelegate {

    // Get dragItem from the indexpath
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        print("itemsForBeginning")
        if indexPath.section == 1 && indexPath.item < viewModel.vehicles.count {
            if !viewModel.vehicles[indexPath.item].isSelected {
                let vehicleName = String(viewModel.vehicles[indexPath.item].name)
                let itemProvider = NSItemProvider(object: vehicleName as NSString)
                let dragItem = UIDragItem(itemProvider: itemProvider)
                dragItem.localObject = vehicleName
                return [dragItem]
            }
        }
        return []
    }

    // To only select needed view as preview instead of whole cell
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        print("dragPreviewParametersForItemAt")
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VehicleCell.ID, for: indexPath) as! VehicleCell
            let previewParameters = UIDragPreviewParameters()
            previewParameters.visiblePath = UIBezierPath(roundedRect: CGRect(x: cell.vehicleImage.frame.minX, y: cell.vehicleImage.frame.minY, width: 30, height: 30), cornerRadius: 20)
            return previewParameters
        }
        return nil
    }
}


// MARK: - UICollectionViewDropDelegate Methods
extension FalconeViewController: UICollectionViewDropDelegate {

    // Get the position of the dragged data over the collection view changed
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        print("dropSessionDidUpdate")
        if let indexPath = destinationIndexPath {
            viewModel.plannets.indices.forEach { viewModel.plannets[$0].isHighlighted = false }
            viewModel.plannets[indexPath.item].isHighlighted = true
            collectionView.reloadData()
        }
        return UICollectionViewDropProposal(operation: .copy)
    }

    // Update collectionView after ending the drop operation
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        print("dropSessionDidEnd")
        viewModel.plannets.indices.forEach { viewModel.plannets[$0].isHighlighted = false }
        collectionView.reloadData()
    }

    // Called when the user initiates the drop operation
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print("coordinator")
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }

        if destinationIndexPath.section == 0 {
            if coordinator.proposal.operation == .copy {
                copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            }
        }
    }

    // Actual logic which perform after drop the view
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        print("copyItems")
        collectionView.performBatchUpdates {
            for (_, item) in coordinator.items.enumerated() {
                if destinationIndexPath.section == 0 {
                    let vehicleName = item.dragItem.localObject as? String
                    if let vehicleName = vehicleName {
                        if let index = viewModel.vehicles.firstIndex(where: { vehicle in
                            return vehicle.name == vehicleName
                        }) {
                            if viewModel.vehicles[index].max_distance < viewModel.plannets[destinationIndexPath.item].distance {
                                return
                            }
                            viewModel.vehicles[index].isSelected = true
                        }
                        viewModel.plannets[destinationIndexPath.item].vehicleImageName = vehicleName
                        UIView.performWithoutAnimation {
                            collectionView.reloadSections(IndexSet(integer: 0))
                        }
                    }
                }
            }
        }
    }
}
