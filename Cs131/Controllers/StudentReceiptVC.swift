//
//  ReceiptVC.swift
//  Cs131
//
//  Created by Aaron Miller on 6/8/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class StudentReceiptVC: StudentNetwork {
    
    @IBOutlet weak var receiptView: UIView!
    @IBOutlet weak var studentIDLabel: UILabel!
    @IBOutlet weak var timeSubmittedLabel: UILabel!
    @IBOutlet weak var classSection: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        print("hmmm1")
        receiptView.dropShadow()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let todayString = formatter.string(from: Date()) // string purpose I add here
        print("hmmm2")
        studentIDLabel.text = UserDefaults.standard.string(forKey: "studentID")
        timeSubmittedLabel.text = todayString
        classSection.text = UserDefaults.standard.string(forKey: "classSection")
        
        
        self.studentPostX()
        print("hmmm3")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("ummm mem warn")
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
