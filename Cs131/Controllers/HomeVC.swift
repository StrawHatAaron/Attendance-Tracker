//
//  ViewController.swift
//  Cs131
//
//  Created by Aaron Miller on 6/1/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, ShowAlert {

    @IBOutlet weak var infoView: UIView!
    
    lazy var mapper = MapTracker()
    var allowCheckin = false
    var studentInGoodLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.dropShadow()
        self.allowCheckin = mapper.trackStudent()
        studentInGoodLocation = mapper.studentInRightLocation
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func checkIn(_ sender: Any) {
        allowCheckin = mapper.trackStudent()
        studentInGoodLocation = mapper.studentInRightLocation
        
        if allowCheckin && studentInGoodLocation {
            self.performSegue(withIdentifier: "homeToStudentCheckIn", sender: nil)
        }
        else if allowCheckin {
            showAlert("Seems like your not in the right place", message: "go to class.", action: "Ok")
        }
        else {
            // create the alert
            showAlert("Can't see location", message: "Please allow this app to use your location", action:"Ok")
        }
    }
    
    @IBAction func professorCheckIn(_ sender: Any) {
        self.performSegue(withIdentifier: "homeToProfessorCheckIn", sender: nil)
    }
    
    
}



