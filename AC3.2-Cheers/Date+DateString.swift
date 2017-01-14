//
//  Date+DateString.swift
//  AC3.2-Cheers
//
//  Created by Annie Tung on 1/11/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

extension Date {
    static let dateFormatter = DateFormatter()
    
    var dateString: String {
        Date.dateFormatter.dateFormat = "yyyyMMdd"
        return Date.dateFormatter.string(from: self)
    }
}
