//
//  ContentView.swift
//  BloomCycle
//
//  Created by Sarah Alnasser on 28/09/2025.
//
import SwiftUI
import UIKit

struct ContentView: View {
    //name & calender variabels
    @State private var cyclesheet = false
    @State private var userName = ""
    @State private var selectedCycleDate: Date? = nil
    
    // 📌 Focus handling for keyboard
    @FocusState private var nameFocused: Bool

    // 📌 @AppStorage persists values across launches using UserDefaults
    @AppStorage("lastPeriodStartISO") private var lastPeriodStartISO = ""
    @AppStorage("cycleLength")        private var cycleLength = 28
    @AppStorage("menstrualDays")      private var menstrualDays = 7
    @AppStorage("lutealDays")         private var lutealDays = 14
    @AppStorage("ovulationDays")      private var ovulationDays = 2

    var body: some View {
        // 📌 GeometryReader used to pin content so keyboard insets don't relayout our stack.
        GeometryReader { geo in
            ZStack {
                // Background 🖼️
                // 📌 Nested GeometryReader used so the image can size to its container
                GeometryReader { proxy in
                    Image("background1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .top)
                        .ignoresSafeArea()
                }
                
                //Center Content (Cycle status)
                VStack {
                    CycleStatusView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .padding(.bottom, 440)
                }
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.keyboard, edges: .all)
                
                
                //calendar 📅
                .overlay(alignment: .topTrailing) {
                    NavigationLink {
                        CalendarScreen()
                    }
                    label: {
                        Image(systemName: "calendar")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundColor(Color.darkbrown)
                            .padding(8)
                    }
                    .padding(.top, -60)
                    .padding(.trailing, 10)
                }
                
                // Hello + name 🙋‍♀️
                .safeAreaInset(edge: .top) {
                    HStack {
                        Text("Hello!")
                            .font(.title).fontWeight(.bold)
                            .foregroundColor(Color.darkbrown)
                        
                        TextField("Name", text: $userName)
                            .font(.title).fontWeight(.bold)
                            .foregroundColor(userName.isEmpty ? .gray : Color.darkbrown)
                            .underline(userName.isEmpty, color: .gray)
                            .frame(maxWidth: 150)
                            .focused($nameFocused) // 📌 connects to FocusState above
                            .submitLabel(.done)
                    }
                    .fixedSize() // 📌 Avoids unexpected line wraps
                    .padding(.top, 10)
                    .background(Color.clear)
                }
                
                //"My Cycle" button 🟩
                .overlay(alignment: .top) {
                    Button { cyclesheet.toggle() } label: {
                        Text("My Cycle")
                            .font(.headline)
                            .foregroundColor(Color.darkbrown)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 36)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.ourgreen))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.15), lineWidth: 2))
                            .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
                    }
                    .padding(.top, 350)
                }
                
                // food + recommendations buttons 🍕
                VStack {
                    HStack(spacing: 24) {
                        Button {
                            // 🛑Navigate to Food Tracking
                        } label: {
                            VStack(spacing: 24) {
                                Image("food_image_home")
                                    .resizable().scaledToFit().frame(height: 100)
                                Text("Food track")
                                    .font(.subheadline).foregroundColor(Color.darkbrown)
                            }
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity, minHeight: 240)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.eggshell))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.darkbrown.opacity(0.15), lineWidth: 2))
                            .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
                        }

                        Button {
                            // 🛑Navigate to Recommendations
                        } label: {
                            VStack(spacing: 24) {
                                Image("recomm_image_home")
                                    .resizable().scaledToFit().frame(height: 100)
                                Text("recommendations")
                                    .font(.subheadline).foregroundColor(Color.darkbrown)
                            }
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity, minHeight: 240)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.eggshell))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.darkbrown.opacity(0.15), lineWidth: 2))
                            .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 50)
                    .background(Color.clear)
                    .zIndex(10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .ignoresSafeArea(.keyboard, edges: .all)
            .contentShape(Rectangle())
            .onTapGesture { nameFocused = false }
        }
        //Sheet for “My Cycle”
        .sheet(isPresented: $cyclesheet) {
            NewCycleView(selectedDate: $selectedCycleDate)
                .presentationDetents([.medium]) //📌 iOS 16+ partial-height sheet
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}



