//
//  Ovulation.swift
//  BloomCycle
//
//  Created by Sarah on 13/04/1447 AH.
//




import SwiftUI

struct Ovulation: View {
    @State private var scrollOffset: CGFloat = 0
    var body: some View {
        
        
        ZStack{
            Color.color
                .ignoresSafeArea()
            Image("background")
                            .resizable()
                            .ignoresSafeArea()
       
            VStack{
                
                Image("Ovulation")
                    .resizable()
                    .frame(width: 120, height: 140)
                    .padding(0.1)
                

                Text("Ovulation Phase")
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .foregroundColor(.br)
                
                
                Spacer()
                
                
            }
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                CardView(title: "Needs", color: .greenn, borderColor: .br, imageName: "NEED",subTitle: "The body needs zinc antioxidants and hydration to maintain energy and overall health")
                    CardView(title: "Foods", color: .greenn, borderColor: .br, imageName: "FOOD",subTitle: "Chickpeas pumpkin seeds berries pomegranate and fresh vegetables provide zinc antioxidants and water to keep the body active and refreshed")
                                  
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
    Ovulation()
}

