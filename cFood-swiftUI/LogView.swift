//
//  LogView.swift
//  cFood-swiftUI
//
//  Created by Derek Hsieh on 11/30/20.
//

import SwiftUI

struct LogView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: FoodItem.getAllFoodItems()) var foodItems: FetchedResults<FoodItem>
    
    
    
    var body: some View {
        List {
            ForEach(self.foodItems) { foodItem in
                Text(foodItem.name!)
            }.onDelete { (indexSet) in
                let deleteItem = self.foodItems[indexSet.first!]
                self.managedObjectContext.delete(deleteItem)
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
