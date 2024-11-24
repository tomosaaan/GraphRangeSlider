import SwiftUI
import GraphRangeSlider

struct Element: GraphRangeElement {
    let x: Int
    let y: Int
}

struct ContentView: View {
    let data: [Element] = (1...5).map { .init(x: $0 * 10, y: $0 * 10) }

    @State var selectedData = [Element]()

    var body: some View {
        GraphRangeSlider(
            data,
            id: \.x,
            selectedData: $selectedData
        )
//        .hiddenChart(true)
//        .frame(height: 300, alignment: .bottom)
//        .hiddenChart(true)
//        .minCount(3)
//        .graph(width: .ratio(0.8), height: .fixed(50))
//        .inactiveColor(Color.gray.opacity(0.8))
//        .activeColor(Color.blue)
//        .slider(toggleRadius: 6)
//        .slider(barHeight: 4)
    }
}

#Preview {
    ContentView()
}
