//
//  CheersViewController.swift
//  AC3.2-Cheers
//
//  Created by Annie Tung on 1/10/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class CheersViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager: CLLocationManager = {
        let location: CLLocationManager = CLLocationManager()
        location.desiredAccuracy = kCLLocationAccuracyHundredMeters
        location.distanceFilter = 50.0
        return location
    }()
    
    let geocoder: CLGeocoder = CLGeocoder()
    var fetchedResultsController: NSFetchedResultsController<HappyHourVenue>!
    
    var mainContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
        tableView.register(UINib(nibName: "BasicCheersTableViewCell", bundle: nil),forCellReuseIdentifier: "cheers")
        tableView.delegate = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        //getData()
        initializeFetchedResultsController()
        
        
    }
    //MARK: - Networking
    
    func getData() {
        APIRequestManager.manager.getData(endPoint: "https://api.foursquare.com/v2/venues/explore?ll=40.7,-74&oauth_token=RFQ43RJ4WUZSVKHUUEVX2DICWK23OAFJJXFIA222WPY25H02&v=20170110&section=drinks%20&query=happy%20hour") { (data: Data?) in
            if let validData = data {
                if let jsonData = try? JSONSerialization.jsonObject(with: validData, options: []) {
                    if let fullDict = jsonData as? [String: Any],
                        let response = fullDict["response"] as? [String:Any],
                        let groups = response["groups"] as? [[String:AnyObject]],
                        let items = groups[0]["items"] as? [[String: Any]] {
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let pc = appDelegate.persistentContainer
                        pc.performBackgroundTask { (context: NSManagedObjectContext) in
                            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                            
                            for venueObj in items {
                                guard let venueDict = venueObj["venue"] as? [String: Any]  else {return}
                                let happyHourVenues = HappyHourVenue(context: context)
                                    happyHourVenues.populate(from: venueDict)
                               // happyHourVenues.populate(from: venueObj)
                                
                            }
                                do {
                                    try  context.save()
                                }
                                catch let error {
                                    print(error)
                                }
                                DispatchQueue.main.async {
                                    self.initializeFetchedResultsController()
                                    self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - CoreLocation Delegate
    
    // MARK: - Mapview Delegate
    
    // MARK: - TableView Delegate & Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let info: NSFetchedResultsSectionInfo = sections[section]
            return info.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cheers", for: indexPath) as!BasicCheersTableViewCell
        let venueObj = fetchedResultsController.object(at: indexPath)
        cell.venueName.text = venueObj.name
//        cell.distance.text = String(venueObj.distance)
//        let price = String(repeatElement("$", count: Int(venueObj.tier)))
//        cell.pricing.text = price
//        //cell.favorite.backgroundColor = .white
//        cell.popularTimes.text = "  "
        return cell
    }
    // MARK - FetchResultsController Functions
    
    func initializeFetchedResultsController() {
        let request: NSFetchRequest<HappyHourVenue> = HappyHourVenue.fetchRequest()
        let sort = NSSortDescriptor(key: "distance", ascending: true)
        request.sortDescriptors = [sort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
