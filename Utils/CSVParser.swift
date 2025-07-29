import Foundation

class CSVParser {
    static func parse(data: Data) -> [Movimiento] {
        guard let content = String(data: data, encoding: .utf8) else { return [] }
        var movimientos: [Movimiento] = []
        let lines = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
        guard lines.count > 1 else { return [] }
        // Asumimos cabecera: fecha,descripcion,cantidad,categoria,tipo
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for line in lines.dropFirst() {
            let fields = line.components(separatedBy: ",")
            if fields.count >= 5,
               let fecha = dateFormatter.date(from: fields[0]),
               let cantidad = Double(fields[2]),
               let categoria = Categoria(rawValue: fields[3]),
               let tipo = TipoMovimiento(rawValue: fields[4]) {
                let mov = Movimiento(
                    fecha: fecha,
                    descripcion: fields[1],
                    cantidad: cantidad,
                    categoria: categoria,
                    tipo: tipo
                )
                movimientos.append(mov)
            }
        }
        return movimientos
    }
}
