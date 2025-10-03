//
//  MealsSH.swift
//  BloomCycle
//
//  Created by Sarah on 10/04/1447 AH.
//

import SwiftUI

struct MealsSH: View {
    @State private var selectedDate: Date = Date()
    @State private var showAddMealSheet: Bool = false   // 👈 sheet state
    
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
                // الهيدر
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
                                    .foregroundColor(.dBrown)

                                Text(formatter.string(from: Date()))
                                    .font(.largeTitle).fontWeight(.bold)
                                    .foregroundColor(.dPink)
                            }
                        }

                        Spacer()

                        Button {} label: {
                            Image(systemName: "calendar")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(.dBrown)
                                .padding(8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // سكرول الأيام
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
                                                .fill(Color.dPink)
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

                // المستطيل الأبيض
                ZStack {
                    RoundedCorner(radius: 30, corners: [.topLeft, .topRight])
                        .fill(Color.background)
                        .frame(maxWidth: .infinity)
                        .ignoresSafeArea(edges: .bottom)
                        .frame(height: 600)

                    Text("No meals yet, \nAdd your meal!")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.lBrown)
                }
            }

            // زر الإضافة
            Button(action: {
                showAddMealSheet = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding(18)
                    .background(Color.dBrown)
                    .clipShape(Circle())
                    .shadow(radius: 6, x: 0, y: 3)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 28)
            // sheet فوق الصفحة البيضاء
            .sheet(isPresented: $showAddMealSheet) {
                AddMealView(showSheet: $showAddMealSheet)
                    .presentationDetents([.height(600)])   // 👈 نفس طول المستطيل الأبيض
                    .presentationDragIndicator(.visible)   // خط السحب
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.lyellow.opacity(0.8), Color.dPink.opacity(0.9)]),
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

// شاشة إضافة الوجبة
struct AddMealView: View {
    @Binding var showSheet: Bool
    
    @State private var mealName: String = ""       // اسم الوجبة
    @State private var selectedMealType: String = "Breakfast"  // نوع الوجبة
    @State private var mealDate: Date = Date()     // وقت الوجبة
    
    let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"] // الخيارات
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 60) {
                
                // TextField + DropDown
                HStack {
                    TextField("Enter meal name", text: $mealName)
                        .padding()
            
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green.opacity(0.1))   // 👈 الخلفية
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.dBrown, lineWidth: 0.5) // 👈 البوردر
                        )
                        .foregroundColor(.dBrown)   // 👈 لون النص داخل التكس فيلد
                        .accentColor(.dPink)        // 👈 لون المؤشر (Cursor)
                        .padding(.horizontal)
                    // 👈 لون المؤشر

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
                                .foregroundColor(.dBrown)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.dBrown)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 15)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green.opacity(0.1))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.dBrown, lineWidth: 0.5) // 👈 البوردر
                        )
                        .padding(.top, 50)

                    }
                }
                .padding(.horizontal)
                
                // DatePicker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select meal time")
                        .font(.headline)
                        .foregroundColor(.dBrown)
                    
                    DatePicker(
                        "",
                        selection: $mealDate,
                        displayedComponents: [.hourAndMinute]
                    )
                    .labelsHidden()
                    .datePickerStyle(.wheel) //  ستايل العجلة
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green.opacity(0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.dBrown, lineWidth: 0.5) //  البوردر
                    )
                }
                .padding(.horizontal)
                
                Spacer()
            }
            
            
            .navigationTitle("Add your meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showSheet = false
                        
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        print("Meal Saved: \(mealName), Type: \(selectedMealType), Date: \(mealDate)")
                        showSheet = false
                    }
                   
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            Color.background // F3F1ED
                                .ignoresSafeArea()
                        )
        }
        .accentColor(.dBrown)
    }
}


#Preview {
    MealsSH()
}

