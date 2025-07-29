import Foundation

class CSVParser {
    static func parse(data: Data) -> [Movement] {
        guard let content = String(data: data, encoding: .utf8) else { return [] }
        var movements: [Movement] = []
        let lines = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
        guard lines.count > 1 else { return [] }
        // Assume header: date,description,amount,category,type
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for line in lines.dropFirst() {
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
