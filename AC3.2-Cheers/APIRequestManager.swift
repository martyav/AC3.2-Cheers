//
//  APIRequestManager.swift
//  AC3.2-Cheers
//
//  Created by Karen Fuentes on 1/10/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation
class APIRequestManager {
    static let manager = APIRequestManager()
    private init() {}
    
    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error durring session: \(error)")
            }
            guard let validData = data else { return }
            
            callback(validData)
            }.resume()
    }
}
