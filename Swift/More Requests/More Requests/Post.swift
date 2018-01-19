//
//  Post.swift
//  More Requests
//
//  Created by Aaron Miller on 1/18/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import Foundation

struct Post: Encodable, Decodable{
    let body: String
    let id: Int
    let title: String
    let userId: Int
}
