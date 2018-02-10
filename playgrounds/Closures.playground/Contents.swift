//: Playground - noun: a place where people can play

import UIKit

let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
//func backward(_ s1: String, _ s2: String) -> Bool {
//    return s1 > s2
//}
//var reversedNames = names.sorted(by: backward)
var reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})



