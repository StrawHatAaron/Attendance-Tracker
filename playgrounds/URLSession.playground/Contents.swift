//Wrote on jan 27 2018 by Aaron Miller
//URL and URLComponents

import UIKit

var urlString = "http://itunes.apple.com/search?media=music&entity=song&term=abba"
let url = URL(string: urlString)
//properties
url?.absoluteString
url?.scheme
url?.host
url?.path
url?.query
url?.baseURL


//: 'baseURL' is useful for building REST API urls.
let baseURL = URL(string: "https://itunes.apple.com")
let relativeURL = URL(string: "search", relativeTo: baseURL)
relativeURL?.absoluteString
url?.scheme
url?.host
url?.path
url?.query
url?.baseURL


//: URL Components and URL encoding
var urlComponents = URLComponents(string: "https://itunes.apple.com/search?media=music&entity=song")
var queryItem = URLQueryItem(name: "term", value: "crow")
urlComponents?.queryItems?.append(queryItem)
urlComponents?.url

//: URL encode "smiling cat face with heart shaped eyes"
queryItem = URLQueryItem(name: "emoji", value: "😻")
urlComponents?.queryItems?.append(queryItem)

//the quickest way to get a session is to use the shared singleton session
let sharedSession = URLSession.shared
//notice the shared session will always allow URL access
sharedSession.configuration.allowsCellularAccess = false
sharedSession.configuration.allowsCellularAccess




//create a session that does not allow celluar access
let myDefaultConfiguration = URLSessionConfiguration.default
myDefaultConfiguration.allowsCellularAccess
myDefaultConfiguration.waitsForConnectivity
myDefaultConfiguration.allowsCellularAccess = false
myDefaultConfiguration.allowsCellularAccess
//set waitsForConnectivity to true, for this non-background config
myDefaultConfiguration.waitsForConnectivity = true
//set multipathServiceType to .handover, and update allowsCelluarAccess to match
myDefaultConfiguration.multipathServiceType = .handover
myDefaultConfiguration.allowsCellularAccess = true
//now create a session with this configuration
let myDefaultSession = URLSession(configuration: myDefaultConfiguration)
//check the session's values of the configuration properties you set:
myDefaultSession.configuration.allowsCellularAccess
myDefaultSession.configuration.waitsForConnectivity


//the quicker way to do this is to declare the session with the defualt props
let defaultSession = URLSession(configuration: .default)
defaultSession.configuration.allowsCellularAccess
defaultSession.configuration.waitsForConnectivity

//the disk capacity of the default configuration is 10 million bytes
URLSessionConfiguration.default.urlCache?.diskCapacity

//lets look at the memory capacity of the cache
myDefaultConfiguration.urlCache?.memoryCapacity

//create a ephemeral configuration and check the disk and memory capacity
let ephemeralConfiguration = URLSessionConfiguration.ephemeral
ephemeralConfiguration.urlCache?.diskCapacity
ephemeralConfiguration.urlCache?.memoryCapacity

//ephemeral means that there will be no persistant storage, cache or cookies. This means they will not stay in memory
//but there might be a situation where you want a persistant cache, and are happy with not persisting cookies or credentials


//HOW to customize your cache
//Create a URLCache object with memoryCapacity 512000 and diskCapacity 10000000, and assign it to the configuration urlCache property:
let cache = URLCache(memoryCapacity: 512000, diskCapacity: 10000000, diskPath: nil)
ephemeralConfiguration.urlCache = cache
ephemeralConfiguration.urlCache?.diskCapacity









