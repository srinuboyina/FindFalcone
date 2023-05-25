//
//  UICollectionViewCell + Extension.swift
//  FindFalcone
//
//  Created by apple on 21/05/23.
//

import UIKit

extension UICollectionViewCell {
    class var ID: String { String(describing: Self.self) }
    class var NIB: UINib { .init(nibName: String(describing: Self.self), bundle: .main) }
}
