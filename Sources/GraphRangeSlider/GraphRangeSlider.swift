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
    @State private var width = CGFloat.zero
    @Environment(\.activeColor) private var activeColor: Color
    @Environment(\.inactiveColor) private var inactiveColor: Color
    @Environment(\.toggleRadius) private var toggleRadius: CGFloat
    @Environment(\.sliderBarHeight) private var sliderBarHeight: CGFloat
    @Environment(\.margin) private var margin: CGFloat
    @Environment(\.isHiddenChart) private var isHiddenChart: Bool

    public var body: some View {
        ZStack(alignment: .bottom) {
            if !isHiddenChart {
                Chart(data, id: id) { data in
                    BarMark(
                        x: .value(PlottableKeys.x, String(describing: data.x)),
                        y: .value(PlottableKeys.y, data.y),
                        width: builder.barDimension.call(data)?.width ?? .automatic,
                        height: builder.barDimension.call(data)?.height ?? .automatic
                    )
                    .foregroundStyle(
                        by: .value(
                            PlottableKeys.status,
                            selectedData.contains(data) ? Status.active: Status.inactive
                        )
                    )
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartLegend(.hidden)
                .chartForegroundStyleScale([
                    Status.active: activeColor,
                    Status.inactive: inactiveColor
                ])
                .padding(.horizontal, toggleRadius * 2)
                .padding(.bottom, margin + toggleRadius + sliderBarHeight / 2)
            }

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
        .background(
            Color.clear.viewSize { width = $0.width }
        )
        .onChange(of: leftCurrentIndex) { _ in
            onChangedSelectedData()
        }
        .onChange(of: rightCurrentIndex) { _ in
            onChangedSelectedData()
        }
        .task(id: Array(selectedData)) {
            updateIndices()
        }
        .task(id: Array(data)) {
            updatePositions()
            updateIndices()
        }
        .task(id: width) {
            updatePositions()
            updateIndices()
        }
    }

    private func onChangedSelectedData() {
        let startIndex = min(leftCurrentIndex, data.endIndex)
        let endIndex = min(rightCurrentIndex, data.endIndex)
        if let selectedData = Array(data[startIndex ..< endIndex]) as? Data {
            self.selectedData = selectedData
            builder.onChanged.call(selectedData)
        }
    }

    private func updateIndices() {
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

    private func updatePositions() {
        let width = width - toggleRadius * 4
        let barMarkWidth = width / CGFloat(data.count)

        positions = .init(
            stride(from: toggleRadius,
                   through: barMarkWidth * CGFloat(data.count) + toggleRadius,
                   by: barMarkWidth)
        )
        positions[0] = 0
        positions[positions.count - 1] += toggleRadius
    }
}

extension GraphRangeSlider {
    public struct BarDimension {
        let width: MarkDimension
        let height: MarkDimension

        public init(width: MarkDimension = .automatic, height: MarkDimension = .automatic) {
            self.width = width
            self.height = height
        }
    }

    @MainActor
    private final class GraphRangeSliderBuilder {
        let onChanged = Action<Data, Void>()
        let onEnded = Action<Data, Void>()
        let barDimension = Action<Data.Element, BarDimension>()
    }

    public func onChanged(_ action: @escaping (Data) -> Void) -> Self {
        builder.onChanged.set(action)
        return self
    }

    public func onEnded(_ action: @escaping (Data) -> Void) -> Self {
        builder.onEnded.set(action)
        return self
    }

    public func barDimension(_ action: @escaping (Data.Element) -> BarDimension) -> Self {
        builder.barDimension.set(action)
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
