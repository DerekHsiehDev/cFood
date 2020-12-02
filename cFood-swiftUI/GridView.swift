//
//  GridView.swift
//  cFood-swiftUI
//
//  Created by Derek Hsieh on 12/1/20.
//

import SwiftUI

struct GridView: View {
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    var body: some View {
        
        LazyVGrid(columns: columns, spacing: 10) {
            
            DisplayView(nutritionAmount: 123, image: "flame", color: Color.red, nutrient: "Calories")
            DisplayView(nutritionAmount: 321, image: "wheat", color: Color.green, nutrient: "Carbs")
            DisplayView(nutritionAmount: 421, image: "trans-fat", color: Color.blue, nutrient: "Fat     ")
            DisplayView(nutritionAmount: 21, image: "meat", color: Color.orange, nutrient: "Protein")
            
        }
        
    }
}

struct DisplayView: View {
    
    var nutritionAmount: Int
    var image: String
    var color: Color
    var nutrient: String
    
    var body: some View {
        
        VStack {
            HStack {
                if image == "flame" {
                    Image(systemName: image)
                        .font(.system(size: 25))
                        .foregroundColor(color)

                }
                else {
                    Image(image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(color)
                }
                Text(nutrient)

            }

            Text("\(nutritionAmount)")


        }.padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.black).opacity(0.1), lineWidth: 5)
        )
        
        
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
    }
}
