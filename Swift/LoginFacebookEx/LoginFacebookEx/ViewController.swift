//
//  ViewController.swift
//  LoginFacebookEx
//
//  Created by Aaron Miller on 1/13/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//
import FacebookLogin
import FBSDKLoginKit

class ViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

