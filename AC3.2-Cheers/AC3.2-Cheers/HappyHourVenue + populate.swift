//
//  HappyHourVenue + populate.swift
//  AC3.2-Cheers
//
//  Created by Karen Fuentes on 1/10/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

extension HappyHourVenue {
    func populate(from dict: [String: Any]) -> Bool {
        guard let venueDict = dict["venue"] as? [String: Any]  else {
            print("blah")
            return false
        }
        
        if let name = venueDict["name"] as? String,
            let id = venueDict["id"] as? String,
            let contact = venueDict["contact"] as? [String:Any],
            let phoneNumb = contact["formattedPhone"] as? String,
            let locationDict = venueDict["location"] as? [String: Any],
            let distance = locationDict["distance"] as? Int,
            let addressArray = locationDict["formattedAddress"] as? [String],
            let priceDict = venueDict["price"] as? [String:Any],
            let tier = priceDict["tier"] as? Int,
            let message = priceDict["message"] as? String,
            let hoursDict = venueDict["hours"] as? [String: Any],
            let status = hoursDict["status"] as? String {
            
            self.name = name
            self.id = id
            self.phoneNumber = phoneNumb
            for address in addressArray {
                self.address = " " + address
            }
            self.distance = Int16(distance)
            self.tier = Int16(tier)
            self.message = message
            self.status = status
            self.favorite = false
            
            return true
        }
        return false
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
            return convert(meters: distance)
        }
    }
}
