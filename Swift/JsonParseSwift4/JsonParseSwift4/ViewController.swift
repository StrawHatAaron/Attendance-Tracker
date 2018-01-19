//
//  ViewController.swift
//  JsonParseSwift4
//
//  Created by Aaron Miller on 1/18/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    struct Course: Decodable{
        let id: Int
        let name: String
        let link: String
        let imageURL: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let jsonUrlString = "http://httpbin.org/post"
        guard let url = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url){
            (data, response, err) in
            //check err
            //check response status
            guard let data = data else {return}
            do{
                let courses = try JSONDecoder().decode([Course].self, from: data)
                print(courses)
            }
            catch let jsonErr{
                print("Error setializing json", jsonErr)
            }
            
        }.resume()
        
//        let myCourse = Course(id: 1, name: "my course", link: "some link", imageURL: "some image url")
//        print(myCourse)
    }
}

