//: Playground - noun: a place where people can play

import UIKit

//"date": "2017-09-11T06:45:07.488Z",

let formatter = DateFormatter()
// initially set the format based on your datepicker date
formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

let myString = formatter.string(from: Date())
// convert your string to date
let yourDate = formatter.date(from: myString)
//then again set the date format whhich type of output you need
formatter.dateFormat = "dd-MMM-yyyy"
// again convert your date to string
let myStringafd = formatter.string(from: yourDate!)

print(myStringafd)
