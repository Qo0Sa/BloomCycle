

import SwiftUI
import Foundation

let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short // shows hour + mins
    return formatter
}()

let dateTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()
    
func iconForType(_ type: String) -> String {
    switch type {
    case "Breakfast":
        return "sunrise.fill"   // 🌅
    case "Lunch":
        return "fork.knife"     // 🍴
    case "Dinner":
        return "moon.stars.fill" // 🌙
    case "Snack":
        return "takeoutbag.and.cup.and.straw.fill" // 🥤
        
    default:
        return "questionmark.circle" // ❓ fallback
        
    }
}
    
    
    
    struct MealsSH: View {
        @State private var selectedDate: Date = Date()
        @State private var showAddMealSheet: Bool = false
        @State private var meals: [Meal] = []
        
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
                                    .foregroundColor(.br)
                                }
                                
                                HStack(spacing: 4) {
                                    Text(Mformatter.string(from: Date()))
                                        .font(.largeTitle).fontWeight(.bold)
                                        .foregroundColor(.dbrown)
                                    
                                    Text(formatter.string(from: Date()))
                                        .font(.largeTitle).fontWeight(.bold)
                                        .foregroundColor(.dpink)
                                }
                            }
                            
                            Spacer()
                            
                            Button {} label: {
                                Image(systemName: "calendar")
                                    .font(.system(size: 28, weight: .semibold))
                                    .foregroundColor(.dbrown)
                                    .padding(8)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        // Scroll Days
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
                                                    .fill(Color.dpink)
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
                            .fill(Color.background)
                            .frame(maxWidth: .infinity)
                            .ignoresSafeArea(edges: .bottom)
                            .frame(height: 600)
                        
                        if meals.isEmpty{
                            
                            Text("No meals yet, \nAdd your meal!")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.lBrown)
                        }else{
                            ScrollView{
                                VStack(alignment: .leading, spacing: 40){
                                    ForEach(meals.sorted(by: { $0.time < $1.time})){meal in
                                        
                                        HStack(alignment: .center, spacing: 16){
                                            //TIME
                                            Text(timeFormatter.string(from: meal.time))
                                                .font(.headline)
                                                .foregroundColor(.dbrown)
                                                .frame(width: 80, alignment: .trailing)
                                            
                                            //TIMELINE + ICON
                                            VStack{
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.lgreen.opacity(0.8))
                                                        .frame(width: 60, height: 60)
                                                    Image(systemName: iconForType(meal.type))
                                                        .font(.system(size: 28))
                                                        .foregroundColor(.dbrown)
                                                }
                                                Rectangle()
                                                    .fill(Color.gray.opacity(0.4))
                                                    .frame(width: 2, height: 40)
                                            }
                                            
                                            //MEAL NAME + TYPE
                                            
                                            VStack(alignment: .leading, spacing: 4){
                                                Text(meal.type + ": "+meal.name )
                                                    .font(.body)
                                                    .foregroundColor(.dbrown)
                                                    .strikethrough(meal.isCompleted, color: .dbrown)
                                                    .opacity(meal.isCompleted ? 0.6 : 1.0)
//                                                Text(dateTimeFormatter.string(from: meal.time))
//                                                    .font(.caption)
//                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Spacer()
                                            
                                            //CHECKMARK
                                            Image(systemName: meal.isCompleted ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(.dbrown)
                                                .onTapGesture {
                                                    if let idx = meals.firstIndex(where: { $0.id == meal.id }) {
                                                        meals[idx].isCompleted.toggle()
                                                    }
                                                }
                                            
                                            
                                        }
                                        
                                    }
                                }
                                .padding()
                                
                            }
                        }
                    }
                }
                
                // Add button
                Button(action: {
                    showAddMealSheet = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .padding(18)
                        .background(Color.dbrown)
                        .clipShape(Circle())
                        .shadow(radius: 6, x: 0, y: 3)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 28)
                .sheet(isPresented: $showAddMealSheet) {
                    AddMealView(showSheet: $showAddMealSheet){
                        newMeal in meals.append(newMeal)
                    }
                    .presentationDetents([.height(600)])
                    .presentationDragIndicator(.visible)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.lyellow.opacity(0.8), Color.dpink.opacity(0.9)]),
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
                current = calendar.date(byAdding: .day, value: 1, to: current)!
            }
            return dates
        }
    }
    
    // AddMealView (no changes except color fixes)
    struct AddMealView: View {
        @Binding var showSheet: Bool
        var onSave: (Meal) -> Void   // 👈 callback
        
        @State private var mealName: String = ""
        @State private var selectedMealType: String = "Breakfast"
        @State private var mealDate: Date = Date()
        
        let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"]
        
        var body: some View {
            NavigationStack {
                VStack(spacing: 60) {
                    HStack {
                        TextField("Enter meal name", text: $mealName)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.green.opacity(0.1))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.dbrown, lineWidth: 0.5)
                            )
                            .foregroundColor(.dbrown)
                            .accentColor(.dpink)
                            .padding(.horizontal)
                            .padding(.top, 50)
                        
                        Menu {
                            ForEach(mealTypes, id: \.self) { type in
                                Button(type) {
                                    selectedMealType = type
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedMealType)
                                    .foregroundColor(.dbrown)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.dbrown)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 15)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.green.opacity(0.1)))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.dbrown, lineWidth: 0.5)
                            )
                            .padding(.top, 50)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select meal time")
                            .font(.headline)
                            .foregroundColor(.dbrown)
                        
                        DatePicker("", selection: $mealDate, displayedComponents: [.hourAndMinute])
                            .labelsHidden()
                            .datePickerStyle(.wheel)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.green.opacity(0.1)))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.dbrown, lineWidth: 0.5)
                            )
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .navigationTitle("Add your meal")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showSheet = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            let newMeal = Meal(
                                time: mealDate,
                                type: selectedMealType,
                                name: mealName
                            )
                            onSave(newMeal)
                            showSheet = false
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background.ignoresSafeArea())
            }
            .accentColor(.dbrown)
        }
    }
    
    // Custom Shape for Rounded Corners
    struct TopRoundedCorner: Shape {
        var radius: CGFloat = 25.0
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
    
    struct Meal: Identifiable{
        let id = UUID()
        let time: Date
        let type: String
        let name: String
        var isCompleted: Bool = false
    }
    
    

    
    #Preview {
        MealsSH()
    }

