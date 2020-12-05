//
//  ContentView.swift
//  cFood-swiftUI
//
//  Created by Derek Hsieh on 11/26/20.
//

import SwiftUI
import Introspect

let nutritionVM = NutritionViewModel()



struct FatSecret {
    
    func returnKey(acc: Int) -> String{
        switch acc {
        case 0:
            return "c7674dce3d804559b6603af0cedbb174"
        case 1:
            return "39e1c7293a8741ae9f86c2a90f18e1fa"
        case 2:
            return "a72b02f8e9634bbead4febaeec17c0f1"
        default:
            return "c7674dce3d804559b6603af0cedbb174"
        }
        
    }
    
    func returnSecret(acc: Int) -> String {
        switch acc {
        case 0:
            return "67f5e94623a1488181896b2edea68b3b"
        case 1:
            return "f6d9bb26bc06452195655abe36cc927f"
        case 2:
            return "2fb45d47cb3c4b779295305c0c1f2db3"
        default:
            return "67f5e94623a1488181896b2edea68b3b"
        }
    }
    
    static let apiKey = "c7674dce3d804559b6603af0cedbb174"
    static let apiSecret = "67f5e94623a1488181896b2edea68b3b"
}

struct ContentView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.green
        UITabBar.appearance().tintColor = UIColor.white
        }
    
    @EnvironmentObject var nutritionVM: NutritionViewModel
    @State var liveViewRunning = true
    @State var show = false
    @State var selectedTab = "home"
    @State var tabBarHidden = false
    

    
    let fatSearchRequest = FatSecretAPI()
    
    var body: some View {
        
        
        
        TabView {
            
            
            
            ZStack {
                CameraView(liveViewRunning: $liveViewRunning, show: $show)
                    .edgesIgnoringSafeArea(.all)
                
                
                
                
                
                VStack {
                    InformationView(show: $show, tabViewHidden: $tabBarHidden)
                    
                }
                
                
            }
            .tabItem {
                VStack {
                    
                    Image(systemName: "house.fill")
                        .padding(.top, 40)
                        .padding(30)
                    Text("Home")
                        .padding(30)
                }
                
            }.tag(0)
            .overlay(
                
                
                VStack(spacing: 0) {
                    Color(.black).opacity(0.2)
                    
                    HStack(spacing: 0) {
                        Color(.black).opacity(0.2).frame(height: 400)
                        
                        Image("cross box").resizable().cornerRadius(25).frame(width: 400, height: 400)
                        
                        
                        Color(.black).opacity(0.2).frame(height: 400)
                    }
                    Color(.black).opacity(0.2)
                }.edgesIgnoringSafeArea(.all)
                .opacity(show ? 0 : 1)
                .onTapGesture {
                    if show == false {
                        liveViewRunning = false
                        
                        tabBarHidden = true
                        
                        show = true
                        let randomAcc = Int.random(in: 0..<3)
                        
                        fatSearchRequest.key = FatSecret().returnKey(acc: randomAcc)
                        fatSearchRequest.secret = FatSecret().returnSecret(acc: randomAcc)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            
                            fatSearchRequest.searchFoodBy(name: MLData.foodName.replacingOccurrences(of: "_", with: " ")) { (search) in
                                print(MLData.foodName)
                                var str = search.foods.first!.description!
                                print(str)
                                
                                var servingSize = ""
                                
                                if let endIndex = str.range(of: "-")?.lowerBound {
                                    servingSize = (String(str[..<endIndex]))
                                }
                                
                                //                            print(servingSize)
                                
                                
                                
                                if let range = str.range(of: "-") {
                                    str = String(str[range.upperBound...])
                                    
                                }
                                
                                let nutritionArray = str.components(separatedBy: "|")
                                print(nutritionArray)
                                
                                let calories = nutritionArray.first
                                let fat = nutritionArray[1]
                                let carbs = nutritionArray[2]
                                let protein = nutritionArray[3]
                                
                                // get serving size
                                
                                
                                DispatchQueue.main.async {
                                    nutritionVM.calories = filterOutNums(str: calories!)
                                    nutritionVM.fat = (filterOutNums(str: fat))
                                    nutritionVM.carbs = (filterOutNums(str: carbs))
                                    nutritionVM.protein = (filterOutNums(str: protein))
                                    nutritionVM.servingSize = servingSize
                                }
                                
                                
                            }
                        }
                        
                    }
                    
                    
                    
                }
                .animation(Animation
                            .easeInOut
                            .delay(show ? 0 : 0.5)
                )
               
                
              
                
                
                
                
                
            )
            
            LogView().tabItem {
                Image(systemName: "tray.fill")
                    .padding(.top, 40)
                .padding(30)
                Text("Food Log")
                    .padding(30)
            }.tag(0)
            
            
            
        }
        .accentColor(.orange)
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = tabBarHidden
           
        }
    }
    
    
    
}


var tabs = ["house.fill" , "tray.fill"]


struct TabButton: View {
    var image: String
    @Binding var selectedTab: String
    
    var body: some View {
        Button(action: {
            selectedTab = image
            
        }) {
            Image(systemName: image)
                .font(.system(size: 30, weight: .bold))
                
                .foregroundColor(selectedTab == image ? Color(.white) : Color.black.opacity(0.4))
                .padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(nutritionVM)
    }
}

func filterOutNums(str: String) -> Float {
    return Float(str.filter("0123456789.".contains))!
}


