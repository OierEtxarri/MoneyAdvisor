import Foundation
import PDFKit

class PDFParserUtil {
    static func parse(data: Data) -> [Movimiento] {
        guard let pdfDoc = PDFDocument(data: data) else { return [] }
        var text = ""
        for i in 0..<pdfDoc.pageCount {
            if let page = pdfDoc.page(at: i), let pageText = page.string {
                text += pageText + "\n"
            }
        }
        // Asumimos que cada línea es: fecha,descripcion,cantidad,categoria,tipo
        let lines = text.components(separatedBy: .newlines).filter { !$0.isEmpty }
        var movimientos: [Movimiento] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for line in lines {
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
