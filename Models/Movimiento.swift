import Foundation

enum TipoMovimiento: String, Codable {
    case ingreso
    case gasto
}

struct Movimiento: Identifiable, Codable {
    let id: UUID
    let fecha: Date
    let descripcion: String
    let cantidad: Double
    let categoria: Categoria
    let tipo: TipoMovimiento

    init(fecha: Date, descripcion: String, cantidad: Double, categoria: Categoria, tipo: TipoMovimiento) {
        self.id = UUID()
        self.fecha = fecha
        self.descripcion = descripcion
        self.cantidad = cantidad
        self.categoria = categoria
        self.tipo = tipo
    }
}
