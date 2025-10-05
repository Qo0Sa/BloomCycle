//
//  Luteal.swift
//  BloomCycle
//
//  Created by Sarah on 13/04/1447 AH.
//


import SwiftUI

struct Luteal: View {
    @State private var scrollOffset: CGFloat = 0
    var body: some View {
        
        
        ZStack{
            Color.color
                .ignoresSafeArea()
            Image("background")
                            .resizable()
                            .ignoresSafeArea()
       
            VStack{
                
                Image("Luteal")
                    .resizable()
                    .frame(width: 120, height: 140)
                    .padding(0.1)
                

                Text("Luteal Phase")
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .foregroundColor(.br)
                
                
                Spacer()
                
                
            }
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                CardView(title: "Needs", color: .greenn, borderColor: .br, imageName: "NEED",subTitle: "The body needs magnesium and calming nutrients to relax and reduce stress before the period")
                    CardView(title: "Foods", color: .greenn, borderColor: .br, imageName: "FOOD",subTitle: "Bananas almonds dark chocolate chamomile tea and oats provide magnesium and soothing nutrients to ease cramps and mood swings")
                                  
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
    Luteal()
}

