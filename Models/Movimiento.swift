import Foundation

enum TipoMovimiento: String, Codable {
enum MovementType: String, Codable {
    case income
    case expense
}

struct Movement: Identifiable, Codable {
    let id: UUID
    let date: Date
    let description: String
    let amount: Double
    let category: Category
    let type: MovementType

    init(date: Date, description: String, amount: Double, category: Category, type: MovementType) {
        self.id = UUID()
        self.date = date
        self.description = description
        self.amount = amount
        self.category = category
        self.type = type
    }
}
