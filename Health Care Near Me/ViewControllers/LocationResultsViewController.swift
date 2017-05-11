//
//  LocationResultsViewController.swift
//  Health Care Near Me
//
//  Created by Rudy Bermudez on 4/30/17.
//  Copyright © 2017 Rudy Bermudez. All rights reserved.
//

import UIKit
import MapKit

class LocationResultsViewController: UIViewController {
    
    public static let storyboardIdentifier: String = "LocationResultsViewController"

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    var coordinate: Coordinate?
    let foursquareClient = FoursquareClient(clientID: "5O53IDZJAWB12DFHH1WFEYL2I1I3L0BTYQPHZUGJZYFL5IO4", clientSecret: "DXVEG1PDN0NMSOOZRRLJTWXTAON4RUL3GJSXAZVVEKHP40A3")
    
    let manager = LocationManager()
    
    let searchController = UISearchController(searchResultsController: nil)
	
	var regionHasBeenSet = false
    
    var searchItem: MedicalLocation? {
        didSet {
            if let searchItem = searchItem {
                self.navigationItem.title = searchItem.description
            }
        }
    }
    
    var venues: [Venue] = [] {
        didSet {
            if venues.count > 0 {
                tableView.reloadData()
                addMapAnnotations()
            } else {
                if let searchItem = searchItem {
                    let action = UIAlertAction(title: "Search For Something Else", style: .default, handler: { (_) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    showAlert(target: self, title: "Unable to find a \(searchItem.description) near you", message: "Try looking again in a different area", style: .alert, actionList: [action])
                }
                
            }
            
        }
    }
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		// Search bar configuration
		searchController.searchResultsUpdater = self
		searchController.hidesNavigationBarDuringPresentation = true
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.isTranslucent = false
		definesPresentationContext = true
		stackView.insertArrangedSubview(searchController.searchBar, at: 0)
		self.view.layoutIfNeeded()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 238.0/255.0, green: 37.0/255.0, blue: 16.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.white
		
		manager.getPermission()
        manager.onLocationFix = { [weak self] coordinate in
            
            self?.coordinate = coordinate
            guard let searchItem = self?.searchItem else {
                return
            }
            
            self?.foursquareClient.fetchLocationsFor(coordinate, category: searchItem){ result in
                switch result {
                case .success(let venues):
                    self?.venues = venues
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

}

extension LocationResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationTableViewCell
        let venue = venues[indexPath.row]
        // TODO: Rudy - Add functionality, name, description, category etc
        cell.LocationTitleLabel.text = venue.name
        return cell
    }
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("Selected: \(venues[indexPath.row].name)")
		let vc = storyboard?.instantiateViewController(withIdentifier: DetailViewController.storyboardID) as! DetailViewController
		vc.venue = venues[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
	}
    
}




// MARK: MKMAPViewDelegate

extension LocationResultsViewController: MKMapViewDelegate {
    
    
    func addMapAnnotations() {
        removeMapAnnotations()
        
        if venues.count > 0 {
            let annotations: [MKPointAnnotation] = venues.map { venue in
                let point = MKPointAnnotation()
                
                if let coordinate = venue.location?.coordinate {
                    point.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    point.title = venue.name
					point.subtitle = "\(venue.checkins) Check-ins"
                }
                return point
            }
			mapView.addAnnotations(annotations)
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
        var region = MKCoordinateRegion()
        region.center = mapView.userLocation.coordinate
        region.span.latitudeDelta = 0.03
        region.span.longitudeDelta = 0.03
        mapView.setRegion(region, animated: false)
        
    }
	
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		if !regionHasBeenSet {
            regionHasBeenSet = true
			setMapRegion()
		}
	}
 
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotations = view.annotation?.title, let title = annotations else {
            return
        }
        let row = venues.index { $0.name == title }
        
        if let row = row {
            tableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .top)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let annotations = view.annotation?.title, let title = annotations else {
            return
        }
        let row = venues.index { $0.name == title }
        
        if let row = row {
            tableView.deselectRow(at: IndexPath(row: row, section: 0), animated: true)
        }
    }
}

// MARK: UISearchResultsUpdating

extension LocationResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let coordinate = coordinate, let searchItem = searchItem {
            foursquareClient.fetchLocationsFor(coordinate, category: searchItem, query: searchController.searchBar.text) { result in
                switch result {
                case .success(let venues):
                    self.venues = venues
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}
