import Foundation
// the playground must keep running until the asynchronous task completes:
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

//***Cookbook 1 : iTunes query data task***

//default session with waitsForConnectivity

let config = URLSessionConfiguration.default
config.waitsForConnectivity = true
let defaultSession = URLSession(configuration: config)

//Track TrackList and QueryService

struct Track: Decodable{
    let trackName: String
    let artistName: String
    let previewUrl: String
}

struct TrackList: Decodable{
    let track: [Track]
}

class QueryService {
    var tracks: [Track] = []
    var errorMessage = ""
    
    func getSearchResults(){
        let url = URL(string: "http://itunes.apple.com/search?media=music&entity=song&term=abba")!
        let task = defaultSession.dataTask(with: url){ data, response, error in
            defer { PlaygroundPage.current.finishExecution() }
            if let error = error{
                self.errorMessage += "DataTask errorL: " + error.localizedDescription + "\n"
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200{
                self.updateSearchResults(data)
                self.tracks
                self.errorMessage
            }
        }
    }
    
    func updateSearchResults(_ data: Data){
        tracks.removeAll()
    }
    
    
    
    
}
    
if let str:String = "hello" {
    print("it was not turned to a string")
}
//print(str)
    
    
    
    

