//
//  InformationView.swift
//  cFood-swiftUI
//
//  Created by Derek Hsieh on 11/27/20.
//

import SwiftUI
import CoreData
import SPAlert


let screen = UIScreen.main.bounds


func haptic(type: UINotificationFeedbackGenerator.FeedbackType) {
    UINotificationFeedbackGenerator().notificationOccurred(type)
}

func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}

struct InformationView: View {
    
    @Binding var show: Bool
    @EnvironmentObject var nutritionVM: NutritionViewModel
    @State var showDetailsView = false
    @Binding var tabViewHidden: Bool
    
   
    
    
    
    var body: some View {
        VStack {
            
            
            
            if showDetailsView == false {
                
                ToolBarView(tabViewHidden: $tabViewHidden, show: $show)
                
                Text("\(MLData.foodName.replacingOccurrences(of: "_", with: " ").capitalizingFirstLetter())")
                    .font(.system(size: 45, weight: .heavy))
                    .foregroundColor(Color.white)
                    .shadow(color: Color.black.opacity(0.8), radius: 5, x: 3, y: 3)
                    .padding()
                
            }
            
            
            Spacer()
            
            CalorieView(show: $showDetailsView, tabViewHidden: $tabViewHidden, showInformationView: $show)
        }
        .edgesIgnoringSafeArea(.all)
        .opacity(show ? 1 : 0)
        .animation(.easeInOut)
    }
}

//struct InformationView_Previews: PreviewProvider {
//    static var previews: some View {
//        InformationView(show: .constant(true))
//    }
//}

