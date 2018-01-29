//: Playground - noun: a place where people can play

//constuct a PUT request
import Foundation
import PlaygroundSupport

public struct Post: Codable {
    let author: String
    let title: String
    
    public init(author: String, title: String) {
        self.author = author
        self.title = title
    }
}

public enum PostRouter {
    
    // Possible requests
    case getAll
    case get(Int)
    case create(Post)
    case update(Int, Post)
    case delete(Int)
    
    // Base endpoint
    static let baseURLString = "http://localhost:3000/posts/"
    
    // Set the method
    var method: String {
        // TODO: Return "GET", "POST", "PUT" or "DELETE", as appropriate
        switch self {
        case .getAll, .get: return "GET"
        case .create: return "POST"
        case .update: return "PUT"
        case .delete: return "DELETE"
        }
    }
    
    // Construct the request from url, method and parameters
    public func asURLRequest() -> URLRequest {
        // Build the request endpoint
        let url: URL = {
            let relativePath: String?
            // TODO: Set relativePath to use id, as appropriate
            switch self {
            case .getAll, .create: relativePath = ""
            case .get(let id), .update(let id, _), .delete(let id): relativePath = "\(id)"
            }
            
            var url = URL(string: PostRouter.baseURLString)!
            if let path = relativePath {
                url = url.appendingPathComponent(path)
            }
            return url
        }()
        
        // Set up request parameters
        let parameters: Post? = {
            switch self {
            case .getAll, .get, .delete: return nil
            case .create(let post), .update(_, let post): return post
            }
        }()
        
        // Create request
        var request = URLRequest(url: url)
        // TODO: Set httpMethod
        request.httpMethod = method
        // TODO: Set HTTP header field content-type to application/json
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        // TODO: If there are parameters, and they can be converted to data, set httpBody
        guard let post = parameters else {return request}
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(post)
            request.httpBody = data
        }catch let encodeError as NSError{
            print("Encoder Error : \(encodeError.localizedDescription)\n")
        }
        
        
        return request
    }
    
}

let session = URLSession(configuration: .ephemeral)

let putPost = Post(author:"aaron", title:"is cool")
var putRequest = PostRouter.update(1, putPost).asURLRequest()

let putTask = session.dataTask(with: putRequest) { data, response, error in
    defer { PlaygroundPage.current.finishExecution()}
    guard let data = data, let response = response as? HTTPURLResponse,
        response.statusCode == 200 else {
            print("No data or statusCode is not OK")
            return
    }
    let decoder = JSONDecoder()
    do {
        //let post = try decoder.decode(post, from: data)
        //post
    }catch let decodeError as NSError {
        print("Decoder error: \(decodeError.localizedDescription)\n")
    }
}
putTask.resume()






