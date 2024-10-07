import SwiftUI
import GraphRangeSlider

struct Element: GraphRangeElement {
    let x: Int
    let y: Int
}

struct ContentView: View {
    let data: [Element] = [
        .init(x: 10, y: 10),
        .init(x: 20, y: 20),
        .init(x: 30, y: 30),
        .init(x: 40, y: 40),
        .init(x: 50, y: 50),
        .init(x: 60, y: 60),
        .init(x: 70, y: 70),
    ]

    @State var selectedData = [Element]()

    var body: some View {
        GraphRangeSlider(
            data,
            id: \.x,
            selectedData: $selectedData
        )
//        .graph(barWidthRatio: 0.5)
//        .inactiveColor(Color.gray.opacity(0.8))
//        .activeColor(Color.blue)
//        .slider(toggleRadius: 6)
//        .slider(barHeight: 4)
    }
}

#Preview {
    ContentView()
}
