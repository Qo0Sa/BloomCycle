//
//  PhaseType.swift
//  HomePage
//
//  Created by Sarah Alnasser on 05/10/2025.
//


//
//  PhaseEngine.swift
//  BloomCycle
//

import SwiftUI
import UIKit

// MARK: - Phase Types
enum PhaseType {
    case menstrual, follicular, ovulation, luteal

    var uiColor: UIColor {
        switch self {
        case .menstrual:  return .systemRed
        case .follicular: return .systemBlue
        case .ovulation:  return .systemOrange
        case .luteal:     return .systemGreen
        }
    }

    var displayName: String {
        switch self {
        case .menstrual:  return "Menstrual"
        case .follicular: return "Follicular"
        case .ovulation:  return "Ovulation"
        case .luteal:     return "Luteal"
        }
    }
}

struct PhaseCuts {
    let mEnd: Int     // last day of Menstrual (inclusive)
    let oStart: Int   // first day of Ovulation window
    let oEnd: Int     // last day of Ovulation window
    let lStart: Int   // first day of Luteal
}

// MARK: - Boundaries & Mapping
func phaseCuts(cycleLength L: Int,
               menstrualDays M: Int,
               lutealDays Lut: Int,
               ovulationDays O: Int = 2) -> PhaseCuts {
    let Lc   = max(20, min(45, L))
    let Mc   = max(2,  min(10, M))
    let Lutc = max(11, min(17, Lut))
    let Oc   = max(1,  min(3,  O))

    let mEnd   = Mc
    let lStart = Lc - Lutc + 1
    let oEnd   = max(mEnd + 1, lStart - 1)
    let oStart = max(mEnd + 1, oEnd - (Oc - 1))
    return PhaseCuts(mEnd: mEnd, oStart: oStart, oEnd: oEnd, lStart: lStart)
}

func phaseName(dayInCycle d: Int, cuts: PhaseCuts) -> PhaseType {
    if d <= cuts.mEnd { return .menstrual }
    if d >= cuts.lStart { return .luteal }
    if d >= cuts.oStart && d <= cuts.oEnd { return .ovulation }
    return .follicular
}

func dayInPhase(dayInCycle d: Int, cuts: PhaseCuts) -> Int {
    if d <= cuts.mEnd { return d }
    if d >= cuts.lStart { return d - cuts.lStart + 1 }
    if d >= cuts.oStart && d <= cuts.oEnd { return d - cuts.oStart + 1 }
    return d - cuts.mEnd
}

// MARK: - Day math
func dayInCycle(from start: Date, on date: Date, cycleLength: Int) -> Int {
    let cal = Calendar(identifier: .gregorian)
    let days = cal.dateComponents([.day], from: start.startOfDay, to: date.startOfDay).day ?? 0
    let wrapped = ((days % cycleLength) + cycleLength) % cycleLength
    return wrapped + 1
}

// MARK: - Calendar model used by the UIKit wrapper
final class PhaseCalendarModel {
    private(set) var startOfCycle: Date
    private(set) var cycleLength: Int
    private(set) var cuts: PhaseCuts

    init(startOfCycle: Date, cycleLength: Int, menstrualDays: Int, lutealDays: Int, ovulationDays: Int) {
        self.startOfCycle = startOfCycle
        self.cycleLength  = cycleLength
        self.cuts = phaseCuts(cycleLength: cycleLength,
                              menstrualDays: menstrualDays,
                              lutealDays: lutealDays,
                              ovulationDays: ovulationDays)
    }

    func update(startOfCycle: Date, cycleLength: Int, menstrualDays: Int, lutealDays: Int, ovulationDays: Int) {
        self.startOfCycle = startOfCycle
        self.cycleLength  = cycleLength
        self.cuts = phaseCuts(cycleLength: cycleLength,
                              menstrualDays: menstrualDays,
                              lutealDays: lutealDays,
                              ovulationDays: ovulationDays)
    }

    func phase(for date: Date) -> PhaseType? {
        let d = dayInCycle(from: startOfCycle, on: date, cycleLength: cycleLength)
        return phaseName(dayInCycle: d, cuts: cuts)
    }
}

// MARK: - Shared date utils
func isoToDate(_ s: String) -> Date? {
    guard !s.isEmpty else { return nil }
    return ISO8601DateFormatter().date(from: s)
}

extension Date {
    var startOfDay: Date { Calendar(identifier: .gregorian).startOfDay(for: self) }
}

extension DateFormatter {
    static let cached: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()
}

extension UIColor {
    var swiftUIColor: Color { Color(self) }
}
