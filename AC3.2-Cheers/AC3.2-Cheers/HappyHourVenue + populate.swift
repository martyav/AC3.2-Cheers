//
//  HappyHourVenue + populate.swift
//  AC3.2-Cheers
//
//  Created by Karen Fuentes on 1/10/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

extension HappyHourVenue {
    func populate(from dict: [String: Any]) {
        //guard let venueDict = dict["venue"] as? [String: Any]  else {return}
        if let name = dict["name"] as? String,
            let id = dict["id"] as? String,
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
            self.id = id
            self.phoneNumber = phoneNumb
            for address in addressArray {
                self.address = " " + address
            }
            self.distance = Int16(distance)
            self.tier = Int16(tier)
            self.message = message
            self.status = status
        }
    }
    
    func convert(meters: Int16) -> String {
        let miles = Double(meters) * 0.0006
        return String(format: "%.1f", miles) + " miles away"
    }
    
    // check user's prefered units based on locale...but allow them to switch (button in nav bar?)
    
    func distanceFormatted() -> String {
        let locale = NSLocale.current
        let isMetric = locale.usesMetricSystem
        let distance = self.distance
        
        if isMetric {
            return String(distance)
        } else {
            return convert(meters: distance)
        }
    }
}
