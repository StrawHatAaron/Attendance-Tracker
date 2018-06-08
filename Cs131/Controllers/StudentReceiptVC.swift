//
//  ReceiptVC.swift
//  Cs131
//
//  Created by Aaron Miller on 6/8/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class StudentReceiptVC: UIViewController {
    
    @IBOutlet weak var recieptView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recieptView.dropShadow()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
