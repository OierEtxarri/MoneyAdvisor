import SwiftUI

struct ConfigurationView: View {
    @ObservedObject var viewModel: MovementViewModel

    var body: some View {
        VStack {
            Text("Limit Configuration")
                .font(.headline)
            HStack {
                Text("Monthly limit:")
                TextField("Limit", value: $viewModel.configuration.monthlyLimit, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
            }
            .padding()
            // You can add more configurations here
        }
        .padding()
    }
}
