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
    
    @IBOutlet weak var webView: UIWebView!
    let url = URL(string: "http://www.foursquare.com")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToolbar()
    }
    
    // MARK: - Top Tool Bar and items
    func setupToolbar() {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44)
        toolbar.backgroundColor = .orange

        self.view.addSubview(toolbar)

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: DetailViewController.self, action: nil)
        let button = UIBarButtonItem(title: "Share", style: UIBarButtonItemStyle.plain, target: self, action: #selector(shareOptionTapped))
        toolbar.items = [flexibleSpace, button, flexibleSpace]
        
        // constraints
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    // MARK: - Share Button
    
//    @IBAction func shareOptionTapped(_ sender: UIBarButtonItem) {
    func shareOptionTapped(_ sender: UIBarButtonItem) {

        let activityViewController = UIActivityViewController(activityItems: ["Check out this awesome bar! #cheers"], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.mail]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Progress Bar
    
    // MARK: - Bottom Tool Bar Item Action
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        webView.reload()
    }

    @IBAction func goForwardButtonTapped(_ sender: UIBarButtonItem) {
        webView.goForward()
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
