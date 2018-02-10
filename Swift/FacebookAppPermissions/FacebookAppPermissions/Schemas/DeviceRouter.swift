//
//  DeviceInfo.swift
//  FacebookAppPermissions
//
//  Created by Aaron Miller on 2/7/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import Foundation

public struct Device: Codable {
    let BaseOS: String?
    let Manufacturer: String?
    let Model: String?
    let ReleaseVersion: String?
    let id: Int?
    
    public init(BaseOS:String, Manufacturer:String, Model:String, ReleaseVersion:String, id:Int){
        self.BaseOS = BaseOS
        self.Manufacturer = Manufacturer
        self.Model = Model
        self.ReleaseVersion = ReleaseVersion
        self.id = id
    }
}
    
    public struct DeviceWithId: Codable {
        let BaseOS: String
        let Manufacturer: String
        let Model: String
        let ReleaseVersion: String
        let id: Int
        
        public init(BaseOS:String, Manufacturer:String, Model:String, ReleaseVersion:String, id:Int){
        self.BaseOS = BaseOS
        self.Manufacturer = Manufacturer
        self.Model = Model
        self.ReleaseVersion = ReleaseVersion
        self.id = id
        }
    }
    public enum DeviceRouter {
        // Possible requests
        case getAll
        case get(Int)
        case create(Device)
        case update(Int, Device)
        case delete(Int)
        // Base endpoint
        static let baseURLString = "http://localhost:3000/devices"
        // Set the method
        var method: String {
            // DONE: Return "GET", "POST", "PUT" or "DELETE", as appropriate
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
                // DONE: Set relativePath to use id, as appropriate
                switch self {
                case .getAll, .create: relativePath = ""
                case .get(let id), .update(let id, _), .delete(let id): relativePath = "\(id)"
                }
                var url = URL(string: DeviceRouter.baseURLString)!
                if let path = relativePath {
                    url = url.appendingPathComponent(path)
                }
                return url
            }()
            // Set up request parameters
            let parameters: Device? = {
                switch self {
                case .getAll, .get, .delete: return nil
                case .create(let device), .update(_, let device): return device
                }
            }()
            // Create request
            var request = URLRequest(url: url)
            // DONE: Set httpMethod
            request.httpMethod = method
            // DONE: Set HTTP header field content-type to application/json
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            // DONE: If there are parameters, and they can be converted to data, set httpBody
            guard let device = parameters else { return request }
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(device)
                request.httpBody = data
            } catch let encodeError as NSError {
                print("Encoder error: \(encodeError.localizedDescription)\n")
            }
            return request
    }
}


