//
//  PutVC.swift
//  FacebookAppPermissions
//
//  Created by Aaron Miller on 1/29/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class PutVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func put_id_title_author(_ sender: Any) {
        let session = URLSession(configuration: .ephemeral)
        let putPost = Post(first_name:"Sandy", last_name:"Miller", email:"hello@gmail.com")
        let putRequest = PostRouter.getAll.asURLRequest()
        let putTask = session.dataTask(with: putRequest) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    print(error)
                    return
            }
            let decoder = JSONDecoder()
            do {
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
