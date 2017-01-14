//
//  Venue.swift
//  AC3.2-Cheers
//
//  Created by Karen Fuentes on 1/11/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation
class Venue {
    let name: String
    let url: String
    let phoneNumber: String
    let address : [String]
    let distance: Int
    let tier: Int
    var favorite: Bool = false
    let message: String
    let status : String
    let id : String
    init?(from dict: [String: Any]) {
        if let name = dict["name"] as? String,
            let id = dict["id"] as? String,
            let url = dict["url"] as? String,
            let contact = dict["contact"] as? [String:Any],
            let phoneNumb = contact["formattedPhone"] as? String,
            let locationDict = dict["location"] as? [String: Any],
            let distance = locationDict["distance"] as? Int,
            let addressArray = locationDict["formattedAddress"] as? [String],
            let priceDict = dict["price"] as? [String:Any],
            let tier = priceDict["tier"] as? Int,
            let message = priceDict["message"] as? String,
            let hoursDict = dict["hours"] as? [String: Any],
            let status = hoursDict["status"] as? String {
            
            self.name = name
            self.url = url
            self.phoneNumber = phoneNumb
            self.address = addressArray
            self.distance = distance
            self.tier = tier
            self.message = message
            self.status = status
            self.id = id 
        }
        else {
            return nil
        }
    }
    static func parseVenue(from array:[[String:Any]]) -> [Venue] {
        var venues = [Venue]()
        for item in array {
            if let venueDict = item["venue"] as? [String: Any] {
                if let venue = Venue(from: venueDict) {
                    venues.append(venue)
                }
            }
        }
        return venues
    }
    
    
    func convert(meters: Int16) -> String {
        let miles = Double(meters) * 0.0006
        return String(format: "%.1f", miles) + " miles away"
    }
    
    
    func distanceFormatted() -> String {
        let distance = self.distance
        
        let locale = NSLocale.current
        let isMetric = locale.usesMetricSystem
        
        if isMetric {
            return String(distance)
        } else {
            return convert(meters: Int16(distance))
        }
    }
}
