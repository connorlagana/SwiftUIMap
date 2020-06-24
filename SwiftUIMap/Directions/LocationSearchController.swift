//
//  LocationSearchController.swift
//  SwiftUIMap
//
//  Created by Connor Lagana on 6/24/20.
//  Copyright © 2020 Connor Lagana. All rights reserved.
//

import SwiftUI
import UIKit
import LBTATools
import MapKit

class LocationSearchCell: LBTAListCell<String> {
    override func setupViews() {
        backgroundColor = .green
    }
}

class LocationSearchController: LBTAListController<LocationSearchCell, String> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.items = ["1", "2"]
        
        performLocalSearch()
    }
    
    fileprivate func performLocalSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Apple"
//        request.region
        
        let search = MKLocalSearch(request: request)
        
        search.start { (resp, err) in
            
            print(resp?.mapItems)
            
        }
    }
}


extension LocationSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 60)
    }
}

struct LocationSearchController_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: Context) -> UIViewController {
            LocationSearchController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            
        }
        
    }
}
