//
//  ViewController.swift
//  FacebookAppPermissions
//
//  Created by Aaron Miller on 1/19/18.
//  Copyright © 2018 tCheck. All rights reserved.
//

import UIKit
//import FBSDKLoginKit

class ViewController: UIViewController{
    
    @IBOutlet weak var facebookBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        }
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
//        let fbLoginManager = FBSDKLoginManager()
//        fbLoginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self)
//        {(result, err) in
//            if err != nil {
//                print("Custom FB login failed", err)
//                return
//            }
//            else{
//                //print(FBSDKAccessToken.current().tokenString)
//                fetchProfile()
//                if FBSDKAccessToken.current() != nil {
//                    post()
//                }
//                //don't forget to move to the next view
//            }
//        }
//    }
    
}
    //
//    func fetchProfile(){
//        print("fetch profile-- ViewController.swift")
//        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
//        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start{
//            (connection, result, error) -> Void in
//            if error != nil {
//                print(error)
//            }
//            guard let unwrappedResult = result as? [String: Any] else {return}
//            print(unwrappedResult)
//            if let email = unwrappedResult["email"]  as? String{
//                print(email)
//            }
//            guard let picture = unwrappedResult["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary else {return}
//            if let url = data["url"] as? String{
//                //link to my picture
//                print(url)
//            }
//        }
//    }

    //post JSON to the server

}
    


