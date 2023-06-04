//
//  CDEmployee+CoreDataProperties.swift
//  BjitExpress
//
//  Created by YeasirArefinTusher-11702 on 19/5/23.
//
//

import Foundation
import CoreData


extension CDEmployee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDEmployee> {
        return NSFetchRequest<CDEmployee>(entityName: "CDEmployee")
    }

    @NSManaged public var email: String?
    @NSManaged public var employee_id: String?

}

extension CDEmployee : Identifiable {

}
