//
//  ViewController.swift
//  Image-Gal
//
//  Created by Aaron Miller on 1/15/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var imageInt = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func back(_ sender: Any) {
        imageInt -= 1
        self.imageGallery()
    }
    
    @IBAction func next(_ sender: Any) {
        imageInt += 1
        self.imageGallery()
    }
    
    func imageGallery(){
        switch imageInt {
        case 1:
            self.imageView.image = #imageLiteral(resourceName: "Image1")
            self.label.text = "1/6"
        case 2:
            self.imageView.image = #imageLiteral(resourceName: "Image3")
            self.label.text = "2/6"
        case 3:
            self.imageView.image = #imageLiteral(resourceName: "Image5")
            self.label.text = "3/6"
        case 4:
            self.imageView.image = #imageLiteral(resourceName: "Image4")
            self.label.text = "4/6"
        case 5:
            self.imageView.image = #imageLiteral(resourceName: "Image6")
            self.label.text = "5/6"
        default:
            self.imageView.image = #imageLiteral(resourceName: "Image2")
            self.label.text = "6/6"
        }
    }
}

