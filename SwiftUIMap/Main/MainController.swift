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

extension MainController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
        annotationView.canShowCallout = true
        
        return annotationView
        
    }
}

extension MKMapItem {
    func address() -> String {
        var addressString = ""
        if placemark.subThoroughfare != nil {
            addressString = placemark.subThoroughfare! + " "
        }
        if placemark.thoroughfare != nil {
            addressString += placemark.thoroughfare! + ", "
        }
        if placemark.postalCode != nil {
            addressString += placemark.postalCode! + " "
        }
        if placemark.locality != nil {
            addressString += placemark.locality! + ", "
        }
        if placemark.administrativeArea != nil {
            addressString += placemark.administrativeArea! + " "
        }
        if placemark.country != nil {
            addressString += placemark.country!
        }
        
        return(addressString)
    }
}

class MainController: UIViewController {
    
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        view.addSubview(mapView)
        mapView.fillSuperview()
        
        setupRegionForMap()
        
//        setupAnnotations()
        
        performLocalSearch()
        setupSearchUI()
    }
    
    let searchTextField = UITextField(placeholder: "Search")
    
    fileprivate func setupSearchUI() {
        
        
        let whiteContainer = UIView(backgroundColor: .white)
        
        //listen for text change to perform search
        
        view.addSubview(whiteContainer)
        whiteContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
        
        whiteContainer.stack(searchTextField).withMargins(.allSides(16))
    }
    
    fileprivate func performLocalSearch() {
        let req = MKLocalSearch.Request()
        req.naturalLanguageQuery = "sushi"
        req.region = mapView.region
        
        let localSearch = MKLocalSearch(request: req)
        localSearch.start { (resp, err) in
            if let err = err {
                print("Failed local search: \(err)")
                return
            }
            
            //success
            resp?.mapItems.forEach({ (mapItem) in
                
                print(mapItem.address())
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                
                self.mapView.addAnnotation(annotation)
            })
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    
//    fileprivate func setupAnnotations() {
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.766, longitude: -122.4279)
//        annotation.title = "San Francisco"
//        annotation.subtitle = "CA"
//        mapView.addAnnotation(annotation)
//    }
    
    fileprivate func setupRegionForMap() {
        let coordinate = CLLocationCoordinate2D(latitude: 37.766, longitude: -122.4279)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
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
