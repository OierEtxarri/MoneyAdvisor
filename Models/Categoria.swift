import Foundation

enum Categoria: String, Codable, CaseIterable, Identifiable {
    case alimentacion
    case transporte
    case ocio
    case vivienda
    case salud
    case otros

    var id: String { self.rawValue }
}
