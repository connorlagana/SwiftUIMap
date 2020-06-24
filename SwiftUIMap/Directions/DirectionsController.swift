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

class DirectionsController: UIViewController, MKMapViewDelegate {
    
    let mapView = MKMapView()
    let navBar = UIView(backgroundColor: .init(red: 120/255, green: 220/255, blue: 165/255, alpha: 1))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        view.addSubview(mapView)
//        mapView.fillSuperview()
        
        navigationController?.navigationBar.isHidden = true
        
        setupRegionForMap()
        setupNavBarUI()
        mapView.anchor(top: navBar.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        mapView.showsUserLocation = true
        
        setupStartEnd()
        requestDirections()
    }
    
    fileprivate func setupStartEnd() {
        let startAnno = MKPointAnnotation()
        startAnno.coordinate = .init(latitude: 37.7666, longitude: -122.42729)
        startAnno.title = "Start"
        
        let endAnno = MKPointAnnotation()
        endAnno.coordinate = .init(latitude: 37.3666, longitude: -122.02729)
        endAnno.title = "End"
        
        mapView.addAnnotation(startAnno)
        mapView.addAnnotation(endAnno)
        
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    fileprivate func requestDirections() {
        let request = MKDirections.Request()
        
        let startPM = MKPlacemark(coordinate: .init(latitude: 37.7666, longitude: -122.42729))
        let endPM = MKPlacemark(coordinate: .init(latitude: 37.3666, longitude: -122.02729))
        
        request.source = .init(placemark: startPM)
        request.destination = .init(placemark: endPM)
        
        let directions = MKDirections(request: request)
        directions.calculate { (resp, err) in
            if let err = err {
                print("Failed to find routing info: ", err)
                return
            }
            //success
            print("directions! fuck yeah!")
            //getting first route possible
            guard let route = resp?.routes.first else { return }
            
//            route.advisoryNotices
//            route.distance
//            route.expectedTravelTime
//            route.polyline
            
            self.mapView.addOverlay(route.polyline)
            //polyline still has to render after adding overlay
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
        polyLineRenderer.strokeColor = .init(red: 120/255, green: 220/255, blue: 165/255, alpha: 1)
        polyLineRenderer.lineWidth = 5
        return polyLineRenderer
    }
    
    let startTextField = IndentedTextField(padding: 12, cornerRadius: 5)
    let endTextField = IndentedTextField(padding: 12, cornerRadius: 5)
    
    fileprivate func setupNavBarUI() {
        
        view.addSubview(navBar)
        navBar.setupShadow(opacity: 0.5, radius: 5)
        navBar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -120, right: 0))
        
        startTextField.attributedPlaceholder = .init(string: "Start", attributes: [.foregroundColor: UIColor.init(white: 1, alpha: 0.7)])
        endTextField.attributedPlaceholder = .init(string: "End", attributes: [.foregroundColor: UIColor.init(white: 1, alpha: 0.7)])
        
        [startTextField, endTextField].forEach { (tf) in
            tf.backgroundColor = .init(white: 1, alpha: 0.3)
        }
        
        let containerView = UIView(backgroundColor: .clear)
        
        let startIcon = UIImageView(image: #imageLiteral(resourceName: "start_location_circles"), contentMode: .scaleAspectFit)
        let endIcon = UIImageView(image: #imageLiteral(resourceName: "annotation_icon").withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        
        startIcon.constrainWidth(20)
        endIcon.constrainWidth(20)
        endIcon.tintColor = .white
        
        navBar.addSubview(containerView)
        containerView.fillSuperviewSafeAreaLayoutGuide()
        containerView
            .stack(
                containerView.hstack(startIcon, startTextField, spacing: 16),
                containerView.hstack(endIcon, endTextField, spacing: 16),
                spacing: 12,
                distribution: .fillEqually
                )
            .withMargins(.init(top: 0, left: 12, bottom: 12, right: 12))
        
        startTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChangeStartLocation)))
    }
    
    @objc fileprivate func handleChangeStartLocation() {
        
        let vc = UIViewController()
        vc.view.backgroundColor = .yellow
        navigationController?.pushViewController(vc, animated: true)
    
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
        ContainerView().edgesIgnoringSafeArea(.all).environment(\.colorScheme, .light)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<DirectionsPreview.ContainerView>) -> UIViewController {
            return UINavigationController(rootViewController: DirectionsController())
        }
        
        func updateUIViewController(_ uiViewController: DirectionsPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<DirectionsPreview.ContainerView> ) {
            
        }
    }
}
