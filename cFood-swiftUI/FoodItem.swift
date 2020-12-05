//
//  FoodItem.swift
//  cFood-swiftUI
//
//  Created by Derek Hsieh on 12/1/20.
//

import Foundation
import CoreData

public class FoodItem: NSManagedObject, Identifiable {
    @NSManaged public var date: Date?
    @NSManaged public var name: String?
    @NSManaged public var servingSize: String?
    @NSManaged public var proteins: NSNumber?
    @NSManaged public var fats: NSNumber?
    @NSManaged public var calories: NSNumber?
    @NSManaged public var carbs: NSNumber?
    
}

extension FoodItem {
    static func getAllFoodItems() -> NSFetchRequest<FoodItem> {
        let request: NSFetchRequest<FoodItem> = FoodItem.fetchRequest() as! NSFetchRequest<FoodItem>
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
    
    static func getTodayFoodItems() -> NSFetchRequest<FoodItem> {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        
        let request: NSFetchRequest<FoodItem> = FoodItem.fetchRequest()
        as! NSFetchRequest<FoodItem>
        
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "date < %@",  dateTo! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        request.predicate = datePredicate
        
        request.sortDescriptors = []
        
        return request
    }
    
    static func getitemsFlipped() -> NSFetchRequest<FoodItem> {
        let request: NSFetchRequest<FoodItem> = FoodItem.fetchRequest() as! NSFetchRequest<FoodItem>
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request

    }
    
    //TODO: Track week is in progress
    
//    static func getLastWeekFoodItems() -> NSFetchRequest<FoodItem> {
//
//        var calendar = Calendar.current
//        calendar.timeZone = NSTimeZone.local
//        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
//        let dateTo = Date()
//
//        let request: NSFetchRequest<FoodItem> = FoodItem.fetchRequest()
//        as! NSFetchRequest<FoodItem>
//
//        let fromPredicate = NSPredicate(format: "date >= %@", lastWeekDate as NSDate)
//        let toPredicate = NSPredicate(format: "date < %@",  dateTo as NSDate)
//        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
//        request.predicate = datePredicate
//
//        request.sortDescriptors = []
//
//        return request
//    }
}
