//
//  PhotoCardData+CoreDataProperties.swift
//  
//
//  Created by 효우 on 2022/10/12.
//
//

import Foundation
import CoreData


extension PhotoCardData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoCardData> {
        return NSFetchRequest<PhotoCardData>(entityName: "PhotoCardData")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var memoText: String?
    @NSManaged public var image: Data?
    
    var dateString: String? {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = self.date else { return "" }
        let savedDateString = myFormatter.string(from: date)
        return savedDateString
    }
}
