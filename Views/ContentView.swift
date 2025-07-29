import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MovimientoViewModel()

    var body: some View {
        TabView {
            AnalisisView(viewModel: viewModel)
                .tabItem {
                    Label("Análisis", systemImage: "chart.pie")
                }
            ImportarView(viewModel: viewModel)
                .tabItem {
                    Label("Importar", systemImage: "tray.and.arrow.down")
                }
            ConfiguracionView(viewModel: viewModel)
                .tabItem {
                    Label("Configuración", systemImage: "gear")
                }
        }
    }
}
