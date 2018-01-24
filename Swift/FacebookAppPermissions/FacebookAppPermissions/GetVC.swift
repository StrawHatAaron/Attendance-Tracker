//
//  GetVC.swift
//  FacebookAppPermissions
//
//  Created by Aaron Miller on 1/22/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

struct WebsiteDescription: Decodable{
    let name: String
    let description: String
    let courses: [Course]//this is how the array happens
}

//making the props optionals will allow for possible missing fields
struct Course: Decodable {
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
}

//****** from the link "https://jsonplaceholder.typicode.com/users"
struct User: Decodable{
    let id: Int?
    let name: String?
    let username: String?
    let email: String?
    let address: Adress?
    let phone: String?
    let website: String?
    let company: Company?
}

struct Adress: Decodable {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
    let geo: Geo?
}

struct Geo: Decodable{
    let lat: String?
    let lng: String?
}

struct Company: Decodable {
    let name: String?
    let catchPhrase: String?
    let bs: String?
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
    
    func unwrapData(link: String){
        //https://jsonplaceholder.typicode.com/users
        guard let url = URL(string: link) else {return}
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                print(data)
                do {
                    //**************
                    switch link{
                        //getTheInfo
//                        case "https://jsonplaceholder.typicode.com/users":
//                            let json = try JSONSerialization.jsonObject(with: data, options: [])
//                            print(json, "json")
//                        break
                        
                        //getSimpleDecode
                        case "https://api.letsbuildthatapp.com/jsondecodable/course":
                            let course = try JSONDecoder().decode(Course.self, from: data)
                            print(course)
                            print(course.name!)
                        break
                        
                        //getArraySimpleDecode
                        case "https://api.letsbuildthatapp.com/jsondecodable/courses":
                            let courses = try JSONDecoder().decode([Course].self, from: data)
                            //print(courses, "courses")
                            print(courses[1].name!)
                        break
                        
                        //getArrayUnwrapDecode
                        case "https://api.letsbuildthatapp.com/jsondecodable/website_description":
                            let websiteDescription = try JSONDecoder().decode(WebsiteDescription.self, from: data)
                            print(websiteDescription.name, websiteDescription.description)
                        break
                        
                        //getMissingFields
                        case "https://api.letsbuildthatapp.com/jsondecodable/courses_missing_fields":
                            let courses = try JSONDecoder().decode([Course].self, from: data)
                            let cell = 2
                            if courses[cell].id != nil {
                                print(courses[cell].name!, courses[cell].id!)
                            }else{
                                print(courses[cell].name!, "The id was nil")
                            }
                        break
                        
                        //getWrappedArray -- All A
                        case "https://jsonplaceholder.typicode.com/users":
                            let users = try JSONDecoder().decode([User].self, from: data)
                            print("latitude for user 1: \(users[0].address!.geo!.lat!)")
                            print(users[0].id!)
                        break
                        
                    default:
                        print("A unspecified link was inputed")
                    }
                    //**************
                }catch{
                    print(error, "error")
                }
            }
            }.resume()
    }

    //this is about to be out of order
    @IBAction func getTheInfo(_ sender: Any) {
        unwrapData(link: "https://jsonplaceholder.typicode.com/users")
        print("getArrayDecode - GetVC.swift")
    }
    
    @IBAction func getSimpleDecode(_ sender: Any) {
        unwrapData(link: "https://api.letsbuildthatapp.com/jsondecodable/course")
        print("getSimpleDecode - GetVC.swift")
    }
    
    @IBAction func getArraySimpleDecode(_ sender: Any) {
        unwrapData(link: "https://api.letsbuildthatapp.com/jsondecodable/courses")
        print("getArraySimpleDecode - GetVC.swift")

    }
    
    @IBAction func getArrayUnwrapDecode(_ sender: Any) {
        unwrapData(link: "https://api.letsbuildthatapp.com/jsondecodable/website_description")
        print("getArrayUnwrapDecode - GetVC.swift")
    }
    
    @IBAction func getMissingFields(_ sender: Any) {
        unwrapData(link: "https://api.letsbuildthatapp.com/jsondecodable/courses_missing_fields")
        print("getMissingFields - GetVC.swift")
    }
    
    
    //try to decode here
    @IBAction func getWrappedArray(_ sender: Any) {
        unwrapData(link: "https://jsonplaceholder.typicode.com/users")
        print("getWrappedArray - GetVC.swift")
    }
}
