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
import MapKit

class LocationCell: LBTAListCell<MKMapItem> {
    
    let label = UILabel(text: "Location", font: .boldSystemFont(ofSize: 16))
    
    override var item: MKMapItem! {
        didSet {
            label.text = item.name
        }
    }
    
    override func setupViews() {
        backgroundColor = .white
        setupShadow(opacity: 0.2, radius: 5, offset: .zero, color: .black)
        layer.cornerRadius = 5
        
        stack(label).withMargins(.allSides(16))
    }
}

class LocationsCarouselController: LBTAListController<LocationCell, MKMapItem> {
    
    weak var mainController: MainController?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let annotations = mainController?.mapView.annotations
        annotations?.forEach({ (annotation) in
            
            guard let customAnnotation = annotation as? MainController.CustomMapItemAnnotation else { return }
            
            if customAnnotation.mapItem?.name == self.items[indexPath.item].name {
                mainController?.mapView.selectAnnotation(annotation, animated: true)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        
    }
}

extension LocationsCarouselController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
