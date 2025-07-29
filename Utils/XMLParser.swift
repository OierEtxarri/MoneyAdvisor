import Foundation

class XMLParserUtil {
    static func parse(data: Data) -> [Movimiento] {
        class Delegate: NSObject, XMLParserDelegate {
            var movimientos: [Movimiento] = []
            var currentElement = ""
            var currentFecha: Date?
            var currentDescripcion = ""
            var currentCantidad: Double?
            var currentCategoria: Categoria?
            var currentTipo: TipoMovimiento?
            let dateFormatter: DateFormatter = {
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd"
                return df
            }()
            func parser(_ parser: Foundation.XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
                currentElement = elementName
            }
            func parser(_ parser: Foundation.XMLParser, foundCharacters string: String) {
                let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return }
                switch currentElement {
                case "fecha": currentFecha = dateFormatter.date(from: trimmed)
                case "descripcion": currentDescripcion = trimmed
                case "cantidad": currentCantidad = Double(trimmed)
                case "categoria": currentCategoria = Categoria(rawValue: trimmed)
                case "tipo": currentTipo = TipoMovimiento(rawValue: trimmed)
                default: break
                }
            }
            func parser(_ parser: Foundation.XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
                if elementName == "movimiento",
                   let fecha = currentFecha,
                   let cantidad = currentCantidad,
                   let categoria = currentCategoria,
                   let tipo = currentTipo {
                    let mov = Movimiento(
                        fecha: fecha,
                        descripcion: currentDescripcion,
                        cantidad: cantidad,
                        categoria: categoria,
                        tipo: tipo
                    )
                    movimientos.append(mov)
                    currentFecha = nil
                    currentDescripcion = ""
                    currentCantidad = nil
                    currentCategoria = nil
                    currentTipo = nil
                }
            }
        }
        let parser = Foundation.XMLParser(data: data)
        let delegate = Delegate()
        parser.delegate = delegate
        parser.parse()
        return delegate.movimientos
    }
}
