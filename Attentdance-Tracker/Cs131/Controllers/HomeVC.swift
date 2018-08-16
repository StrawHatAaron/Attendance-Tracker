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
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var linkButton: UIButton!
    
    lazy var mapper = MapTracker()
    var allowCheckin = false
    var studentInGoodLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.dropShadow()
        
        reminderLabel.font = reminderLabel.font.withSize(self.view.frame.height * 0.03)
        welcomeLabel.font = welcomeLabel.font.withSize(self.view.frame.height * 0.03)
        helpButton.titleLabel?.font = helpButton.titleLabel?.font.withSize(self.view.frame.height * 0.05)
        linkButton.titleLabel?.font = linkButton.titleLabel?.font.withSize(self.view.frame.height * 0.05)
        
        self.allowCheckin = mapper.trackStudent()
        studentInGoodLocation = mapper.studentInRightLocation
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goToSheet(_ sender: Any) {
        if let url = URL(string: "https://docs.google.com/spreadsheets/d/1Wfzp2tntIWo_0G5ZY58agToUHtBpFx_IYfaLkgOJGBc/edit#gid=0"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBAction func checkIn(_ sender: Any) {
        allowCheckin = mapper.trackStudent()
        studentInGoodLocation = mapper.studentInRightLocation
        print(studentInGoodLocation)
        
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



