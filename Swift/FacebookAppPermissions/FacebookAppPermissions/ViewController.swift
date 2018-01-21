//
//  ViewController.swift
//  FacebookAppPermissions
//
//  Created by Aaron Miller on 1/19/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController{
    
    @IBOutlet weak var facebookBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        }
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self)
        {(result, err) in
            if err != nil {
                print("Custom FB login failed", err)
                return
            }
            else{
                print(FBSDKAccessToken.current().tokenString)
                fetchProfile()
                post()
                //don't forget to move to the next view
            }
        }
    }
    
}
    //
    func fetchProfile(){
        print("fetch profile-- ViewController.swift")
        
        
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start{
            (connection, result, error) -> Void in
            if error != nil {
                print(error)
                //return
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

    //post JSON to the server
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



    


