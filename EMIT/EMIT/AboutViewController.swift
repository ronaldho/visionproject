//
//  AboutViewController.swift
//  EMIT
//
//  Created by Andrew on 4/06/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class AboutViewController: AGViewController, UIWebViewDelegate {

    let aboutUrl = "http://emitcare.ca/about/"
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillDisappear(animated: Bool) {
        // Apparently it's important to nil the delegate
        webView.delegate = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        activityIndicator.hidden = true;
        webView.delegate = self
        let url = NSURL(string: aboutUrl)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true;

        let alertController = UIAlertController(title: nil, message: error?.localizedDescription, preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
        })
        
        alertController.addAction(ok)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        activityIndicator.hidden = false;
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.hidden = true;
        activityIndicator.stopAnimating()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
