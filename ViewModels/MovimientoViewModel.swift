import Foundation

class MovementViewModel: ObservableObject {
    @Published var movements: [Movement] = []
    @Published var configuration = Configuration(monthlyLimit: 0)

    // Recommendations and analysis
    func recommendations(month: Int, year: Int) -> [String] {
        var recs: [String] = []
        let expenses = totalExpenses(month: month, year: year)
        let incomes = totalIncomes(month: month, year: year)
        if incomes == 0 {
            recs.append("No income registered this month.")
        } else if expenses > incomes {
            recs.append("Your expenses exceed your income. Consider reducing expenses.")
        } else if expenses > incomes * 0.8 {
            recs.append("You are spending more than 80% of your income.")
        } else {
            recs.append("Good job! Your expenses are under control.")
        }
        if expenses > configuration.monthlyLimit && configuration.monthlyLimit > 0 {
            recs.append("You have exceeded your monthly spending limit.")
        }
        // Category with most expense
        let cat = highestExpenseCategory(month: month, year: year)
        if let cat = cat {
            recs.append("The category with the most expense is: \(cat.rawValue.capitalized)")
        }
        return recs
    }

    func highestExpenseCategory(month: Int, year: Int) -> Category? {
        let expenses = movements.filter {
            $0.type == .expense &&
            Calendar.current.component(.month, from: $0.date) == month &&
            Calendar.current.component(.year, from: $0.date) == year
        }
        let grouped = Dictionary(grouping: expenses, by: { $0.category })
        let sumByCat = grouped.mapValues { $0.reduce(0) { $0 + $1.amount } }
        return sumByCat.max(by: { $0.value < $1.value })?.key
    }

    func expensesByCategory(month: Int, year: Int) -> [(Category, Double)] {
        let expenses = movements.filter {
            $0.type == .expense &&
            Calendar.current.component(.month, from: $0.date) == month &&
            Calendar.current.component(.year, from: $0.date) == year
        }
        let grouped = Dictionary(grouping: expenses, by: { $0.category })
        let sumByCat = grouped.mapValues { $0.reduce(0) { $0 + $1.amount } }
        return sumByCat.sorted { $0.value > $1.value }
    }

    func addMovement(_ movement: Movement) {
        movements.append(movement)
    }

    func totalExpenses(month: Int, year: Int) -> Double {
        movements.filter {
            $0.type == .expense &&
            Calendar.current.component(.month, from: $0.date) == month &&
            Calendar.current.component(.year, from: $0.date) == year
        }.reduce(0) { $0 + $1.amount }
    }

    func totalIncomes(month: Int, year: Int) -> Double {
        movements.filter {
            $0.type == .income &&
            Calendar.current.component(.month, from: $0.date) == month &&
            Calendar.current.component(.year, from: $0.date) == year
        }.reduce(0) { $0 + $1.amount }
    }
}
