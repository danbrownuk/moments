//
//  ViewController.swift
//  Template
//
//  Created by Daniel Brown on 19/08/2015.
//  Copyright (c) 2015 Visa Europe. All rights reserved.
//

import UIKit
import Foundation


class DonateController: UIViewController {
    
    @IBOutlet weak var applePay: UIImageView!
    @IBOutlet weak var payButton: UIImageView!
    @IBOutlet weak var menuButton: UIImageView!
    @IBOutlet weak var bigImg: UIImageView!
    
    // Tag for the hashtag to search fro
    let tag = "christmasjumperday"
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let tapGesture = UITapGestureRecognizer(target: self, action: "tappedMenu:")
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: "tappedPay:")
        tapGesture2.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tapGesture2)
        
        
        let url = NSURL(string: "https://api.instagram.com/v1/tags/" + tag + "/media/recent?client_id=7a62a9afc228484da1b307976d2c2f23")
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            // Got first page of instagram data
            let json = JSON(data: data)
            // Check to see if the response code is valid
            if(json["meta"]["code"] == 200) {
                let nextJsonUrl = json["pagination"]["next_url"].stringValue
                let nextUrl = NSURL(string: nextJsonUrl)
                let nextRequest = NSURLRequest(URL: nextUrl!)

                let imgUrl = NSURL(string: json["data"][5]["images"]["standard_resolution"]["url"].stringValue)
                self.downloadAndSetImage(imgUrl!,img: self.bigImg)
                }
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tappedMenu(tapPress: UIGestureRecognizer) {
        // Run event stuff for when this function is called as a result of the button being longPressed
        menuButton.image = UIImage(named: "Menu-3-selected")!
    }
    
    func tappedPay(tapPress: UIGestureRecognizer) {
        // Run event stuff for when this function is called as a result of the button being longPressed
        self.applePay.image = UIImage(named: "apple-pay")
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
    func downloadAndSetImage(url:NSURL, img:UIImageView){
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                img.image = UIImage(data: data!)
            }
        }
    }
    
}
