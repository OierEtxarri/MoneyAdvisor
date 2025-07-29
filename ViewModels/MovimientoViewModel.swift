import Foundation

class MovimientoViewModel: ObservableObject {
    @Published var movimientos: [Movimiento] = []
    @Published var configuracion = Configuracion(limiteMensual: 0)

    // Recomendaciones y análisis
    func recomendaciones(mes: Int, anio: Int) -> [String] {
        var recs: [String] = []
        let gastos = totalGastos(mes: mes, anio: anio)
        let ingresos = totalIngresos(mes: mes, anio: anio)
        if ingresos == 0 {
            recs.append("No hay ingresos registrados este mes.")
        } else if gastos > ingresos {
            recs.append("Tus gastos superan tus ingresos. Considera reducir gastos.")
        } else if gastos > ingresos * 0.8 {
            recs.append("Estás gastando más del 80% de tus ingresos.")
        } else {
            recs.append("¡Buen trabajo! Tus gastos están bajo control.")
        }
        if gastos > configuracion.limiteMensual && configuracion.limiteMensual > 0 {
            recs.append("Has superado tu límite mensual de gastos.")
        }
        // Categoría con más gasto
        let cat = categoriaMayorGasto(mes: mes, anio: anio)
        if let cat = cat {
            recs.append("La categoría con más gasto es: \(cat.rawValue.capitalized)")
        }
        return recs
    }

    func categoriaMayorGasto(mes: Int, anio: Int) -> Categoria? {
        let gastos = movimientos.filter {
            $0.tipo == .gasto &&
            Calendar.current.component(.month, from: $0.fecha) == mes &&
            Calendar.current.component(.year, from: $0.fecha) == anio
        }
        let agrupados = Dictionary(grouping: gastos, by: { $0.categoria })
        let sumaPorCat = agrupados.mapValues { $0.reduce(0) { $0 + $1.cantidad } }
        return sumaPorCat.max(by: { $0.value < $1.value })?.key
    }

    func gastosPorCategoria(mes: Int, anio: Int) -> [(Categoria, Double)] {
        let gastos = movimientos.filter {
            $0.tipo == .gasto &&
            Calendar.current.component(.month, from: $0.fecha) == mes &&
            Calendar.current.component(.year, from: $0.fecha) == anio
        }
        let agrupados = Dictionary(grouping: gastos, by: { $0.categoria })
        let sumaPorCat = agrupados.mapValues { $0.reduce(0) { $0 + $1.cantidad } }
        return sumaPorCat.sorted { $0.value > $1.value }
    }

    func agregarMovimiento(_ movimiento: Movimiento) {
        movimientos.append(movimiento)
    }

    func totalGastos(mes: Int, anio: Int) -> Double {
        movimientos.filter {
            $0.tipo == .gasto &&
            Calendar.current.component(.month, from: $0.fecha) == mes &&
            Calendar.current.component(.year, from: $0.fecha) == anio
        }.reduce(0) { $0 + $1.cantidad }
    }

    func totalIngresos(mes: Int, anio: Int) -> Double {
        movimientos.filter {
            $0.tipo == .ingreso &&
            Calendar.current.component(.month, from: $0.fecha) == mes &&
            Calendar.current.component(.year, from: $0.fecha) == anio
        }.reduce(0) { $0 + $1.cantidad }
    }
}
