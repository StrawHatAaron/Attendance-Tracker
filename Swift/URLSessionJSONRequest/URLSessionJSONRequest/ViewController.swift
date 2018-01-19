//
//  ViewController.swift
//  URLSessionJSONRequest
//
//  Created by Aaron Miller on 1/18/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onGetTapped(_ sender: Any) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                print(data)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json, "json")
                }catch{
                    print(error, "error")
                }
            }
        }.resume()
        
    }
    
    @IBAction func onPostTapped(_ sender: Any) {
//        https://jsonplaceholder.typicode.com/users
        //let parameters: [String] = ["{\u{22}username\u{22}:\u{22}lafjlkfjfl;akfjafa\u{22}}"]
        let parameters = ["access_token" : "123alsdkjfoiuwe"]
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let myHttpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else{ return }
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

