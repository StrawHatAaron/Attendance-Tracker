//
//  CreateAccountVC.swift
//  FacebookAppPermissions
//
//  Created by Aaron Miller on 1/22/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var firstName:  String?
    var lastName:   String?
    var email:      String?
    var password:   String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func firstNameEdited(_ sender: Any) {
        firstName = firstNameField.text!
    }
    
    @IBAction func lastNameEdited(_ sender: Any) {
        lastName = lastNameField.text!
    }
    
    @IBAction func emailEdited(_ sender: Any) {
        email = emailField.text!
    }
    
    
    @IBAction func pwdEdited(_ sender: Any) {
        
        password = passwordField.text!
    }
    
    @IBAction func createAccount(_ sender: Any) {
        checkData()
    }
    
    func checkData(){
        if firstName == nil || lastName == nil || email == nil || password == nil{
            print("something was not edited -- unwrapping with ! \(firstName!)")
        }else{
            post()
        }
    }
    
    //post JSON to the server
    func post(){
        let parameters: [String: String] = ["firstName" : firstName!,
                                            "lastName"  : lastName!,
                                            "email"     : email!,
                                            "password"  : password!]
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/employees") else {return}
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
