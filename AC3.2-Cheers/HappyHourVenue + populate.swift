//
//  HappyHourVenue + populate.swift
//  AC3.2-Cheers
//
//  Created by Karen Fuentes on 1/12/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation
extension HappyHourVenues {
    func populate(from obj: Venue) {
        self.name = obj.name
        self.favorite = obj.favorite
    }
}
