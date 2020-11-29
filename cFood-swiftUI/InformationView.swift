//
//  InformationView.swift
//  cFood-swiftUI
//
//  Created by Derek Hsieh on 11/27/20.
//

import SwiftUI


func haptic(type: UINotificationFeedbackGenerator.FeedbackType) {
    UINotificationFeedbackGenerator().notificationOccurred(type)
}

func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}

struct InformationView: View {
    @Binding var show: Bool
    @EnvironmentObject var nutritionVM: NutritionViewModel

    
    
    var body: some View {
        VStack {
            
            ToolBarView(show: $show)
           
            
//            Text(MLData.foodName)
            Text("\(MLData.foodName.replacingOccurrences(of: "_", with: " ").capitalizingFirstLetter())")
                .font(.system(size: 45, weight: .heavy))
                .foregroundColor(Color.white)
                .shadow(color: Color.black.opacity(0.8), radius: 5, x: 3, y: 3)
                .padding()
                    
            
            Spacer()
            
            CalorieView()
        }
        .edgesIgnoringSafeArea(.top)
        .opacity(show ? 1 : 0)
        .animation(.easeInOut)
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView(show: .constant(true))
    }
}

struct ToolBarView: View {
    @Binding var show: Bool
    @EnvironmentObject var nutritionVM: NutritionViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width, height: 100)
                .background(Color(#colorLiteral(red: 0.1725490196, green: 0.2431372549, blue: 0.3137254902, alpha: 1)))
            
            HStack {
                Button(action: {
                    haptic(type: .error)
                    
                    show = false
                    nutritionVM.calories = 0
                   
                    
                }) {
                    Image(systemName: "trash.fill")
                        .resizable()
                        .foregroundColor(Color(#colorLiteral(red: 0.6979770064, green: 0.6980791688, blue: 0.6979547143, alpha: 1)))
                        .frame(width: 34, height: 36, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }.padding()
                .padding(.leading, 5)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "folder.badge.plus")
                        .resizable()
                        .foregroundColor(Color(#colorLiteral(red: 0.6979770064, green: 0.6980791688, blue: 0.6979547143, alpha: 1)))
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
    
    var body: some View {
        
        HStack {
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
               
                    Circle()
                        .fill(Color(#colorLiteral(red: 0.9607843137, green: 0.2862745098, blue: 0.2862745098, alpha: 1)))
                        .frame(width: 73, height: 73)
                        .shadow(color: Color.black.opacity(0.5), radius: 6, x: 1, y: 10)
                        .overlay(
                            Text("-")
                                    .font(.system(size: 55, weight: .regular, design: .rounded))
                                    .foregroundColor(.white)
                        )
                 
                
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(#colorLiteral(red: 0.9489466548, green: 0.9098549485, blue: 0.909696281, alpha: 1)))
                    .frame(width: 189, height: 115)
                    .padding(10)
                    .shadow(color: Color.black.opacity(0.4), radius: 3, x: 0, y: 2)
                
                VStack {
                    Text("calories")
                        .font(.system(size: 25, weight: .regular, design: .rounded))
                        .foregroundColor(Color(#colorLiteral(red: 0.3882036209, green: 0.3686499, blue: 0.3685802519, alpha: 1)))
             
                    if nutritionVM.calories == 0 {
                        Text("N/A")
                            .lineLimit(1)
                            .font(.system(size: 60, weight: .bold))
                            .minimumScaleFactor(0.2)
                            .modifier(Shake(animatableData: CGFloat(attempts)))
                            .animation(.spring())
                    } else {
                        Text("\(Int (nutritionVM.calories))")
                            .lineLimit(1)
                            .font(.system(size: 60, weight: .bold))
                            .minimumScaleFactor(0.2)
                            .modifier(Shake(animatableData: CGFloat(attempts)))
                            .animation(.spring())
                    
                    }
                        
                }.frame(width: 191, height: 115)
            }
                
            
            Button(action: {
                
                nutritionVM.calories += 10
                impact(style: .medium)
                
            }) {
               
                    Circle()
                        .fill(Color(#colorLiteral(red: 0.5097282529, green: 0.6118130088, blue: 0.9998771548, alpha: 1)))
                        .frame(width: 73, height: 73)
                        .shadow(color: Color.black.opacity(0.5), radius: 6, x: 1, y: 10)
                        .overlay(  Text("+")
                                    .font(.system(size: 55, weight: .regular, design: .rounded))
                                    .foregroundColor(.white)
                        )
                
            }
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
