//
//  ViewController.swift
//  My Favorite Places
//
//  Created by 康景炫 on 2020/12/17.
//

import UIKit
import MapKit

class ViewController: UIViewController ,MKMapViewDelegate{
    var place : Place?
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            print("===\nLong Press\n===")
            let touchPoint = sender.location(in: self.map)
            let newCoordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
            print(newCoordinate)
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            var title = ""
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error != nil { print(error!)
                } else {
                    if let placemark = placemarks?[0] {
                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " "
                        }
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare!
                        }
                    } }
                if title == "" {
                    title = "Added \(NSDate())"
                }
                let annotation = MKPointAnnotation()
                annotation.coordinate = newCoordinate
                annotation.title = title
                self.map.addAnnotation(annotation)
                DataManager.shared.addPlace(Place.init(name: title, lat: newCoordinate.latitude, lon: newCoordinate.longitude))
                
            }) }
    }

    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
            super.viewDidLoad()
            if let place = place {
                set(place: place)
            }
        }
        
        
        private func set(place: Place) {
            let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
            let coordinate = CLLocationCoordinate2D(latitude: place.lat, longitude: place.lon)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            self.map.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = place.name
            self.map.addAnnotation(annotation)
        }
    
    
}

