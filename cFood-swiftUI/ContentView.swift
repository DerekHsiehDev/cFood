//
//  ContentView.swift
//  cFood-swiftUI
//
//  Created by Derek Hsieh on 11/26/20.
//

import SwiftUI

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
    @EnvironmentObject var nutritionVM: NutritionViewModel
    @State var liveViewRunning = true
    @State var show = false
    
    let fatSearchRequest = FatSecretAPI()
    
    var body: some View {
        
        
        
        ZStack {
            CameraView(liveViewRunning: $liveViewRunning, show: $show)
                .edgesIgnoringSafeArea(.all)
                
                .onTapGesture {
                    if show == false {
                        liveViewRunning = false
                        
                        show = true
                        let randomAcc = Int.random(in: 0..<3)
                        
                        fatSearchRequest.key = FatSecret().returnKey(acc: randomAcc)
                        fatSearchRequest.secret = FatSecret().returnSecret(acc: randomAcc)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            
                            fatSearchRequest.searchFoodBy(name: MLData.foodName.replacingOccurrences(of: "_", with: " ")) { (search) in
                                print(MLData.foodName)
                                var str = search.foods.first!.description!

                                if let range = str.range(of: "-") {
                                    str = String(str[range.upperBound...])

                                }

                                let nutritionArray = str.components(separatedBy: "|")
                                print(nutritionArray)

                                let calories = nutritionArray.first
                                DispatchQueue.main.async {
                                    nutritionVM.calories = filterOutNums(str: calories!)
                                }
                                
                                
                            }
                        }
                    
                        
                    
                    }
                    
                    
                    
                }
            
            
            InformationView(show: $show)
            
            
        }
       

            
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func filterOutNums(str: String) -> Float {
    return Float(str.filter("0123456789.".contains))!
}

