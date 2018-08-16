//
//  ViewController.swift
//  Cs131
//
//  Created by Aaron Miller on 6/8/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

// Put this piece of code anywhere you like
extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
