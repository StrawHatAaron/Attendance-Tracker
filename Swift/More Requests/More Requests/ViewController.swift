//
//  ViewController.swift
//  More Requests
//
//  Created by Aaron Miller on 1/18/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func onSendPostTapped(_ sender: Any) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let newPost = Post(body: "This is encoding", id: 5, title: "encoding stuff", userId: 2)
        
        do{
            let jsonBody = try JSONEncoder().encode(newPost)
            request.httpBody = jsonBody
        }catch{}
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, _, error) in
            guard let data = data else {return}
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }catch{
                print(error, "Aaron")
            }
        }
        task.resume()
    }
    
    @IBAction func onGetUsersTapped(_ sender: Any) {
        
    }
    
}

