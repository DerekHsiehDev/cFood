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
}
