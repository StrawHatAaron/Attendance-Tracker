//
//  ProfessorReceiptVC.swift
//  Cs131
//
//  Created by Aaron Miller on 6/14/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class ProfessorReceiptVC: UIViewController {
    
    
    @IBOutlet weak var recieptView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var keyCodeLabel: UILabel!
    @IBOutlet weak var classSectionLabel: UILabel!
    @IBOutlet weak var timeAndDate: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    var totalTime = 900
    var timeRemaining = 900
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        recieptView.dropShadow()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let todayString = formatter.string(from: Date()) // string purpose I add here
        
        
        usernameLabel.text = UserDefaults.standard.string(forKey: "professorUsername")
        keyCodeLabel.text! = String(UserDefaults.standard.integer(forKey: "randomKey"))
        classSectionLabel.text = UserDefaults.standard.string(forKey: "classSection")
        timeAndDate.text = "Check in time was at\n \(todayString)"
        timeLeft.text! = "Time left to check in\n15:00"
        
        
        //TODO:- check AppDelegate for the date and possible keep signing in
        UserDefaults.standard.set(todayString, forKey: "userSignedOnDay")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func timerRunning() {
        timeRemaining -= 1
        let completionPercentage = Int(((Float(totalTime) - Float(timeRemaining))/Float(totalTime)) * 100)
//        progressView.setProgress(Float(timeRemaining)/Float(totalTime), animated: false)
//        progressLabel.text = "\(completionPercentage)% done"
        let minutesLeft = Int(timeRemaining) / 60 % 60
        let secondsLeft = Int(timeRemaining) % 60
        
        print(timeRemaining)
        if  secondsLeft <= 9 &&
            minutesLeft <= 9 &&
            timeRemaining >= 0 {
            timeLeft.text = "Time left to check in\n0\(minutesLeft):0\(secondsLeft)"
        } else if minutesLeft <= 9 &&
            timeRemaining >= 0 {
            timeLeft.text = "Time left to check in\n0\(minutesLeft):\(secondsLeft)"
        } else if secondsLeft <= 9 &&
            timeRemaining >= 0 {
            timeLeft.text = "Time left to check in\n\(minutesLeft): 0\(secondsLeft)"
        } else if timeRemaining >= 0 {
            timeLeft.text = "Time left to check in\n\(minutesLeft):\(secondsLeft)"
        } else {
            timeLeft.text = "Late students will have to be added manually at this point"
            timer.invalidate()
        }
        
//        manageTimerEnd(seconds: timeRemaining)
//        isOnBreak = true
    }
    

}
