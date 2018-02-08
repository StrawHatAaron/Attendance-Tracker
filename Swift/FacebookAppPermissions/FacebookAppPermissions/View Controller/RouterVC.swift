//
//  PutVC.swift
//  FacebookAppPermissions
//
//  Created by Aaron Miller on 1/29/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class RouterVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func put_id_title_author(_ sender: Any) {
        let session = URLSession(configuration: .default)
        let putPost = Post(userId:1, id:1, title:"title", body:"body")
        let putRequest = PostRouter.update(1, putPost).asURLRequest()
        //let putRequest = PostRouter.getAll.asURLRequest()//GET
        let putTask = session.dataTask(with: putRequest) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    print(error!)
                    return
            }
            let decoder = JSONDecoder()
            do {
                print(data)
                let post = try decoder.decode(PostWithId.self, from: data)
                // decoded data is just the Post we updated on json-server
                print(post)
            } catch let decodeError as NSError {
                print("Decoder error: \(decodeError.localizedDescription) \n")
                return
            }
        }
        putTask.resume()
    }
    
}
