//
//  AnimateVC.swift
//  FacebookAppPermissions
//
//  Created by Aaron Miller on 2/7/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class AnimateVC: UIViewController {

    @IBOutlet var featureView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(featureView)
         	
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
