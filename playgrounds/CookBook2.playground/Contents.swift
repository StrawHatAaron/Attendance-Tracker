import Foundation
import PlaygroundSupport

let session = URLSession(configuration: .ephemeral)
let url = URL(string:"http://localhost:3000/posts/")!

let task = session.dataTask(with: url)
task.currentRequest?.url
task.currentRequest?.description
task.currentRequest?.httpMethod
task.currentRequest?.allowsCellularAccess
task.currentRequest?.httpShouldHandleCookies
task.currentRequest?.timeoutInterval
task.currentRequest?.cachePolicy
task.currentRequest?.networkServiceType
task.currentRequest
task.currentRequest?.allHTTPHeaderFields

//TODO 1 of 13: Create and a data task with a custom request, first create your request:
var request = URLRequest(url: url)

//TODO 2 of 13: URLRequest is a struct so, declaring it as "var" allows us to modify its properties. Specify a non-defualt cache policy and network service type:
request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
request.networkServiceType = .background

//TODO 3 of 13: Specify this request access the network only on wi-fi -- faster, less battery drain, and it preserves the user's data quota:
request.allowsCellularAccess = false

//TODO 4 of 13: When the request is ready, create the data task:
let taskWithRequest = session.dataTask(with: request)

//TODO 5 of 13: Check the task's "httpMethod" property:
taskWithRequest.currentRequest?.httpMethod

//TODO 6 of 13: Change the request's "httpMethod" property to POST:
request.httpMethod = "POST"

//TODO 7 of 13: To send JSON, not an encoded form, set the header field "content-type" to appilcation/json:
request.addValue("application/json", forHTTPHeaderField: "content-type")

//TODO 8 of 13: A POST task sends data, so JSON-encode a "Post" object for the request's httpBody:
struct Post: Codable {
    //let id: Int
    let author: String
    let title: String
}
let encoder = JSONEncoder()
let post = Post(author: "me", title: "aaron did a post now because it is in his json server")
do {
    let data = try encoder.encode(post)
    request.httpBody = data
} catch let encodeError as NSError{
    print("Encoder error: \(encodeError.localizedDescription)")
    PlaygroundPage.current.finishExecution()
}

//TODO 9 of 13: Check the "taskWithRequest" properties:
taskWithRequest.currentRequest?.httpMethod//SEE it is still GET

//TODO 10 of 13: Just one setting shows that you must set up the request completely before creating the task, so create another task, with the now-complete "request", and set up its handler to JSON-decode the response data:
let postTask = session.dataTask(with: request) {data, response, error in
    defer {PlaygroundPage.current.finishExecution()}
    guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 201 else{
        print("No data or statusCode not CREATED")
        return
    }
    let decoder = JSONDecoder()
    do{
        let post = try decoder.decode(Post.self, from: data)
        post
    }catch let decodeError as NSError {
        print("Decoder error: \(decodeError.localizedDescription)")
        return
    }
}

//TODO 11 of 13: Check the task's httpMethod, header fields and httpBody:
postTask.currentRequest?.httpMethod
postTask.currentRequest?.allHTTPHeaderFields
postTask.currentRequest?.httpBody

//TODO 12 of 13: resume the task, to run it
postTask.resume()

//TODO 13 of 13: Check the task's "httpBody" again
postTask.currentRequest?.httpBody





