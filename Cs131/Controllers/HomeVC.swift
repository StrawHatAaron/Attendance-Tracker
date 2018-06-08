//
//  ViewController.swift
//  Cs131
//
//  Created by Aaron Miller on 6/1/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var infoView: UIView!
    
    lazy var mapper = MapTracker()
    var allowCheckin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.dropShadow()
        self.allowCheckin = mapper.trackStudent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func checkIn(_ sender: Any) {
        allowCheckin = mapper.trackStudent()
        
        if allowCheckin {
            self.performSegue(withIdentifier: "homeToStudentCheckIn", sender: nil)
        } else {
            // create the alert
            let alert = UIAlertController(title: "Can't see location", message: "Please allow this app to use your location", preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func professorCheckIn(_ sender: Any) {
        self.performSegue(withIdentifier: "homeToProfessorCheckIn", sender: nil)
    }
    
    
}