// "My Cycle" Sheet
// Pick a single date via UIKit calendar
struct NewCycleView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date?

    //cycle settings for saving the chosen date
    @AppStorage("lastPeriodStartISO") private var lastPeriodStartISO = ""
    @AppStorage("cycleLength")        private var cycleLength = 28
    @AppStorage("menstrualDays")      private var menstrualDays = 7
    @AppStorage("lutealDays")         private var lutealDays = 14
    @AppStorage("ovulationDays")      private var ovulationDays = 2

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                if #available(iOS 16.0, *) {
                    //📌 calendar + locale for consistent behavior regardless of device settings.
                    UICalendarSingleDateView(
                        selectedDate: $selectedDate,
                        availableRange: nil,
                        calendar: Calendar(identifier: .gregorian),
                        locale: Locale(identifier: "en_SA")
                    )
                    .frame(height: 380)
                    .padding(.top, 12)
                } else {
                    Text("Requires iOS 16+")
                }

                //Live feedback label for picked date
                Text(selectedDate.map { "Selected: \($0.formatted(date: .abbreviated, time: .omitted))" } ?? "No date selected")
                    .foregroundColor(.secondary)
                    .padding(.top, 10)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)

                Spacer()
            }
            .padding()
            .navigationTitle("Select Period Day")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { saveDateAndDismiss() }.bold()
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .all)
    }

    private func saveDateAndDismiss() {
        guard let picked = selectedDate else { dismiss(); return }
        //📌 ISO8601 formatting for stable, locale-independent storage across devices/timezones.
        let f = ISO8601DateFormatter()
        lastPeriodStartISO = f.string(from: picked)
        dismiss()
    }
}


// UIKit Bridge (Single-Date Calendar)
@available(iOS 16.0, *)
struct UICalendarSingleDateView: UIViewRepresentable {
    @Binding var selectedDate: Date?

    var availableRange: DateInterval? = nil
    var calendar: Calendar = .current
    var locale: Locale = .current

    //📌 Coordinator is a glue object that lets UIKit call back into SwiftUI.
    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.calendar = calendar
        view.locale = locale
        if let range = availableRange { view.availableDateRange = range }

        view.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        return view
    }

    func updateUIView(_ view: UICalendarView, context: Context) {
        view.calendar = calendar
        view.locale = locale
        if let range = availableRange { view.availableDateRange = range }

        //📌This avoids mismatch if SwiftUI changes the date programmatically.
        if let date = selectedDate {
            let comps = calendar.dateComponents([.year, .month, .day], from: date)
            (view.selectionBehavior as? UICalendarSelectionSingleDate)?
                .setSelected(comps, animated: false)
        } else {
            (view.selectionBehavior as? UICalendarSelectionSingleDate)?
                .setSelected(nil, animated: false)
        }
    }

    //📌 When the user taps a date in the UIKit calendar, this method fires
    final class Coordinator: NSObject, UICalendarSelectionSingleDateDelegate {
        var parent: UICalendarSingleDateView
        init(_ parent: UICalendarSingleDateView) { self.parent = parent }

        func dateSelection(_ selection: UICalendarSelectionSingleDate,
                           didSelectDate dateComponents: DateComponents?) {
            if let dc = dateComponents,
               let date = Calendar.current.date(from: dc) {
                parent.selectedDate = date
            } else {
                parent.selectedDate = nil
            }
        }
    }
}


// Cycle Status Panel
// Shows day-in-phase number, phase name, and days to next period
struct CycleStatusView: View {
    @AppStorage("lastPeriodStartISO") private var lastPeriodStartISO: String = ""
    @AppStorage("cycleLength")        private var cycleLength: Int = 28
    @AppStorage("menstrualDays")      private var menstrualDays: Int = 7
    @AppStorage("lutealDays")         private var lutealDays: Int = 14
    @AppStorage("ovulationDays")      private var ovulationDays: Int = 2

    var body: some View {
        VStack(spacing: 10) {
            if let start = isoToDate(lastPeriodStartISO), (20...45).contains(cycleLength) {

                let today    = Date()
                let d        = dayInCycle(from: start, on: today, cycleLength: cycleLength)
                let daysLeft = max(0, cycleLength - d)

                let cuts     = phaseCuts(
                    cycleLength: cycleLength,
                    menstrualDays: menstrualDays,
                    lutealDays: lutealDays,
                    ovulationDays: ovulationDays
                )

                let phase    = phaseName(dayInCycle: d, cuts: cuts)
                let inPhase  = dayInPhase(dayInCycle: d, cuts: cuts)

                // Big number = “day within current phase”
                Text("\(inPhase)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(Color.darkbrown)
                    .padding(.top, 16)

                Text(phase.displayName)
                    .font(.headline)
                    .foregroundColor(Color.darkbrown)

                let label: String = {
                    if daysLeft == 0 { return "next Menstrual phase is tomorrow" }
                    return "\(daysLeft) day\(daysLeft == 1 ? "" : "s") until next Menstrual phase"
                }()

                Text(label)
                    .font(.caption)
                    .foregroundColor(Color.darkbrown)
                    .padding(.top, 2)

            } else {
                Text("--")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(Color.darkbrown.opacity(0.4))

                Text("Start by Adding Your Cycle!!")
                    .font(.subheadline)
                    .foregroundColor(Color.darkbrown)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Day in cycle and current phase")
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}

#Preview {
    ContentView()
}
