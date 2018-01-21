//: Playground - noun: a place where people can play

import UIKit


//Optionals are ? !
//? wrap
//! unwarp

var string: String? = "hello" //says we can hold a value or nothing at all. Opens it up to equal something or nothing

print(string!) //closes the varible for when it equals something. Only unwrapp here when it contains a value


if string != nil {
    print(string)//we can see that it is wrapped here
    print(string!)//now we can see the same value has been unwrapped
}
