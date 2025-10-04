import SwiftUI

struct WeekStrip: View {
    @State private var selectedDate: Date = Date()
    private let calendar = Calendar.current
    
    // إعداد الفورماترز
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
    
    private let monthFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "LLLL"
        return f
    }()
    
    private let yearFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy"
        return f
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // الهيدر فوق السكرول
            HStack(alignment: .firstTextBaseline) {
                Text(monthFormatter.string(from: selectedDate))
                    .font(.system(size: 48, weight: .bold))
                Text(yearFormatter.string(from: selectedDate))
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(Color.pink.opacity(0.8))
            }
            
            // السكرول تحت الهيدر
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 18) {
                    ForEach(allDays(), id: \.self) { day in
                        let isSelected = calendar.isDate(day, inSameDayAs: selectedDate)
                        VStack(spacing: 6) {
                            Text(dayFormatter.string(from: day))
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(isSelected ? .white : .primary)
                            
                            Text(weekdayFormatter.string(from: day))
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 14)
                        .background(
                            Group {
                                if isSelected {
                                    Circle()
                                        .fill(Color.pink)
                                        .frame(width: 48, height: 48)
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
            
            Divider()
            
            Spacer() // يدفع كل شيء للأعلى
        }
        .padding()
    }
    
    // توليد كل الأيام ابتداءً من الشهر الذي قبل اليوم الحالي حتى نهاية السنة
    private func allDays() -> [Date] {
        let today = Date()
        let currentYear = calendar.component(.year, from: today)
        let currentMonth = calendar.component(.month, from: today)
        
        // الشهر الذي قبل الشهر الحالي (أو يناير إذا الشهر الحالي يناير)
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

// MARK: - Preview
struct WeekStrip_Previews: PreviewProvider {
    static var previews: some View {
        WeekStrip()
            .previewLayout(.sizeThatFits)
    }
}

