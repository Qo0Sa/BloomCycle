//
//  foodTracker3.swift
//  BloomCycle
//
//  Created by Dana AlGhadeer on 03/10/2025.
//
import SwiftUI

struct foodTracker: View {
    @State private var selectedDate: Date = Date()
    private let calendar = Calendar.current

    let formatter: DateFormatter = {
        let yf = DateFormatter()
        yf.dateFormat = "yyyy"
        return yf
    }()

    let Mformatter: DateFormatter = {
        let mf = DateFormatter()
        mf.dateFormat = "MMMM"
        return mf
    }()

    private let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f
    }()

    private let weekdayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return f
    }()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                // Header
                VStack (spacing: 2) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 9) {
                            Button(action: {}) {
                                HStack(spacing: 4) {
                                    Image(systemName: "chevron.left")
                                    Text("Back")
                                }
                                .font(.headline)
                                .foregroundColor(Color.brown) // Changed from .br
                            }

                            HStack(spacing: 4) {
                                Text(Mformatter.string(from: Date()))
                                    .font(.largeTitle).fontWeight(.bold)
                                    .foregroundColor(.primary) // Changed from .dBrown

                                Text(formatter.string(from: Date()))
                                    .font(.largeTitle).fontWeight(.bold)
                                    .foregroundColor(.primary) // Changed from .dPink
                            }
                        }

                        Spacer()

                        Button {} label: {
                            Image(systemName: "calendar")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(.primary) // Changed from .dBrown
                                .padding(8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // Days Scroll
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 18) {
                            ForEach(allDays(), id: \.self) { day in
                                let isSelected = calendar.isDate(day, inSameDayAs: selectedDate)
                                VStack(spacing: 6) {
                                    Text(dayFormatter.string(from: day))
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(isSelected ? .white : .primary)

                                    Text(weekdayFormatter.string(from: day))
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.primary)
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 14)
                                .background(
                                    Group {
                                        if isSelected {
                                            Circle()
                                                .fill(Color.blue) // Changed from .dPink
                                                .frame(width: 55, height: 55)
                                        } else {
                                            Color.clear
                                        }
                                    }
                                )
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        selectedDate = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 6)
                    }
                    .frame(height: 80)

                    Spacer(minLength: 30)
                }

                Spacer()

                // White rectangle
                ZStack {
                    RoundedCorner(radius: 30, corners: [.topLeft, .topRight])
                        .fill(Color.white)
                        .frame(maxWidth: .infinity)
                        .ignoresSafeArea(edges: .bottom)
                        .frame(height: 600)

                    Text("No meals yet, \nAdd your meal!")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.secondary) // Changed from .lBrown
                        .multilineTextAlignment(.center) // Added for better text alignment
                }
            }

            // Add button
            Button(action: {
                print("Add meal tapped")
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding(18)
                    .background(Color.blue) // Changed from .dBrown
                    .clipShape(Circle())
                    .shadow(radius: 6, x: 0, y: 3)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.yellow.opacity(0.8), Color.pink.opacity(0.9)]), // Changed from custom colors
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }

    private func allDays() -> [Date] {
        let today = Date()
        let currentYear = calendar.component(.year, from: today)
        let currentMonth = calendar.component(.month, from: today)

        let startMonth = max(currentMonth - 1, 1)
        let startComponents = DateComponents(year: currentYear, month: startMonth, day: 1)
        guard let start = calendar.date(from: startComponents) else { return [] }

        let endComponents = DateComponents(year: currentYear, month: 12, day: 31)
        guard let end = calendar.date(from: endComponents) else { return [] }

        var dates: [Date] = []
        var current = start
        while current <= end {
            dates.append(current)
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: current) else { break }
            current = nextDay
        }
        return dates
    }
}

struct roundedCorner: Shape {
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
