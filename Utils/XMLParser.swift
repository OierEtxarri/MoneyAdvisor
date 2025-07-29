import Foundation

class XMLParserUtil {
    static func parse(data: Data) -> [Movement] {
        class Delegate: NSObject, XMLParserDelegate {
            var movements: [Movement] = []
            var currentElement = ""
            var currentDate: Date?
            var currentDescription = ""
            var currentAmount: Double?
            var currentCategory: Category?
            var currentType: MovementType?
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
                case "fecha": currentDate = dateFormatter.date(from: trimmed)
                case "descripcion": currentDescription = trimmed
                case "cantidad": currentAmount = Double(trimmed)
                case "categoria": currentCategory = Category(rawValue: trimmed)
                case "tipo": currentType = MovementType(rawValue: trimmed)
                default: break
                }
            }
            func parser(_ parser: Foundation.XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
                if elementName == "movimiento",
                   let date = currentDate,
                   let amount = currentAmount,
                   let category = currentCategory,
                   let type = currentType {
                    let mov = Movement(
                        date: date,
                        description: currentDescription,
                        amount: amount,
                        category: category,
                        type: type
                    )
                    movements.append(mov)
                    currentDate = nil
                    currentDescription = ""
                    currentAmount = nil
                    currentCategory = nil
                    currentType = nil
                }
            }
        }
        let parser = Foundation.XMLParser(data: data)
        let delegate = Delegate()
        parser.delegate = delegate
        parser.parse()
        return delegate.movements
    }
}
