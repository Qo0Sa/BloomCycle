//
//  CalendarScreen.swift
//  HomePage
//
//  Created by Sarah Alnasser on 05/10/2025.
//


//
//  CalendarScreen.swift
//  BloomCycle
//

import SwiftUI
import UIKit

struct CalendarScreen: View {
    @AppStorage("lastPeriodStartISO") private var lastPeriodStartISO: String = ""
    @AppStorage("cycleLength")        private var cycleLength: Int = 28
    @AppStorage("menstrualDays")      private var menstrualDays: Int = 7
    @AppStorage("lutealDays")         private var lutealDays: Int = 14
    @AppStorage("ovulationDays")      private var ovulationDays: Int = 2

    // Which date is being described (defaults to today)
    @State private var selectedDate: Date? = Date()

    var body: some View {
        VStack(spacing: 12) {
            if let start = isoToDate(lastPeriodStartISO), (20...45).contains(cycleLength) {
                if #available(iOS 16.0, *) {
                    UICalendarPhaseView(
                        startOfCycle: start,
                        cycleLength: cycleLength,
                        menstrualDays: menstrualDays,
                        lutealDays: lutealDays,
                        ovulationDays: ovulationDays,
                        selectedDate: $selectedDate
                    )
                    .frame(height: 480)

                    // Dynamic text for the selected (or today's) date
                    PhaseBadge(
                        startOfCycle: start,
                        cycleLength: cycleLength,
                        menstrualDays: menstrualDays,
                        lutealDays: lutealDays,
                        ovulationDays: ovulationDays,
                        date: selectedDate ?? Date()
                    )
                    .padding(.horizontal)

                    // Clear, textual legend panel
                    PhaseLegendPanel()
                        .padding(.horizontal)

                    Text("Tap a day to see its phase. Scroll for upcoming months.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 6)
                } else {
                    Text("Requires iOS 16+ for calendar rendering.")
                        .foregroundColor(.secondary)
                        .padding()
                }
            } else {
                Text("Set your cycle from the Home page to see the calendar.")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .navigationTitle("My Cycle Calendar")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Dynamic Phase Badge (text under calendar)
private struct PhaseBadge: View {
    let startOfCycle: Date
    let cycleLength: Int
    let menstrualDays: Int
    let lutealDays: Int
    let ovulationDays: Int
    let date: Date

    var body: some View {
        let cuts  = phaseCuts(cycleLength: cycleLength,
                              menstrualDays: menstrualDays,
                              lutealDays: lutealDays,
                              ovulationDays: ovulationDays)
        let d     = dayInCycle(from: startOfCycle, on: date, cycleLength: cycleLength)
        let phase = phaseName(dayInCycle: d, cuts: cuts)
        let name  = phase.displayName
        let ui    = phase.uiColor

        HStack(spacing: 8) {
            Circle().fill(Color(ui)).frame(width: 10, height: 10)
            Text("\(name) • Day \(d) of \(cycleLength)  (\(DateFormatter.cached.string(from: date)))")
                .font(.subheadline.weight(.medium))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(Color(ui).withAlphaComponent(0.12).swiftUIColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .accessibilityLabel("\(name), day \(d) of \(cycleLength)")
    }
}

// MARK: - Prominent Legend Panel (text + colors)
private struct PhaseLegendPanel: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Phase Color Guide")
                .font(.headline)
                .padding(.bottom, 4)

            HStack(spacing: 18) {
                LegendItem(color: .systemRed,    text: "Menstrual Phase")
                LegendItem(color: .systemBlue,   text: "Follicular Phase")
            }
            HStack(spacing: 18) {
                LegendItem(color: .systemOrange, text: "Ovulation Phase")
                LegendItem(color: .systemGreen,  text: "Luteal Phase")
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct LegendItem: View {
    let color: UIColor
    let text: String
    var body: some View {
        HStack(spacing: 8) {
            Circle().fill(Color(color)).frame(width: 12, height: 12)
            Text(text).font(.caption).foregroundColor(.primary)
        }
    }
}

// MARK: - UIKit wrapper with selection + dots
@available(iOS 16.0, *)
struct UICalendarPhaseView: UIViewRepresentable {
    let startOfCycle: Date
    let cycleLength: Int
    let menstrualDays: Int
    let lutealDays: Int
    let ovulationDays: Int

    @Binding var selectedDate: Date?

    func makeCoordinator() -> Coordinator {
        Coordinator(
            model: PhaseCalendarModel(
                startOfCycle: startOfCycle,
                cycleLength: cycleLength,
                menstrualDays: menstrualDays,
                lutealDays: lutealDays,
                ovulationDays: ovulationDays
            ),
            selectedDate: $selectedDate
        )
    }

    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.calendar = Calendar(identifier: .gregorian)
        view.locale = Locale(identifier: "en_SA")

        // Scrollable range
        let cal = view.calendar
        let start = cal.date(byAdding: .year, value: -1, to: startOfCycle.startOfDay)!
        let end   = cal.date(byAdding: .year, value:  2, to: startOfCycle.startOfDay)!
        view.availableDateRange = DateInterval(start: start, end: end)

        view.delegate = context.coordinator

        // Enable tapping a single date
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.selectionBehavior = selection

        // Preselect today
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        selection.setSelected(comps, animated: false)

        return view
    }

    func updateUIView(_ view: UICalendarView, context: Context) {
        context.coordinator.model.update(
            startOfCycle: startOfCycle,
            cycleLength: cycleLength,
            menstrualDays: menstrualDays,
            lutealDays: lutealDays,
            ovulationDays: ovulationDays
        )
        view.reloadDecorations(forDateComponents: nil, animated: false)

        // Sync UIKit selection if SwiftUI changes it
        if let sel = view.selectionBehavior as? UICalendarSelectionSingleDate,
           let date = selectedDate {
            let comps = Calendar.current.dateComponents([.year, .month, .day], from: date)
            sel.setSelected(comps, animated: false)
        }
    }

    final class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var model: PhaseCalendarModel
        @Binding var selectedDate: Date?

        init(model: PhaseCalendarModel, selectedDate: Binding<Date?>) {
            self.model = model
            self._selectedDate = selectedDate
        }

        // Colored dot on each day
        func calendarView(_ calendarView: UICalendarView,
                          decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            guard let date = calendarView.calendar.date(from: dateComponents) else { return nil }
            guard let phase = model.phase(for: date) else { return nil }

            let dot = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            dot.backgroundColor = phase.uiColor
            dot.layer.cornerRadius = 5
            dot.isUserInteractionEnabled = false
            return .customView { dot }
        }

        // Update SwiftUI selection on tap
        func dateSelection(_ selection: UICalendarSelectionSingleDate,
                           didSelectDate dateComponents: DateComponents?) {
            if let comps = dateComponents,
               let date = Calendar.current.date(from: comps) {
                selectedDate = date
            } else {
                selectedDate = nil
            }
        }

        func dateSelection(_ selection: UICalendarSelectionSingleDate,
                           canSelectDate dateComponents: DateComponents?) -> Bool {
            // Read-only calendar: always allow selection within available range
            return true
        }
    }
}

// MARK: - Small helpers
private extension PhaseType {
    var displayName: String {
        switch self {
        case .menstrual:  return "Menstrual"
        case .follicular: return "Follicular"
        case .ovulation:  return "Ovulation"
        case .luteal:     return "Luteal"
        }
    }
}

private extension UIColor {
    var swiftUIColor: Color { Color(self) }
}
