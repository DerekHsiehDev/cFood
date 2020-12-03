//
//  LogView.swift
//  cFood-swiftUI
//
//  Created by Derek Hsieh on 11/30/20.
//

import SwiftUI
import SwiftUICharts

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
    
    let date = Date()
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current
    let chartStyle = ChartStyle(backgroundColor: Color(#colorLiteral(red: 0.225826323, green: 0.8422113061, blue: 0.4377509356, alpha: 1)), accentColor: Color(.black).opacity(0.3), secondGradientColor: Color(.white), textColor: Color.white, legendTextColor: Color.white, dropShadowColor: Color(#colorLiteral(red: 0.225826323, green: 0.8422113061, blue: 0.4377509356, alpha: 1)) )
    
    @State var dayOfWeek = 1
    @State var dateNumber = ""
    @State var tappedDate = false
    @State var todayCalories = 0
    
    
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
            
            BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "Weekly Summary", style: chartStyle, form: ChartForm.large, dropShadow: true, cornerImage:Image(systemName: "flame"), valueSpecifier: "%.0f")
                .frame(width: 400, height: 200)
            
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
                                        .fill(tappedDate ? Color(#colorLiteral(red: 0.3647058824, green: 0.8784734011, blue: 0.3960191309, alpha: 1)) : Color(#colorLiteral(red: 0.4567164351, green: 0.7213024712, blue: 0.8116621375, alpha: 1)))
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
                    todayCalories -= self.foodItems[indexSet.first!].calories as! Int
                    self.managedObjectContext.delete(deleteItem)
                    
                    do {
                        try self.managedObjectContext.save()
                        
                          
                        
                    } catch {
                        print(error)
                    }
                }
            }
        }.onAppear {
            dateFormatter.dateFormat = "EEEE"
            dateNumber = dateFormatter.string(from: date)
            let components = calendar.dateComponents([.weekday], from: date)
            dayOfWeek = components.weekday!
            
            for item in self.todayItems {
                todayCalories += item.calories as! Int
                
            }
          
      
        }
        .onDisappear {
            todayCalories = 0
        }
        
        
        
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
