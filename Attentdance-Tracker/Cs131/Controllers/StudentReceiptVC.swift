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
    var studentID: String = ""
    var classSectionS:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        print("hmmm1")
        receiptView.dropShadow(color: UIColor.black, offSet: CGSize(width: 0.5, height: 1))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let todayString = formatter.string(from: Date()) // string purpose I add here
        print("hmmm2")
        studentIDLabel.text = studentID
        timeSubmittedLabel.text = todayString
        classSection.text = classSectionS
        
        
        print("hmmm3")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("ummm mem warn")
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
