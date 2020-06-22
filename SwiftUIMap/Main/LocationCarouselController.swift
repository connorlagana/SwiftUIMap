//
//  LocationCarouselController.swift
//  SwiftUIMap
//
//  Created by Connor Lagana on 6/21/20.
//  Copyright © 2020 Connor Lagana. All rights reserved.
//

import Foundation
import UIKit
import LBTATools

class LocationCell: LBTAListCell<String> {
    override func setupViews() {
        backgroundColor = .white
        setupShadow(opacity: 0.2, radius: 5, offset: .zero, color: .black)
        layer.cornerRadius = 5
    }
}

class LocationsCarouselController: LBTAListController<LocationCell, String>, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: view.frame.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        self.items = ["1", "2", "3"]
    }
}
