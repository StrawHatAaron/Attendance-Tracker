//
//  MySwiftObject.swift
//  HybridApp
//
//  Created by Aaron Miller on 1/16/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import Foundation

class MySwiftObject : NSObject {
    
    var someProperty: AnyObject = "Some Initializer Val" as AnyObject
    
    override init() {}
    
    func someFunction(someArg:AnyObject) -> String {
        var returnVal = "You sent me \(someArg)"
        return returnVal
    }
}
