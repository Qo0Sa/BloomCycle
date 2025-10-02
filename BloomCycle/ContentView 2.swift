//
//  ContentView 2.swift
//  BloomCycle
//
//  Created by rand on 02/10/2025.
//


import SwiftUI

struct FoodTracker: View {
    let formatter: DateFormatter = {
        let yf = DateFormatter()
        yf.dateFormat = "yyyy"   // سنة
        return yf
    }() 

    let Mformatter: DateFormatter = {
        let mf = DateFormatter()
        mf.dateFormat = "MMMM"   // شهر كامل
        return mf
    }()

    var body: some View {
        VStack(spacing: 0) {
      VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 9) {
                        Button(action: {}) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .font(.headline)
                            .foregroundColor(.br)
                        }

                        HStack(spacing: 4) {
                            
                            Text(Mformatter.string(from: Date()))
                                .font(.largeTitle).fontWeight(.bold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                .layoutPriority(1)
                                .foregroundColor(.dbrown)
                            
                            Text(formatter.string(from: Date()))
                                .font(.largeTitle).fontWeight(.bold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                .layoutPriority(1)
                                .foregroundColor(.dpink)

                        }
                    }

                    Spacer()

                    Button {} label: {
                        Image(systemName: "calendar")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.dbrown)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.lpink))
                            )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Spacer(minLength: 30)
            }

            Spacer()

            // المستطيل الابيض
            ZStack {
                RoundedCorner(radius: 30, corners: [.topLeft, .topRight])
                    .fill(Color.white)
                    .frame(maxWidth: .infinity)
                     .ignoresSafeArea(edges: .bottom)
                    .frame(height: 600)
                    

                Text("No meals yet, \nAdd your meal!")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.dbrown)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        // الخلفية
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.lyellow.opacity(0.8), Color.dpink.opacity(0.9)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

// for the rec to
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    FoodTracker()
}
