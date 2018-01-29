//: Playground - noun: a place where people can play

import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let config = URLSessionConfiguration.default
config.waitsForConnectivity = true
let defaultSession = URLSession(configuration: config)

let urlString = "http://localhost:3000/posts/"
let url = URL(string: urlString)!

let decoder = JSONDecoder()
struct Post : Decodable{
    let id: Int
    let author: String
    let title: String
}

var posts: [Post] = []
var errorMessage = ""

//when exiting the handler, the page can finish execution
let task = defaultSession.dataTask(with: url){ data, response, error in
    defer { PlaygroundPage.current.finishExecution() }
    if let error = error{
        errorMessage += "DataTask error: " + error.localizedDescription + "\n"
    }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200{
        do{
            let posts = try decoder.decode([Post].self, from: data)
            posts
        }catch let decodeError as NSError{
            errorMessage += "Decoder error: \(decodeError.localizedDescription)"
        }
        errorMessage
    }
}
task.resume()

