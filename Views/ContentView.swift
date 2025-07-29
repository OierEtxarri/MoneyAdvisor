import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MovementViewModel()

    var body: some View {
        TabView {
            AnalysisView(viewModel: viewModel)
                .tabItem {
                    Label("Analysis", systemImage: "chart.pie")
                }
            ImportView(viewModel: viewModel)
                .tabItem {
                    Label("Import", systemImage: "tray.and.arrow.down")
                }
            ConfigurationView(viewModel: viewModel)
                .tabItem {
                    Label("Configuration", systemImage: "gear")
                }
        }
    }
}
