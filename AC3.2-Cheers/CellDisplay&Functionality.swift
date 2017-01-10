//
//  CellDisplay&Functionality.swift
//  AC3.2-Cheers
//
//  Created by Marty Avedon on 1/10/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

func convert(meters: Int) -> String {
    let miles = Double(meters) * 0.0006
    return String(format: "%.1f", miles) + " miles away"
}


