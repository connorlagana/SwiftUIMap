//
//  MainController.swift
//  SwiftUIMap
//
//  Created by Connor Lagana on 6/16/20.
//  Copyright © 2020 Connor Lagana. All rights reserved.
//

import UIKit
import MapKit
import LBTATools

extension MainController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is MKPointAnnotation) {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
            annotationView.canShowCallout = true
            return annotationView
        }
        return nil
    }
    
}

class MainController: UIViewController, CLLocationManagerDelegate {
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    
    fileprivate func requestUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("recieved authorization")
            locationManager.startUpdatingLocation()
        default:
            print("failure code yellow")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else { return }
        mapView.setRegion(.init(center: firstLocation.coordinate, span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
        
//        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let index = self.locationsController.items.firstIndex(where: {$0.name == view.annotation?.title}) else { return }
        
        self.locationsController.collectionView.scrollToItem(at: [0, index], at: .centeredHorizontally, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestUserLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        mapView.fillSuperview()
        
        setupRegionForMap()
        
        performLocalSearch()
        setupSearchUI()
        setupLocationsCarousel()
        locationsController.mainController = self
    }
    
    let locationsController = LocationsCarouselController(scrollDirection: .horizontal)
    
    fileprivate func setupLocationsCarousel() {
        let locationsView = locationsController.view!
            
        view.addSubview(locationsView)
        locationsView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 100))
    }
    
    let searchTextField = UITextField(placeholder: "Search query")
    
    fileprivate func setupSearchUI() {
        let whiteContainer = UIView(backgroundColor: .white)
        view.addSubview(whiteContainer)
        whiteContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        
        whiteContainer.stack(searchTextField).withMargins(.allSides(16))
        
        // listen for text changes and then perform new search
        // OLD SCHOOL
//        searchTextField.addTarget(self, action: #selector(handleSearchChanges), for: .editingChanged)
        
        
        // NEW SCHOOL Search Throttling
        // search on the last keystroke of text changes and basically wait 500 milliseconds
        _ = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { (_) in
                self.performLocalSearch()
        }
    }
    
    @objc fileprivate func handleSearchChanges() {
        performLocalSearch()
    }
    
    fileprivate func performLocalSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTextField.text
        request.region = mapView.region
        
        mapView.annotations.forEach { (annotation) in
            if annotation.title == "TEST" {
                mapView.selectAnnotation(annotation, animated: true)
            }
        }
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (resp, err) in
            if let err = err {
                print("Failed local search:", err)
                return
            }
            
            // Success
            // remove old annotations
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.locationsController.items.removeAll()
            
            resp?.mapItems.forEach({ (mapItem) in
                print(mapItem.address())
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapView.addAnnotation(annotation)
                
                // tell my locationsCarouselController
                self.locationsController.items.append(mapItem)
            })
            
            if resp?.mapItems.count != 0 { self.locationsController.collectionView.scrollToItem(at: [0, 0], at: .centeredHorizontally, animated: true)
            }
            
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    
    fileprivate func setupAnnotationsForMap() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        annotation.title = "San Francisco"
        annotation.subtitle = "CA"
        mapView.addAnnotation(annotation)
        
        let appleCampusAnnotation = MKPointAnnotation()
        appleCampusAnnotation.coordinate = .init(latitude: 37.3326, longitude: -122.030024)
        appleCampusAnnotation.title = "Apple Campus"
        appleCampusAnnotation.subtitle = "Cupertino, CA"
        mapView.addAnnotation(appleCampusAnnotation)
        
        mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    fileprivate func setupRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

// SwiftUI Preview
import SwiftUI

struct MainPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) -> MainController {
            return MainController()
        }
        
        func updateUIViewController(_ uiViewController: MainController, context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) {
            
        }
        
        typealias UIViewControllerType = MainController
    }
}
