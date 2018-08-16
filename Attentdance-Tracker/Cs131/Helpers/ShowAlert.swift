//
//  ShowAlert.swift
//  Cs131
//
//  Created by Aaron Miller on 6/15/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

protocol ShowAlert {}

extension ShowAlert where Self: UIViewController{
    
    func showAlert(_ title:String, message: String, action:String){
        let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        present(alertController, animated: true, completion:nil)
    }
}
