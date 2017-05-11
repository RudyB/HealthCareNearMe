//
//  LocationManager.swift
//  Stratus
//
//  Created by Rudy Bermudez on 3/19/17.
//  Copyright © 2017 Rudy Bermudez. All rights reserved.
//

import Foundation
import CoreLocation

extension Coordinate {
    init(location: CLLocation) {
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
	let manager = CLLocationManager()
	
	let errorDomain = "co.rudybermudez.stratus.LocationManager"
	
	var onLocationFix: ((Coordinate) -> Void)?
	
	override init() {
		super.init()
		manager.delegate = self
		manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
		manager.requestLocation()
	}
	
	func getPermission() {
		if CLLocationManager.authorizationStatus() == .notDetermined {
			manager.requestWhenInUseAuthorization()
		}
	}
	
	func updateLocation() {
		manager.requestLocation()
	}
	
	// MARK: CLLocationManagerDelegate
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse {
			manager.requestLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		guard let location = locations.first else { return }
		
        let coordinate = Coordinate(location: location)
        if let onLocationFix = onLocationFix {
            onLocationFix(coordinate)
        }
	}
}
