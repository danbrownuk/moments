//
//  ViewController.swift
//  Template
//
//  Created by Daniel Brown on 19/08/2015.
//  Copyright (c) 2015 Visa Europe. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController {
    
    @IBOutlet var pageView: UIView!
    @IBOutlet var momentsImages: [UIImageView]!
    
    // Variable to define the tag to search for
    let tag = "christmasjumperday"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Fetch data from Instagram API
        if(self.momentsImages != nil) {
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
                    
                    NSURLConnection.sendAsynchronousRequest(nextRequest, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
                        // Got first page of instagram data
                        let nextJson = JSON(data: data)
//                        println(nextJson)
                        if(json["meta"]["code"] == 200) {
                            // Run through the first 20 images
                            for(var y = 0; y < 20; y++) {
                                let imgUrl = NSURL(string: json["data"][y]["images"]["thumbnail"]["url"].stringValue)
                                let imgView = self.momentsImages[y]
                                self.downloadAndSetImage(imgUrl!,img: imgView)
                            }
                            // Run through the next 7 images
                            for(var y = 20; y < 27; y++) {
                                let imgUrl = NSURL(string: nextJson["data"][y-20]["images"]["thumbnail"]["url"].stringValue)
//                                println(imgUrl)
                                let imgView = self.momentsImages[y]
                                self.downloadAndSetImage(imgUrl!,img: imgView)
                            }
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
