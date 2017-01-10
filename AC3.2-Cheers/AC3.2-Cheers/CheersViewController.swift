//
//  CheersViewController.swift
//  AC3.2-Cheers
//
//  Created by Annie Tung on 1/10/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CheersViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager: CLLocationManager = {
        let location: CLLocationManager = CLLocationManager()
        location.desiredAccuracy = kCLLocationAccuracyHundredMeters
        location.distanceFilter = 50.0
        return location
    }()
    
    let geocoder: CLGeocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self

    }
    
    // MARK: - CoreLocation Delegate
    
    // MARK: - Mapview Delegate

    // MARK: - MapView
    
    internal lazy var mapView: MKMapView = {
        let mapView: MKMapView = MKMapView()
        return mapView
    }()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
