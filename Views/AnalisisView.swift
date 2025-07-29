import SwiftUI

struct AnalysisView: View {
    @ObservedObject var viewModel: MovementViewModel

    @State private var currentMonth = Calendar.current.component(.month, from: Date())
    @State private var currentYear = Calendar.current.component(.year, from: Date())

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Monthly Summary")
                    .font(.headline)
                HStack {
                    Text("Month: ")
                    Picker("Month", selection: $currentMonth) {
                        ForEach(1...12, id: \ .self) { m in
                            Text("\(DateFormatter().monthSymbols[m-1])").tag(m)
                        }
                    }.pickerStyle(MenuPickerStyle())
                    Text("Year: ")
                    Picker("Year", selection: $currentYear) {
                        ForEach((2020...Calendar.current.component(.year, from: Date())).reversed(), id: \ .self) { y in
                            Text("\(y)").tag(y)
                        }
                    }.pickerStyle(MenuPickerStyle())
                }
                Divider()
                Text("Income: $\(viewModel.totalIncomes(month: currentMonth, year: currentYear), specifier: "%.2f")")
                Text("Expenses: $\(viewModel.totalExpenses(month: currentMonth, year: currentYear), specifier: "%.2f")")
                Divider()
                Text("Recommendations:").font(.subheadline)
                ForEach(viewModel.recommendations(month: currentMonth, year: currentYear), id: \ .self) { rec in
                    Text("• " + rec)
                }
                Divider()
                Text("Expenses by category:").font(.subheadline)
                PieChartView(data: viewModel.expensesByCategory(month: currentMonth, year: currentYear))
            }
            .padding()
        }
    }
}

struct PieChartView: View {
    let data: [(Category, Double)]
    var total: Double { data.reduce(0) { $0 + $1.1 } }
    let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .gray]
    var body: some View {
        if data.isEmpty {
            Text("No data to display")
        } else {
            GeometryReader { geo in
                ZStack {
                    ForEach(0..<data.count, id: \ .self) { i in
                        PieSliceView(startAngle: angle(at: i), endAngle: angle(at: i+1), color: colors[i % colors.count])
                    }
                }
                .frame(width: min(geo.size.width, 200), height: min(geo.size.width, 200))
            }
            .frame(height: 220)
            VStack(alignment: .leading) {
                ForEach(Array(data.enumerated()), id: \ .offset) { i, d in
                    HStack {
                        Circle().fill(colors[i % colors.count]).frame(width: 12, height: 12)
                        Text("\(d.0.rawValue.capitalized): $\(d.1, specifier: "%.2f")")
                    }
                }
            }
        }
    }
    func angle(at index: Int) -> Angle {
        let sum = data.prefix(index).reduce(0) { $0 + $1.1 }
        return .degrees(360 * sum / max(total, 0.01))
    }
}

struct PieSliceView: View {
    var startAngle: Angle
    var endAngle: Angle
    var color: Color
    var body: some View {
        Path { path in
            let center = CGPoint(x: 100, y: 100)
            path.move(to: center)
            path.addArc(center: center, radius: 100, startAngle: startAngle - .degrees(90), endAngle: endAngle - .degrees(90), clockwise: false)
        }
        .fill(color)
    }
}
