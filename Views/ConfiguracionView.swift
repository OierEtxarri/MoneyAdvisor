import SwiftUI

struct ConfiguracionView: View {
    @ObservedObject var viewModel: MovimientoViewModel

    var body: some View {
        VStack {
            Text("Configuración de límites")
                .font(.headline)
            HStack {
                Text("Límite mensual:")
                TextField("Límite", value: $viewModel.configuracion.limiteMensual, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
            }
            .padding()
            // Puedes agregar más configuraciones aquí
        }
        .padding()
    }
}
