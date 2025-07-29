import SwiftUI

struct ImportView: View {
    @ObservedObject var viewModel: MovementViewModel

    @State private var showFileImporter = false
    @State private var importError: String?
    var body: some View {
        VStack {
            Text("Import bank movements")
                .font(.headline)
            Button("Select file") {
                showFileImporter = true
            }
            .fileImporter(
                isPresented: $showFileImporter,
                allowedContentTypes: [.commaSeparatedText, .xml, .pdf],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    if let url = urls.first {
                        importFile(url: url)
                    }
                case .failure(let error):
                    importError = error.localizedDescription
                }
            }
            if let importError = importError {
                Text("Error: \(importError)").foregroundColor(.red)
            }
        }
        .padding()
    }

    func importFile(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let ext = url.pathExtension.lowercased()
            var newMovements: [Movement] = []
            if ext == "csv" {
                newMovements = CSVParser.parse(data: data)
            } else if ext == "xml" {
                newMovements = XMLParserUtil.parse(data: data)
            } else if ext == "pdf" {
                newMovements = PDFParserUtil.parse(data: data)
            } else {
                importError = "Unsupported file type"
                return
            }
            for mov in newMovements {
                viewModel.addMovement(mov)
            }
            importError = nil
        } catch {
            importError = error.localizedDescription
        }
    }
}
