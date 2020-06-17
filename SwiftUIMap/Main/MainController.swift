//
//  MainController.swift
//  SwiftUIMap
//
//  Created by Connor Lagana on 6/16/20.
//  Copyright © 2020 Connor Lagana. All rights reserved.
//

import UIKit
import SwiftUI
import MapKit
import LBTATools

class MainController: UIViewController {
    
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        mapView.fillSuperview()
    }
}

// SwiftUI Preview
struct MainPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
//        Text("I miss alex :(")
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> MainController {
            return MainController()
        }
        
        func updateUIViewController(_ uiViewController: MainController, context: Context) {
            
        }
        
        typealias UIViewControllerType = MainController
    
    }
}
