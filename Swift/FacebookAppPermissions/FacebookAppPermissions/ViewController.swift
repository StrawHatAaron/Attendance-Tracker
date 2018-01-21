//
//  ViewController.swift
//  FacebookAppPermissions
//
//  Created by Aaron Miller on 1/19/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController,
FBSDKLoginButtonDelegate {
    
    
    @IBOutlet weak var facebookBtn: UIButton!
    
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
            print(unwrappedResult)
            if let email = unwrappedResult["email"]  as? String{
                print(email)
            }
            guard let picture = unwrappedResult["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary else {return}
            if let url = data["url"] as? String{
                //link to my picture
                print(url)
            }
        }
    }
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
//        let fbLoginManager = FBSDKLoginManager()
//        fbLoginManager.logInWithReadPermissions(["email"], fromViewController )
        
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error){
        print("Complete Login--ViewController.swift")
//        if FBSDKAccessToken.current() != nil {
//            fetchProfile()
//            post()
//        }
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

    func post(){
        let parameters: [String: String] = ["access_token" : FBSDKAccessToken.current().tokenString ]
        //https://prod1.mytcheck.com/auth/facebook
        //http://httpbin.org/post
        guard let url = URL(string: "https://prod1.mytcheck.com/auth/facebook") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let myHttpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        request.httpBody = myHttpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }catch {
                    print(error)
                }
            }
            }.resume()
    }
    
}

