//
//  ContentView.swift
//  BloomCycle
//
//  Created by Sarah on 03/04/1447 AH.
//
import SwiftUI

struct ContentView: View {
    @State private var scrollOffset: CGFloat = 0
    var body: some View {
        
        
        ZStack{
            Color.color
                .ignoresSafeArea()
            Image("background")
                            .resizable()
                            .ignoresSafeArea()
       
            VStack{
                Image("blood")
                    .resizable()
                    .frame(width: 95, height: 110)
                    .padding(5)

                Text("Menstrual Phase")
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




struct CardView: View {
    var title: String
    var color: Color
    var borderColor: Color
    var imageName: String  // اسم الصورة
    var subTitle: String
    
    var body: some View {
        VStack(spacing: 10) {  // يعطي مسافة بين الصورة والنصوص
 
            Image(imageName)
                .resizable()
                    .scaledToFill()   // يملأ الإطار كاملًا
                    .frame(width: 250, height: 150)  // حدد حجم الكارد أو الجزء اللي تبيه
                    .clipped()        // يقص أي جزء زايد خارج الإطار
                    .cornerRadius(500) // إذا تحب تكون الزوايا
            
            VStack(spacing: 5) { // مجموعة النصوص
                Text(title)
                    .font(.system(size: 30, weight: .bold))  // حجم أصغر
                    .foregroundColor(borderColor)
                    .multilineTextAlignment(.center) // توسيط النص
                
                Text(subTitle)
                    .font(.system(size: 24))  // حجم مناسب للوصف
                    .foregroundColor(borderColor)
                    .multilineTextAlignment(.center) // توسيط النص
            }
            .padding(.horizontal, 10) // padding من الجوانب

        }
        .frame(width: 300, height: 350)
        .background(color) // لون خلفية الكارد
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor, lineWidth: 3) // البورد
        )
        .shadow(radius: 5)
        .padding(.vertical, 20)
    }
}

#Preview {
    ContentView()
}
