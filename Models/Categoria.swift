import Foundation

enum Categoria: String, Codable, CaseIterable, Identifiable {

enum Category: String, Codable, CaseIterable, Identifiable {
    case food
    case transport
    case leisure
    case housing
    case health
    case others

    var id: String { self.rawValue }
}
