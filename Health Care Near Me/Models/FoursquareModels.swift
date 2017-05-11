//
//  FoursquareModels.swift
//  Health Care Near Me
//
//  Created by Rudy Bermudez on 4/30/17.
//  Copyright © 2017 Rudy Bermudez. All rights reserved.
//

import Foundation


struct Location {
    let coordinate: Coordinate?
    let distance: Double?
    let countryCode: String?
    let country: String?
    let state: String?
    let city: String?
    let streetAddress: String?
    let crossStreet: String?
    let postalCode: String?
}

extension Location: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        
        if let lat = JSON["lat"] as? Double, let lon = JSON["lng"] as? Double {
            coordinate = Coordinate(latitude: lat, longitude: lon)
        } else {
            coordinate = nil
        }
        
        distance = JSON["distance"] as? Double
        countryCode = JSON["cc"] as? String
        country = JSON["country"] as? String
        state = JSON["state"] as? String
        city = JSON["city"] as? String
        streetAddress = JSON["address"] as? String
        crossStreet = JSON["crossStreet"] as? String
        postalCode = JSON["postalCode"] as? String
    }
}



struct Venue {
    let id: String
    let name: String
    let location: Location?
    let categoryName: String
    let checkins: Int
	let formattedPhone: String?
	let url: String?
	let hours: String?
}

extension Venue: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let id = JSON["id"] as? String, let name = JSON["name"] as? String else {
            return nil
        }
        
        guard let categories = JSON["categories"] as? [[String: AnyObject]], let category = categories.first, let categoryName = category["shortName"] as? String else {
            return nil
        }
        
        guard let stats = JSON["stats"] as? [String: AnyObject], let checkinsCount = stats["checkinsCount"] as? Int else {
            return nil
        }
		
        
        self.id = id
        self.name = name
        self.categoryName = categoryName
        self.checkins = checkinsCount

        
        if let locationDict = JSON["location"] as? [String: AnyObject] {
            self.location = Location(JSON: locationDict)
        } else {
            self.location = nil
        }
		
		if let contactInfo = JSON["contact"] as? [String: AnyObject], let phoneNumber = contactInfo["formattedPhone"] as? String {
			self.formattedPhone = phoneNumber
		} else {
			self.formattedPhone = nil
		}
		
		if let url = JSON["url"] as? String {
			self.url = url
		} else {
			self.url = nil
		}
		
		if let hours = JSON["hours"] as? String {
			self.hours = hours
		} else {
			self.hours = nil
		}
    }
}
