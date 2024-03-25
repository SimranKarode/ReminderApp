//
//  Remind+CoreDataProperties.swift
//  
//
//  Created by Simran on 25/03/24.
//
//

import Foundation
import CoreData


extension Remind {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Remind> {
        return NSFetchRequest<Remind>(entityName: "Remind")
    }

    @NSManaged public var dateTime: Date?
    @NSManaged public var id: Int16
    @NSManaged public var subtitleRemind: String?
    @NSManaged public var titleRemind: String?

}
