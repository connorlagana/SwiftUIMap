//
//  DirectionsController.swift
//  SwiftUIMap
//
//  Created by Connor Lagana on 6/22/20.
//  Copyright © 2020 Connor Lagana. All rights reserved.
//

import UIKit
import LBTATools
import MapKit
import SwiftUI

class DirectionsController: UIViewController {
    
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.fillSuperview()
        setupRegionForMap()
        setupNavBarUI()
        
        mapView.showsUserLocation = true
    }
    
    fileprivate func setupNavBarUI() {
        let navBar = UIView(backgroundColor: .init(red: 40/255, green: 240/255, blue: 175/255, alpha: 1))
        view.addSubview(navBar)
        navBar.setupShadow(opacity: 0.5, radius: 5)
        navBar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -100, right: 0))
    }
    
    fileprivate func setupRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}



struct DirectionsPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<DirectionsPreview.ContainerView>) -> UIViewController {
            return DirectionsController()
        }
        
        func updateUIViewController(_ uiViewController: DirectionsPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<DirectionsPreview.ContainerView> ) {
            
        }
    }
}
