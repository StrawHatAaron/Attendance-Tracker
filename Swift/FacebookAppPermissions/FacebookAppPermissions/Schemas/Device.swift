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
    
    public init(BaseOS:String, Manufacturer:String, Model:String, ReleaseVersion:String){
        self.BaseOS = BaseOS
        self.Manufacturer = Manufacturer
        self.Model = Model
        self.ReleaseVersion = ReleaseVersion
    }
    
    public struct DeviceWithId: Codable {
        let BaseOS: String?
        let Manufacturer: String?
        let Model: String?
        let ReleaseVersion: String?
        
        public init(BaseOS:String, Manufacturer:String, Model:String, ReleaseVersion:String){
        self.BaseOS = BaseOS
        self.Manufacturer = Manufacturer
        self.Model = Model
        self.ReleaseVersion = ReleaseVersion
        }
    }
    
}
