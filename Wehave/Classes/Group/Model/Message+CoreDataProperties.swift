//
//  Message+CoreDataProperties.swift
//  
//
//  Created by JS_Coder on 2018/6/19.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var text: String?
    @NSManaged public var date: Date?
    @NSManaged public var isSender: NSNumber?
    @NSManaged public var friends: Friend?

}
