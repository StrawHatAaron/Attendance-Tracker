//: Playground - noun: a place where people can play

import UIKit

func filterClosure(closure: (Int) -> Bool, numbers: [Int]) -> [Int] {
    var filterNums = [Int]()
    for num in numbers{
        if closure(num){
        filterNums.append(num)
        }
    }
    return filterNums
}

func greaterThan5(number: Int) ->Bool{
    return number > 5
}

var filteredList = filterClosure(closure: greaterThan5, numbers: [5,6,7,8,9,10,3,5,6,2,4])
print(filteredList)

var block = {
    print("the completion has been executed")
}

func runTheCodeAndComplete(text:String, completion: (()-> ())){
    completion()
    print(text)
    
}

runTheCodeAndComplete(text:"learning completion here", completion: block)
