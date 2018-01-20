//
//  ViewController.swift
//  FacebookAppPermissions
//
//  Created by Aaron Miller on 1/19/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
        
        if let token = FBSDKAccessToken.current(){
            fetchProfile()
        }
    }
    
    func fetchProfile(){
        print("fetch profile-- ViewController.swift")
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start{
            (connection, result, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            guard let unwrappedResult = result as? [String: Any] else {return}
            let email = unwrappedResult["email"]  as! String
            print(email)
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error){
        print("Complete Login--ViewController.swift")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

