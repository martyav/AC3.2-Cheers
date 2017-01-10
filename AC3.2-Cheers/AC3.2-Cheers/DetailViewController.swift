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
        
    }
    
    // MARK: - Progress Bar
    

    
    // MARK: - Share Button
    
    @IBAction func shareOptionTapped(_ sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.mail]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Tool Bar Item Action
    
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
