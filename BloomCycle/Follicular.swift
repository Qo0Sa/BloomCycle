//
//  Follicular.swift
//  BloomCycle
//
//  Created by Sarah on 09/04/1447 AH.
//

import SwiftUI

struct Follicular: View {
    @State private var scrollOffset: CGFloat = 0
    var body: some View {
        
        
        ZStack{
            Color.color
                .ignoresSafeArea()
            Image("background")
                            .resizable()
                            .ignoresSafeArea()
       
            VStack{
                
                Image("follicular")
                    .resizable()
                    .frame(width: 120, height: 150)
                    .padding(0.1)
                

                Text("Follicular Phase")
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .foregroundColor(.br)
                
                
                Spacer()
                
                
            }
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                CardView(title: "Needs", color: .greenn, borderColor: .br, imageName: "NEED",subTitle: " Replace blood loss (iron + vitamin C)")
                    CardView(title: "Foods", color: .greenn, borderColor: .br, imageName: "FOOD",subTitle: " Spinach, lentils, red meat, liver, oranges, strawberries")
                                  
                               }
                
                               .padding(.horizontal, 20)
                
                           }
                           .frame(height: 300)
                           .padding(.top, 60)
        
                       .padding()
        }
    }

}





#Preview {
    Follicular()
}
