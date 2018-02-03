//: Playground - noun: a place where people can play

//constuct a PUT request
import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true//when in the playground this needs to be here


let session = URLSession(configuration: .ephemeral)

let putPost = Post(author:"Aaron's PUT request", title:"Using post Router")
var putRequest = PostRouter.update(1, putPost).asURLRequest()

let putTask = session.dataTask(with: putRequest) { data, response, error in
    defer { PlaygroundPage.current.finishExecution() }
    guard let data = data, let response = response as? HTTPURLResponse,
        response.statusCode == 200 else {
            print("No data or statusCode not OK")
            return
    }
    let decoder = JSONDecoder()
    do {
        let post = try decoder.decode(PostWithId.self, from: data)
        // decoded data is just the Post we updated on json-server
        post
    } catch let decodeError as NSError {
        print("Decoder error: \(decodeError.localizedDescription)\n")
        return
    }
}
putTask.resume()

print("here?")
