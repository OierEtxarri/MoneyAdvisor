import Foundation
import PDFKit

class PDFParserUtil {
    static func parse(data: Data) -> [Movement] {
        guard let pdfDoc = PDFDocument(data: data) else { return [] }
        var text = ""
        for i in 0..<pdfDoc.pageCount {
            if let page = pdfDoc.page(at: i), let pageText = page.string {
                text += pageText + "\n"
            }
        }
        // Assume each line is: date,description,amount,category,type
        let lines = text.components(separatedBy: .newlines).filter { !$0.isEmpty }
        var movements: [Movement] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for line in lines {
            let fields = line.components(separatedBy: ",")
            if fields.count >= 5,
               let date = dateFormatter.date(from: fields[0]),
               let amount = Double(fields[2]),
               let category = Category(rawValue: fields[3]),
               let type = MovementType(rawValue: fields[4]) {
                let mov = Movement(
                    date: date,
                    description: fields[1],
                    amount: amount,
                    category: category,
                    type: type
                )
                movements.append(mov)
            }
        }
        return movements
    }
}
