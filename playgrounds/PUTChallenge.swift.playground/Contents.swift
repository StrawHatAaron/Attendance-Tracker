//: Playground - noun: a place where people can play

//constuct a PUT request
import Foundation
import PlaygroundSupport

let session = URLSession(configuration: .ephemeral)

let putPost = Post(author:"a friend of alamofire", title:"Using post Router")
let putRequest = PostRouter.update(1, putPost).asURLRequest()

putRequest.httpMethod//its a PUT

let putTask = session.dataTask(with: putRequest) { data, response, error in
    print("do we get here")
    defer { PlaygroundPage.current.finishExecution()}
    
    guard let data = data, let response = response as? HTTPURLResponse,
    response.statusCode == 200 else {
            print("No data or statusCode is not OK")
            return
    }
    let decoder = JSONDecoder()
    do {
        print("hmmm...")
        let post = try decoder.decode(PostWithId.self, from: data)
        post
    }catch let decodeError as NSError {
        print("here?")
        print("Decoder error: \(decodeError.localizedDescription)\n")
        return
    }
}
putTask.resume()

print("here?")




