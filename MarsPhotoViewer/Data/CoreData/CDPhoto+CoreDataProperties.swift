//
//  CDPhoto+CoreDataProperties.swift
//  
//
//  Created by Sergey Roslyakov on 7/30/18.
//
//

import Foundation
import CoreData


extension CDPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPhoto> {
        return NSFetchRequest<CDPhoto>(entityName: "CDPhoto")
    }

    @NSManaged public var imgSrc: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var id: Int64

}
