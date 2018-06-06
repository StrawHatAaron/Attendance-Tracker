//
//  ViewController.swift
//  Cs131
//
//  Created by Aaron Miller on 6/1/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var mapper = MapTracker()
    var allowCheckin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        allowCheckin = mapper.trackStudent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func checkIn(_ sender: Any) {
        allowCheckin = mapper.trackStudent()
        
        if allowCheckin {
            self.performSegue(withIdentifier: "homeToCheckIn", sender: nil)
        } else {
            // create the alert
            let alert = UIAlertController(title: "Can't see location", message: "Please allow this app to use your location", preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    

}

