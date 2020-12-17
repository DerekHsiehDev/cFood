//
//  LogView.swift
//  cFood-swiftUI
//
//  Created by Derek Hsieh on 11/30/20.
//

import SwiftUI
import SwiftUICharts
import SwiftUIPullToRefresh

let colors = [
    Color(#colorLiteral(red: 0.999996841, green: 0.5568950772, blue: 0.556807816, alpha: 1)),
    
    Color(#colorLiteral(red: 0.2272375524, green: 0.588275969, blue: 0.8116621375, alpha: 1)),
    
    Color(#colorLiteral(red: 0.364403069, green: 0.8784734011, blue: 0.3960191309, alpha: 1)),
    
    Color(#colorLiteral(red: 0.2980076969, green: 0.3137701154, blue: 0.8234270215, alpha: 1)),
    
    Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)),
    
    Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1))
]



struct LogView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: FoodItem.getAllFoodItems()) var foodItems: FetchedResults<FoodItem>
    @FetchRequest(fetchRequest: FoodItem.getTodayFoodItems()) var todayItems: FetchedResults<FoodItem>
//    @FetchRequest(fetchRequest: FoodItem.getLastWeekFoodItems()) var lastWeekItems: FetchedResults<FoodItem>
    @FetchRequest(fetchRequest: FoodItem.getitemsFlipped()) var foodItemsFlipped: FetchedResults<FoodItem>
    
    let date = Date()
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current
    let chartStyle = ChartStyle(backgroundColor: Color.white, accentColor: Color.black, secondGradientColor: Color.black.opacity(0.8), textColor: Color.black, legendTextColor: Color.black.opacity(0.7), dropShadowColor: Color.gray)
    @State var data = [Double]()
    
    @State var dayOfWeek = 1
    @State var dateNumber = ""
    @State var tappedDate = false
    @State var todayCalories = 0
//    @State var weeklyCalories = Array(repeating: 0, count: 7)
    
    
    fileprivate func refreshData() {
        dateFormatter.dateFormat = "EEEE"
        dateNumber = dateFormatter.string(from: date)
        let components = calendar.dateComponents([.day], from: date)
        dayOfWeek = components.day!
       
        
        for item in self.todayItems {
            todayCalories += item.calories as! Int
            
        }
        //            weeklyCalories[6] = todayCalories
        //
        //            var index = -1
        //
        //            for item in self.lastWeekItems {
        //
        //                index = compareDate(date: item.date!)
        //
        //                weeklyCalories[index] += item.calories as! Int
        //
        //            }
        
        for item in self.foodItemsFlipped {
            data.append(item.calories as? Double ?? 0)
        }
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Food Log")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    Spacer()
                }
                HStack {
                    Text("\(dateNumber) \(dayOfWeek)")
                        .font(.system(size: 20, design: .rounded))
                        .foregroundColor(Color(#colorLiteral(red: 0.7646381259, green: 0.7647493482, blue: 0.7646137476, alpha: 1)))
                        .padding(.leading, 30)
                    Spacer()
                }
            }
            
//            BarChartView(data: ChartData(points: foodItemsArray), title: "Weekly Summary", style: chartStyle, form: ChartForm.large, dropShadow: true, cornerImage:Image(systemName: "flame"), valueSpecifier: "%.0f")
//            LineChartView(data: data.self, title: "Calorie Summary", legend: "kcal", style: chartStyle, form: ChartForm.large, rateValue: nil)
//
            
            Spacer()
            
            HStack {
                Text("today")
                    .font(.title)
                    .bold()
                
                Spacer()
                Text("\(todayCalories)")
                    .font(.system(size: 20))
                    .bold()
                Text("kcal")
                    .font(.system(size: 17, weight: .light))
                
            }.padding()
            
            if foodItems.count == 0 {
                VStack {
                    Spacer()
                    Text("No Foods!")
                        .font(.title)
                        .opacity(0.7)
                    Spacer()
                }
            }
            
            List {
                ForEach(self.foodItems) { foodItem in
                    
               
                    
                    
                    VStack {
                        HStack {
                            
                            
                            
                            
                            
                            
                            Text(tappedDate ? "\(foodItem.date!, style: .time)" : "\(foodItem.date!, style: .date)")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(tappedDate ? Color(#colorLiteral(red: 0.3969526291, green: 0.7017644048, blue: 0.2041607201, alpha: 1)) : Color(#colorLiteral(red: 0.3647058824, green: 0.8784734011, blue: 0.3960191309, alpha: 1)))
                                )
                                
                                
                                
                                .onTapGesture {
                                    tappedDate.toggle()
                                }
                            
                            VStack(alignment: .leading) {
                                Text(foodItem.name!)
                            
                                    //                                .font(.title)
                                    .font(.system(size: 20, design: .rounded))
                                    .fontWeight(.semibold)
                                Text(foodItem.servingSize!)
                                    .font(.system(size: 15, weight: .light))
                                
                                
                            }.padding(.leading, 5)
                            
                            Spacer()
                            
                            Text("\(foodItem.calories!)")
                                .bold()
                        }
                    }.padding(.vertical, 15)
                    .animation(.easeInOut)
                    
                    
                    
                    
                    
                }.onDelete { (indexSet) in
                    let deleteItem = self.foodItems[indexSet.first!]
                    
                    if todayCalories - Int(truncating: self.foodItems[indexSet.first!].calories ?? 0) >= 0  {
                        todayCalories -= self.foodItems[indexSet.first!].calories as! Int
                    }
                    self.managedObjectContext.delete(deleteItem)
                    
                    do {
                        try self.managedObjectContext.save()
                        
                          
                        
                    } catch {
                        print(error)
                    }
                }
            }
        }.onAppear {
            refreshData()
          
      
        }
        .onDisappear {
            todayCalories = 0
            data.removeAll()
        }
        
        
        
    }
}


//TODO: track week
//func compareDate(date: Date) -> Int {
//
//    var calender = Calendar.current
//    calender.timeZone = TimeZone.current
//    let currentDate = Date()
//
//    let result5 = calender.compare(date, to: calender.date(byAdding: .day, value: -1 ,to: currentDate)!, toGranularity: .day)
//    let result4 = calender.compare(date, to: calender.date(byAdding: .day, value: -2 ,to: currentDate)!, toGranularity: .day)
//    let result3 = calender.compare(date, to: calender.date(byAdding: .day, value: -3 ,to: currentDate)!, toGranularity: .day)
//    let result2 = calender.compare(date, to: calender.date(byAdding: .day, value: -4 ,to: currentDate)!, toGranularity: .day)
//    let result1 = calender.compare(date, to: calender.date(byAdding: .day, value: -5 ,to: currentDate)!, toGranularity: .day)
//    let result0 = calender.compare(date, to: calender.date(byAdding: .day, value: -6 ,to: currentDate)!, toGranularity: .day)
//
//    if (result5 == .orderedSame) == true {
//        return 5
//    } else if (result4 == .orderedSame) == true {
//        return 4
//    } else if (result3 == .orderedSame) == true {
//        return 3
//    } else if (result2 == .orderedSame) == true {
//        return 2
//    } else if (result1 == .orderedSame) == true {
//        return 1
//    } else if (result0 == .orderedSame) == true {
//        return 0
//    }
//
//    else { return -1 }
//}
