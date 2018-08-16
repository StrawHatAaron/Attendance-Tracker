//
//  ViewController.swift
//  FacebookAppPermissions
//
//  Created by Aaron Miller on 2/4/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit
//import FBSDKShareKit

class DLFilesBackgroundVC: UIViewController, URLSessionDelegate {

    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "MySession")
        config.isDiscretionary = true//allows apps to load in the background of other apps
        config.sessionSendsLaunchEvents = true//since it is true it will wait till wifi is available
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDFU()
    }

    func checkDFU(){
        var url = URL(string: "google.com")
        let backgroundTask = urlSession.downloadTask(with: url!)
        if #available(iOS 11.0, *) {
            backgroundTask.earliestBeginDate = Date().addingTimeInterval(60 * 60)
            backgroundTask.countOfBytesClientExpectsToSend = 200//best guess upper and lower bounds
            backgroundTask.countOfBytesClientExpectsToReceive = 500 * 1024//same as above
            backgroundTask.resume()//start the task
        } //set the download time to some point in the future
        
        else {
            // Fallback on earlier versions
        }
//        if FBSDKAccessToken.current() != nil{
//            print("Logged in Facebook")
//        }
//        else {
//            print("Not logged in do not check for DFU -- DLFilesBackgroundVC")
//        }
    }
    
}
