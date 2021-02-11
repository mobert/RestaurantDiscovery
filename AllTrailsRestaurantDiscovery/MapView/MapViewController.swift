//
//  MapViewController.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 2/2/21.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    var currentLocation: CLLocation?
    var viewModel: RestaurantViewModel
    var annotations = [MKAnnotation]()
    
    init(viewModel: RestaurantViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        view.addSubview(mapView)
        
        mapView.fillSuperview()
        guard let currentLocation = currentLocation else { return }
        setRegion(location: currentLocation, radius: 1000)
        loadData()

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: placeDataDidUpdateNotification), object: nil, queue: OperationQueue.main) { [weak self] _ in
            guard let self = self else { return }
            self.reloadData()
        }
    }
    
    func setRegion(location: CLLocation, radius: Double) {
        let regionRadius: CLLocationDistance = radius
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    func loadData() {
        mapView.addAnnotations(viewModel.restaurants)
    }
    
    @objc func reloadData() {
        mapView.removeAnnotations(self.mapView.annotations)
        if viewModel.restaurants.count == 0 {
            let alert = RestaurantDiscoveryAlerts.noResultsError()
            present(alert, animated: false)
            return
        }
        loadData()
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "Placemark"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
            annotationView!.animatesDrop = false
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "static")
        
        return annotationView
    
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        view.image = UIImage(named: "active")
        let callout = RestaurantDetailsView()
        callout.layer.cornerRadius = 10
        callout.frame = CGRect(origin: .zero, size: CGSize(width: 250, height: 100))
        if let restaurant = view.annotation as? Restaurant {
            callout.configure(restaurant: restaurant)
        }
        callout.backgroundColor = UIColor.white
        
        view.addSubview(callout)
        callout.center = CGPoint(x: callout.bounds.size.width*0.1, y: -callout.bounds.size.height*0.5)
    
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    
        for view in view.subviews {
            if view is RestaurantDetailsView {
                view.removeFromSuperview()
            }
        }
        if view is MKPinAnnotationView {
            view.image = UIImage(named: "static")
        }
    }
}