struct ToolBarView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
   
    @Binding var tabViewHidden: Bool
    @Binding var show: Bool
    @EnvironmentObject var nutritionVM: NutritionViewModel
    
    fileprivate func saveFoodItem() {
        let newFoodItem = FoodItem(context: self.managedObjectContext)
        
        newFoodItem.name = MLData.foodName.capitalizingFirstLetter().replacingOccurrences(of: "_", with: " ")
        newFoodItem.calories = NSNumber(value: Int(nutritionVM.calories))
        newFoodItem.carbs = NSNumber(value: Int(nutritionVM.carbs))
        newFoodItem.fats =  NSNumber(value: Int(nutritionVM.fat))
        newFoodItem.proteins =  NSNumber(value: Int(nutritionVM.protein))
        newFoodItem.servingSize = nutritionVM.servingSize
        newFoodItem.date = Date()
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(#colorLiteral(red: 0.2274509804, green: 0.8431372549, blue: 0.4392156863, alpha: 1)))
                .frame(width: UIScreen.main.bounds.width, height: 100)
            
            
            
            HStack {
                Button(action: {
                    haptic(type: .error)
                    
                    tabViewHidden = false
                    
                    show = false
                    nutritionVM.calories = 0
                    
                    
                }) {
                    Image(systemName: "trash.fill")
                        .resizable()
                        .foregroundColor(Color(.black).opacity(0.9))
                        .frame(width: 34, height: 36, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }.padding()
                .padding(.leading, 5)
                
                Spacer()
                
                Button(action: {
                    
                    saveFoodItem()
                    
                    haptic(type: .success)
                    
                    tabViewHidden = false
                    
                    show = false
                    nutritionVM.calories = 0
                    
                    SPAlert.present(title: "Added to Log", preset: .done)
                    
                }) {
                    Image(systemName: "folder.badge.plus")
                        .resizable()
                        .foregroundColor(Color(.black).opacity(0.9))
                        .frame(width: 46, height: 36, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                .padding()
                .padding(.trailing, 5)
            }
        }
    }
}


struct CalorieView: View {
    
    @EnvironmentObject var nutritionVM: NutritionViewModel
    @State var attempts: Int = 0
    @Binding var show: Bool
    @Binding var tabViewHidden: Bool
    @Binding var showInformationView: Bool
    
    var body: some View {
        
        ZStack(alignment: .center) {
            HStack(alignment: .center) {
                
                if show == false {
                    Button(action: {
                        
                        if nutritionVM.calories <= 0 {
                            withAnimation(.default) {
                                self.attempts += 1
                            }
                            haptic(type: .error)
                            
                        }
                        else {
                            nutritionVM.calories -= 10
                            impact(style: .medium)
                        }
                        
                        
                    }) {
                        
                                Text("-")
                                    .font(.system(size: 140, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(#colorLiteral(red: 0.9607843137, green: 0.2862745098, blue: 0.2862745098, alpha: 1)))
                                    .padding(.leading)
                                    .padding(.trailing)
                                    .shadow(color: Color.black.opacity(0.5), radius: 6, x: 1, y: 10)
                            
                        
                        
                    }.padding()
                }
                
                Spacer()
                
                if show == false {
                    Button(action: {
                        
                        nutritionVM.calories += 10
                        impact(style: .medium)
                        
                    }) {
                        
                  
                                Text("+")
                                        .font(.system(size: 100, weight: .bold, design: .rounded))
                                        .foregroundColor(Color(#colorLiteral(red: 0.5097282529, green: 0.6118130088, blue: 0.9998771548, alpha: 1)))
                                    .padding(.trailing)
                                    .padding(.leading)
                                    .shadow(color: Color.black.opacity(0.5), radius: 6, x: 1, y: 10)
                            
                        
                    }
                }
            }
            
            
            
            DetailsView(show: $show, showInformationView: $showInformationView, attempts: $attempts, tabViewHidden: $tabViewHidden)
            
            
        }
    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                                                amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}



struct DetailsView: View {
    @EnvironmentObject var nutritionVM: NutritionViewModel
    @Binding var show: Bool
    @Binding var showInformationView: Bool
    @State var activeView = CGSize.zero
    @Binding var attempts: Int
    @GestureState var isLongPressed = false
    @State var pressed = false
    @State var startPos : CGPoint = .zero
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var tabViewHidden: Bool
    
    var body: some View {
        VStack {
            
            ZStack(alignment: .top) {
                
                VStack {
                    Spacer()
                    HStack {
                        HStack {
                            Image(systemName: "flame")
                                .font(.system(size: 35, weight: .regular))
                                .foregroundColor(.red)
                            VStack(alignment: .leading) {
                                Text("Calories")
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundColor(.red)
                                Text("\(Int(nutritionVM.calories))")
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.2)
                            }.padding()
                        }
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(.black).opacity(0.1), lineWidth: 5)
                        )
                        Spacer()
                        HStack {
                            Image("wheat")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.green)
                            VStack(alignment: .leading) {
                                Text("Carbs")
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundColor(.green)
                                Text("\(Int(nutritionVM.carbs))")
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.2)
                            }.padding()
                        }
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(.black).opacity(0.1), lineWidth: 5)
                        )
                    }.padding(.bottom, 40)
                    .padding(.top, 250)
                    
                    
                    HStack {
                        HStack {
                            Image("trans-fat")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text("Fat")
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundColor(.blue)
                                Text("\(Int(nutritionVM.fat))")
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                
                                    
                            }.padding()
                        }.padding(.trailing, 25)
                        .padding(10)
                        
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(.black).opacity(0.1), lineWidth: 5)
                        )
                        
                        Spacer()
                        
                        
                        HStack {
                            Image("meat")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.orange)
                            VStack(alignment: .leading) {
                                Text("Protein")
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundColor(.orange)
                                Text("\(Int(nutritionVM.protein))")
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                            }.padding()
                        }
                        .padding(10)
                        
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(.black).opacity(0.1), lineWidth: 5)
                        )
                        
                        
                        
                        
                        
                    }
                    
                    Spacer()
                    
                    Text("\(nutritionVM.servingSize)")
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .padding()
                        .frame(maxWidth: screen.width-60)
                        .overlay (
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(.black).opacity(0.1), lineWidth: 5)
                        )
                    
                    
                    
                    
                    Spacer()
                    
                    Button(action: {
                        
                        let newFoodItem = FoodItem(context: self.managedObjectContext)
                        
                        newFoodItem.name = MLData.foodName.capitalizingFirstLetter().replacingOccurrences(of: "_", with: " ")
                        newFoodItem.calories = NSNumber(value: Int(nutritionVM.calories))
                        newFoodItem.carbs = NSNumber(value: Int(nutritionVM.carbs))
                        newFoodItem.fats =  NSNumber(value: Int(nutritionVM.fat))
                        newFoodItem.proteins =  NSNumber(value: Int(nutritionVM.protein))
                        newFoodItem.servingSize = nutritionVM.servingSize
                        newFoodItem.date = Date()
                        
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print(error)
                        }
                        
                        haptic(type: .success)
                        
                        tabViewHidden = false
                        
                        showInformationView = false
                        show = false
                        
                        nutritionVM.calories = 0
                        
                        SPAlert.present(title: "Added to Log", preset: .done)
                        
                    }) {
                        Text("Save")
                            .padding()
                            .frame(maxWidth: screen.width - 60)
                            .foregroundColor(.white)
                            .background(
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color(#colorLiteral(red: 0.225826323, green: 0.8422113061, blue: 0.4377509356, alpha: 1)))
                                    
                                }
                                
                            )
                            .padding(.bottom, 45)
                    }
                    
                    
                    
                    
                    
                }
                .padding(30)
                .frame(maxWidth: show ? .infinity : screen.width - 60, maxHeight: show ? 950 : 100)
                .offset(y: show ? 40 : 0)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                .opacity(show ? 1: 0)
                
                VStack {
                    
                    Spacer()
                    
                    HStack() {
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 8.0) {
                            
                            if show {
                                HStack {
                                    Spacer()
                                    VStack {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.white)
                                    }    .frame(width: 36, height: 36)
                                    .background(Color.black)
                                    .clipShape(Circle())
                                }
                            }
                            
                            Spacer()
                            
                            VStack {
                                
                                Text(show ? "\(MLData.foodName.replacingOccurrences(of: "_", with: " ").capitalizingFirstLetter())" : "\(Int(nutritionVM.calories))")
                                    .font(.system(size: show ? 55 : 60, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    
                                    .padding(show ? 5 : 0)
                                    .foregroundColor(show ? .white : .black)
                                    //                                    .padding(.top, show ? 15 : 0)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.2)
                                    .modifier(Shake(animatableData: CGFloat(attempts)))
                                    .animation(.spring())
                                    
                                    .gesture(
                                        
                                        
                                        DragGesture().onChanged { gesture in
                                            
                                            if self.show == false { self.activeView = gesture.translation}
                                            
                                        }
                                        .onEnded { value in
                                            if self.show == false {
                                                if self.activeView.height < 50 {
                                                    self.show = true
                                                }
                                                self.activeView = .zero
                                            }
                                        }
                                        
                                        
                                        
                                    )
                                
                                
                                
                                Text("calories")
                                    .font(.system(size: 25, weight: .regular, design: .rounded))
                                    .foregroundColor(Color(#colorLiteral(red: 0.3882036209, green: 0.3686499, blue: 0.3685802519, alpha: 1)).opacity(show ? 0 : 1))
                                    .padding(.bottom)
                                
                                
                                
                            }
                            
                            
                            
                            
                            
                        }
                        Spacer()
                        
                        
                    }
                    Spacer()
                    
                }
                .padding(show ? 30 : 20)
                .padding(.top, show ? 30 : 0)
                //        .frame(width: show ? screen.width : screen.width - 60, height: show ? screen.height : 280)
                .frame(maxWidth: show ? .infinity : 191, maxHeight: show ? 300 : 100)
                .background(show ? Color(#colorLiteral(red: 0.2274509804, green: 0.8901960784, blue: 0.4549019608, alpha: 1)) :Color(#colorLiteral(red: 0.9489466548, green: 0.9098549485, blue: 0.909696281, alpha: 1)))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: show ? Color(#colorLiteral(red: 0.2274509804, green: 0.8901960784, blue: 0.4549019608, alpha: 1)) : Color(#colorLiteral(red: 0.9489466548, green: 0.9098549485, blue: 0.909696281, alpha: 1)).opacity(0.3), radius: 20, x: 0, y: 20)
                .onTapGesture {
                    self.show.toggle()
                }
                
            }
            .frame(height: show ? UIScreen.main.bounds.height : 200)
            .scaleEffect(1 - self.activeView.height/1000)
            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
            .edgesIgnoringSafeArea(.all)
            .gesture(
                DragGesture().onChanged { gesture in
                    
                    guard gesture.translation.height < 300 else { return }
                    guard gesture.translation.height > 0 else { return }
                    self.activeView = gesture.translation
                    
                    
                    
                    
                }
                .onEnded { value in
                    if self.activeView.height > 50 {
                        self.show = false
                    }
                    self.activeView = .zero
                }
                
            )
            
        }
    }
}


