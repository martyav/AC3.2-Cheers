//
//  DetailViewController.swift
//  AC3.2-Cheers
//
//  Created by Annie Tung on 1/10/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit
import Social
import WebKit
import CoreData

class DetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, NSFetchedResultsControllerDelegate {
    
    //    var webView: WKWebView!
    var webView: WKWebView = WKWebView()
    let url = URL(string: "http://www.foursquare.com")!
    
    var progressView: UIProgressView!
    var happyHour: HappyHourVenue!
    let topToolBar: UIToolbar = UIToolbar()
    let bottomToolBar: UIToolbar = UIToolbar()
    let popularLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // getBusinessData()
        setupBottomToolbar()
        setupTopToolbar()
        setupLabel()
    }
    
    // MARK: - API Call
    
    func getBusinessData() {
        APIRequestManager.manager.getData(endPoint: "https://api.foursquare.com/v2/venues/40a55d80f964a52020f31ee3/hours?oauth_token=RFQ43RJ4WUZSVKHUUEVX2DICWK23OAFJJXFIA222WPY25H02&v=20170111&VENUE_ID=\(happyHour.id)") { (data: Data?) in
            if let validData = data {
                if let json = try? JSONSerialization.jsonObject(with: validData, options: []) {
                    var populartimesArray: [String] = []
                    
                    if let jsonDict = json as? [String:Any],
                        let response = jsonDict["response"] as? [String:Any],
                        let popular = response["popular"] as? [String:Any],
                        let timeframes = popular["timeframes"] as? [[String:Any]] {
                        
                        for times in timeframes {
                            guard let includesToday = times["includesToday"] as? Bool else { return }
                            if let open = times["open"] as? [[String:Any]] {
                                
                                for populartimes in open {
                                    if let start = populartimes["start"] as? String,
                                        let end = populartimes["end"] as? String {
                                        
                                        populartimesArray.append(start)
                                        populartimesArray.append(end)
                                        print(populartimesArray)
                                        
                                        DispatchQueue.main.async {
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Tool Bars
    
    func setupTopToolbar() {
        topToolBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44)
        self.view.addSubview(topToolBar)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: DetailViewController.self, action: nil)
        let rewindButton = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(backButtonTapped))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(backButtonTapped))
        let forwardButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(backButtonTapped))
        
        topToolBar.items = [rewindButton, flexibleSpace, refreshButton, flexibleSpace, forwardButton]
        
        topToolBar.translatesAutoresizingMaskIntoConstraints = false
        let _ = [
            topToolBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            topToolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topToolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ].map{$0.isActive = true}
        
        setupProgressBar()
    }
    
    func setupBottomToolbar() {
        bottomToolBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44)
        self.view.addSubview(bottomToolBar)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: DetailViewController.self, action: nil)
        let button = UIBarButtonItem(title: "Share", style: UIBarButtonItemStyle.plain, target: self, action: #selector(shareOptionTapped))
        bottomToolBar.items = [flexibleSpace, button, flexibleSpace]
        
        bottomToolBar.translatesAutoresizingMaskIntoConstraints = false
        let _ = [
            bottomToolBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomToolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomToolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ].map{$0.isActive = true }
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        print("go back works")
        //        webView.goBack()
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        print("refresh works")
        //        webView.reload()
    }
    
    @IBAction func goForwardButtonTapped(_ sender: UIBarButtonItem) {
        print("forward works")
        //        webView.goForward()
    }
    
    // MARK: - Share Button
    
    func shareOptionTapped(_ sender: UIBarButtonItem) {
        
        let activityViewController = UIActivityViewController(activityItems: ["Check out this awesome bar! #cheers"], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.mail]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Progress Bar
    
    func setupProgressBar() {
        
        let progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
        view.addSubview(progressView)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        let _ = [
            progressView.topAnchor.constraint(equalTo: topToolBar.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ].map{$0.isActive = true}
    }
    
    // MARK: - Label
    
    func setupLabel() {
        popularLabel.text = "Testing"
        popularLabel.textAlignment = .center
        view.addSubview(popularLabel)
        
        popularLabel.translatesAutoresizingMaskIntoConstraints = false
        let _ = [
            popularLabel.topAnchor.constraint(equalTo: topToolBar.bottomAnchor),
            popularLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popularLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ].map{$0.isActive = true}
        
        setupWebView()
    }
    
    // MARK: - WebView
    
    func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        //self.edgesForExtendedLayout = []
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.backgroundColor = .yellow
        
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let _ = [
            webView.topAnchor.constraint(equalTo: popularLabel.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomToolBar.topAnchor)
            ].map{$0.isActive = true}
    }
}
