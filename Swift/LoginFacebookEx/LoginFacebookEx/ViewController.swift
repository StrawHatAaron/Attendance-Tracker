//
//  ViewController.swift
//  LoginFacebookEx
//
//  Created by Aaron Miller on 1/13/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//
import FacebookLogin
import FBSDKLoginKit
//import AeroGearHttp
//import AeroGearOAuth2

class ViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
        doLogin()
    }
    
    func doLogin() -> Void {
        
//        let net = Net(baseUrlString: "http://myhost.com/")
//
//        let url = "auth/facebook_access_token"
//
//        let params = ["access_token": myToken]
//
//        net.GET(url, params: params, successHandler: { responseData in
//            let result = responseData.json(error: nil)
//            // Do something with whatever you got back
//            NSLog("result \(result)")
//        }, failureHandler: { error in
//            NSLog("Error")
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

