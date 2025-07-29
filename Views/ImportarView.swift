import SwiftUI

struct ImportarView: View {
    @ObservedObject var viewModel: MovimientoViewModel

    @State private var showFileImporter = false
    @State private var importError: String?
    var body: some View {
        VStack {
            Text("Importar movimientos bancarios")
                .font(.headline)
            Button("Seleccionar archivo") {
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
            var nuevos: [Movimiento] = []
            if ext == "csv" {
                nuevos = CSVParser.parse(data: data)
            } else if ext == "xml" {
                nuevos = XMLParserUtil.parse(data: data)
            } else if ext == "pdf" {
                nuevos = PDFParserUtil.parse(data: data)
            } else {
                importError = "Tipo de archivo no soportado"
                return
            }
            for mov in nuevos {
                viewModel.agregarMovimiento(mov)
            }
            importError = nil
        } catch {
            importError = error.localizedDescription
        }
    }
}
