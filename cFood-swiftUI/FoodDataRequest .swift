//
//  FoodDataRequest .swift
//  cFood-swiftUI
//
//  Created by Derek Hsieh on 11/26/20.
//

import SwiftUI

let url1 = "https://api.nal.usda.gov/fdc/v1/foods/search?api_key=Sn0e8UspfDk8lqDg8bviHCrBpTKYPdWu3v23f2OE&query="



struct NutritionalData: Codable {
    let labelNutrients : LabelNutrient
}

struct LabelNutrient: Codable {
    let calories : Calory
}

struct Calory: Codable {
    let value: Float
}


struct FoodData: Codable {
    let foods: [Foods]
    
}

struct Foods: Codable {
    let fdcId: Int
}

class NutritionViewModel: ObservableObject {
    

    @Published var calories = Float()
    @Published var nutritionArr = [String]()
    @Published var carbs = Float()
    @Published var fat = Float()
    @Published var protein = Float()
    @Published var servingSize = String()
    
    
    var fdcId: Int = 0
    
    
    func request(query: String) {
//        fetchCalories(fdcId: fetchFdc(query: query))
        
        fetchFdc(query: query)
    }
    
    func fetchFdc(query: String)  {
        
        guard let url = URL(string: url1 + query) else {return}
        
  
        URLSession.shared.dataTask(with: url) { (fetchedData, response, error) in
            
            if error == nil {
                let decodedData = ( try! JSONDecoder().decode(FoodData.self, from: fetchedData!))
                self.fetchCalories(fdcId: decodedData.foods.first!.fdcId)
            }
            else {
                print("error fetching fdcid")
            }
          
            
     
                
            }.resume()
       
    }
        
        
    
    func fetchCalories(fdcId: Int) {
        
        guard let url = URL(string: "https://api.nal.usda.gov/fdc/v1/food/\(fdcId)?api_key=Sn0e8UspfDk8lqDg8bviHCrBpTKYPdWu3v23f2OE#") else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error == nil {
                DispatchQueue.main.async {
                    do {
                        
                            let decodedData = try JSONDecoder().decode(NutritionalData.self, from: data!)
                            self.calories = decodedData.labelNutrients.calories.value
                            print(decodedData.labelNutrients.calories.value)
                        
                 
                    } catch {
                        return
                    }
                    
                    
                   
                }
            } else {
                print("error fetching calories")
            }
            
           
           
        }.resume()
        
    }
    
}


