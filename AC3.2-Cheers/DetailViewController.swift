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

class DetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var progressView: UIProgressView!
    var happyHour: Venue!
    var webView: WKWebView = WKWebView()
    let topToolBar: UIToolbar = UIToolbar()
    let bottomToolBar: UIToolbar = UIToolbar()
    let popularLabel: UILabel = UILabel()
    let sampleURL = "https://www.foursquare.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\n\n\nThe Time is: \(stringMilTimeToAMPM(time: "1800"))")
        setupTopToolbar()
        setupBottomToolbar()
        setupLabel()
        getBusinessData()
        
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        let myURL = URL(string: "https://www.foursquare.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    // MARK: - Time Display Logic
    
    func stringMilTimeToAMPM(time: String) -> String {
        
        var morning = "A.M."
        var hours = 0
        var minutes = 0
        var minString = ""
        
        if let milTime = Int(time) {
            minutes = milTime % 100
            if milTime > 1200 {
                hours = (milTime / 100) - 12
                morning = "P.M."
            } else {
                hours = milTime / 100
            }
        }
        
        if minutes < 10 {
            minString = "0" + String(minutes)
        } else {
            minString = String(minutes)
        }
        
        return "\(hours):\(minString) \(morning)"
    }
    
    // MARK: - API Call
    
    func getBusinessData() {
        let date = Date()
        
        APIRequestManager.manager.getData(endPoint: "https://api.foursquare.com/v2/venues/40a55d80f964a52020f31ee3/hours?oauth_token=RFQ43RJ4WUZSVKHUUEVX2DICWK23OAFJJXFIA222WPY25H02&v=\(date.dateString)&VENUE_ID=4bf58dd8d48988d1d8941735") { (data: Data?) in
            if let validData = data {
                if let json = try? JSONSerialization.jsonObject(with: validData, options: []) {
                    
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
                                        var arrayOfTimes: [String] = []
                                        let start = start
                                        let end = end
                                        let startToEnd = "\(self.stringMilTimeToAMPM(time: start)) - \(self.stringMilTimeToAMPM(time: end))"
                                        arrayOfTimes.append(startToEnd)
                                        let strRepresentation = arrayOfTimes.joined(separator: " and")
                                        
                                        DispatchQueue.main.async {
                                            self.popularLabel.text = "Their popular times are: \(strRepresentation)"
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
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))
        let forwardButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(goForwardButtonTapped))
        
        rewindButton.tintColor = .orange
        refreshButton.tintColor = .orange
        forwardButton.tintColor = .orange
        
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
        
        button.tintColor = .orange
    }
    
    // MARK: - Progress Bar
    
    func setupProgressBar() {
        progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
        view.addSubview(progressView)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        let _ = [
            progressView.topAnchor.constraint(equalTo: topToolBar.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ].map{$0.isActive = true}
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    // MARK: - Label
    
    func setupLabel() {
        popularLabel.text = "LOADING..."
        popularLabel.textAlignment = .center
        popularLabel.numberOfLines = 0
        popularLabel.font = UIFont(name: "Futura-Medium", size: 20)
        popularLabel.textColor = .orange
        view.addSubview(popularLabel)
        
        popularLabel.translatesAutoresizingMaskIntoConstraints = false
        let _ = [
            popularLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            popularLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popularLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ].map{$0.isActive = true}
        
        setupWebView()
    }
    
    // MARK: - WebView
    
    func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
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
    
    func webView(_ didFinishwebView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    //
    // MARK: - Button Action
    
    func backButtonTapped(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    func refreshButtonTapped(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    func goForwardButtonTapped(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    func shareOptionTapped(_ sender: UIBarButtonItem) {
        
        let activityViewController = UIActivityViewController(activityItems: ["Check out this awesome bar! #cheers", sampleURL], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.mail]
        self.present(activityViewController, animated: true, completion: nil)
    }
}
