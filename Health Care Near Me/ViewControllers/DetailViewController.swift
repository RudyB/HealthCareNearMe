//
//  DetailViewController.swift
//  Health Care Near Me
//
//  Created by Rudy Bermudez on 5/1/17.
//  Copyright © 2017 Rudy Bermudez. All rights reserved.
//

import UIKit
import MapKit


class DetailViewController: UIViewController {
	
	public static let storyboardID: String = "detailViewController"
	
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var checkinsLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var callStackView: UIStackView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var websiteStackView: UIStackView!
    @IBOutlet weak var websiteAddressLabel: UILabel!
    
    
	var venue: Venue?
	

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        addMapAnnotations()
        setMapRegion()
        if let venue = venue {
            self.titleLabel.text = venue.name
            self.categoryLabel.text = venue.categoryName
            self.checkinsLabel.text = "\(venue.checkins) Check-ins"
        }
        
        if let hours = venue?.hours {
            self.hoursLabel.text = hours
            self.hoursLabel.isHidden = false
        } else {
            self.hoursLabel.isHidden = true
        }
        
        if let location = venue?.location, let address = location.streetAddress, let city = location.city, let state = location.state, let zipcode = location.postalCode {
            self.addressLabel.text = "\(address), \(city), \(state) \(zipcode)"
            self.addressLabel.isHidden = false
        } else {
            self.addressLabel.isHidden = true
        }
        
        if let phoneNumber = venue?.formattedPhone {
            self.phoneNumberLabel.text = phoneNumber
            self.callStackView.isHidden = false
        } else {
            self.callStackView.isHidden = true
        }
        
        if let website = venue?.url {
            self.websiteAddressLabel.text = website
            self.websiteStackView.isHidden = false
        } else {
            self.websiteStackView.isHidden = true
        }
        
    }
	

}

// MARK: MKMAPViewDelegate

extension DetailViewController: MKMapViewDelegate {
    
    
    func addMapAnnotations() {
        removeMapAnnotations()
        
        let point = MKPointAnnotation()
        
        if let venue = venue, let coordinate = venue.location?.coordinate {
            point.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            point.title = venue.name
            mapView.addAnnotation(point)
        }
    }
    

    func removeMapAnnotations() {
        if mapView.annotations.count != 0 {
            for annotation in mapView.annotations {
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
    func setMapRegion() {
        guard let annotationLocation = mapView.annotations.first?.coordinate else {
            return
        }
        var region = MKCoordinateRegion()
        region.center = annotationLocation
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        mapView.setRegion(region, animated: false)
        
    }
}
