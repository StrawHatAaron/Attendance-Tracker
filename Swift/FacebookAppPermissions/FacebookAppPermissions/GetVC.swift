//
//  GetVC.swift
//  FacebookAppPermissions
//
//  Created by Aaron Miller on 1/22/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

struct WebsiteDescription: Decodable {
    let id: Int
    let name: String
    let link: String
    let imageUrl: String
}

class GetVC: UIViewController {

    var fistName: String?
    var lastName: String?
    var email: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func getTheInfo(_ sender: Any) {
        //https://jsonplaceholder.typicode.com/users
        guard let url = URL(string: "https://api.letsbuildthatapp.com/jsondecodable/courses") else {return}
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                print(data)
                do {
                    //let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let courses = try JSONDecoder().decode([WebsiteDescription].self, from: data)
//                    if let dict = json as? [String:Any]{
//                        if let aEmail = dict["name"] as? String{
//                            print(aEmail, "hey aaron")
//                        }
//                    }
                    print(courses, "courses")
                    //print(json, "json")
                }catch{
                    print(error, "error")
                }
            }
            }.resume()
        //print("\(self.email!) <- the email object")
    }

}
