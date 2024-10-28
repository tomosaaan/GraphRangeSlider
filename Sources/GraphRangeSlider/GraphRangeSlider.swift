import SwiftUI
import Charts

public struct GraphRangeSlider<Data, ID>: View where Data: RandomAccessCollection, Data.Element: GraphRangeElement, Data.Index == Int, ID: Hashable {
    private enum Status: String, Plottable {
        case active, inactive
    }

    private enum PlottableKeys: String {
        case x, y, status
    }

    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let builder = GraphRangeSliderBuilder()
    @Binding private var selectedData: Data
    @State private var leftCurrentIndex = 0
    @State private var rightCurrentIndex = 0
    @State private var positions = ContiguousArray<CGFloat>()
    @Environment(\.graphDimension) private var graphDimension: EnvironmentValues.BarDimension
    @Environment(\.activeColor) private var activeColor: Color
    @Environment(\.inactiveColor) private var inactiveColor: Color
    @Environment(\.toggleRadius) private var toggleRadius: CGFloat
    @Environment(\.sliderBarHeight) private var sliderBarHeight: CGFloat
    @Environment(\.margin) private var margin: CGFloat

    public var body: some View {
        GeometryReader { reader in
            Chart(data, id: id) { data in
                BarMark(
                    x: .value(PlottableKeys.x, String(describing: data.x)),
                    y: .value(PlottableKeys.y, data.y),
                    width: graphDimension.width,
                    height: graphDimension.height
                )
                .foregroundStyle(
                    by: .value(
                        PlottableKeys.status,
                        selectedData.contains(data) ? Status.active: Status.inactive
                    )
                )
            }
            .padding(.horizontal, toggleRadius * 2)
            .padding(.bottom, toggleRadius + sliderBarHeight / 2 + margin)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .chartLegend(.hidden)
            .chartForegroundStyleScale([
                Status.active: activeColor,
                Status.inactive: inactiveColor
            ])
            .overlay(alignment: .bottom) {
                if !positions.isEmpty {
                    Slider(
                        positions: positions,
                        onEnded: { builder.onEnded.call(selectedData) },
                        leftCurrentIndex: $leftCurrentIndex,
                        rightCurrentIndex: $rightCurrentIndex
                    )
                    .frame(height: toggleRadius * 2)
                }
            }
            .onChange(of: leftCurrentIndex) { _ in
                onChangedSelectedData()
            }
            .onChange(of: rightCurrentIndex) { _ in
                onChangedSelectedData()
            }
            .onAppear {
                let width = reader.size.width - toggleRadius * 4
                let barMarkWidth = width / CGFloat(data.count)

                positions = .init(
                    stride(from: toggleRadius,
                           through: barMarkWidth * CGFloat(data.count) + toggleRadius,
                           by: barMarkWidth)
                )

                if !positions.isEmpty {
                    positions[0] = 0
                    positions[positions.count - 1] += toggleRadius
                    leftCurrentIndex = if !selectedData.isEmpty, let selectedIndex = data.firstIndex(of: selectedData[0]) {
                        selectedIndex
                    } else {
                        0
                    }
                    rightCurrentIndex = if !selectedData.isEmpty, let selectedIndex = data.firstIndex(of: selectedData[selectedData.count - 1]) {
                        selectedIndex + 1
                    } else {
                        positions.count - 1
                    }
                }
            }
        }
    }

    private func onChangedSelectedData() {
        let selectedIndexRange = leftCurrentIndex ..< rightCurrentIndex
        if let selectedData = Array(data[selectedIndexRange]) as? Data {
            self.selectedData = selectedData
            builder.onChanged.call(selectedData)
        }
    }
}

extension GraphRangeSlider {
    @MainActor
    private final class GraphRangeSliderBuilder: GraphRangeSliderDelegate {
        let onChanged = Delegate<Data, Void>()
        let onEnded = Delegate<Data, Void>()
    }

    public func onChanged(_ action: @escaping (Data) -> Void) -> Self {
        builder.onChanged.set(action)
        return self
    }

    public func onEnded(_ action: @escaping (Data) -> Void) -> Self {
        builder.onEnded.set(action)
        return self
    }
}

extension GraphRangeSlider {
    /// Creates a graphRangeSlider composed of a series of marks.
    ///
    /// - Parameters:
    ///   - data: A collection of data.
    ///   - id: KeyPath to identifiable property
    ///   - selectedData: A collection of data within selection.
    public init(_ data: Data, id: KeyPath<Data.Element, ID>, selectedData: Binding<Data>) {
        self.data = data
        self.id = id
        _selectedData = selectedData
    }
}

extension GraphRangeSlider where ID == Data.Element.ID, Data.Element: Identifiable {
    /// Creates an instance that uniquely identifies views across updates based
    /// on the identity of the underlying data element.
    ///
    /// - Parameters:
    ///   - data: A collection of identified data.
    ///   - selectedData: A collection of data within selection.
    public init(_ data: Data, selectedData: Binding<Data>) where ID: Identifiable {
        self.data = data
        self.id = \Data.Element.id
        _selectedData = selectedData
    }
}
