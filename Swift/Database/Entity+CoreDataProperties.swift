//
//  Entity+CoreDataProperties.swift
//  Database
//
//  Created by Aaron Miller on 1/21/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var titletext: String?
    @NSManaged public var descriptiontext: String?
    @NSManaged public var image: NSData?

}
