//
//  ProfessorReceiptVC.swift
//  Cs131
//
//  Created by Aaron Miller on 6/14/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class ProfessorReceiptVC: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var keyCodeLabel: UILabel!
    @IBOutlet weak var classSectionLabel: UILabel!
    @IBOutlet weak var timeAndDate: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let key = Int(arc4random_uniform(899999) + 100000)
        keyCodeLabel.text! = String(key)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
