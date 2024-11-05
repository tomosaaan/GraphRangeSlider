import SwiftUI
import Charts

public extension View {
    /// Sets the selected color
    ///
    /// - Parameter color: the selected color. defaults to `Color.black`
    public func activeColor(_ color: Color) -> some View {
        environment(\.activeColor, color)
    }

    /// Sets the unselected color
    ///
    /// - Parameter color: the unselected color, defaults to `Color.gray`
    public func inactiveColor(_ color: Color) -> some View {
        environment(\.inactiveColor, color)
    }

    /// Sets the width of the bars in the graph as a percentage
    ///
    /// - Parameter width: Dimension representing a mark’s width, defaults to `.automatic`
    /// - Parameter height: Dimension representing a mark’s height, defaults to `.automatic`
    /// - Note: This setting value is equivalent to the `MarkDimension.ratio` on Swift Charts.
    public func graph(width: MarkDimension = .automatic, height: MarkDimension = .automatic) -> some View {
        environment(\.graphDimension, .init(width: width, height: height))
    }

    /// Sets the toggle radius
    ///
    /// - Parameter toggleRadius: radius of the toggle, defaults to `8`
    public func slider(toggleRadius: CGFloat) -> some View {
        environment(\.toggleRadius, toggleRadius)
    }

    /// Sets the slider bar height
    ///
    /// - Parameter barHeight: height of the slider bar, defaults to `8`
    public func slider(barHeight: CGFloat) -> some View {
        environment(\.sliderBarHeight, barHeight)
    }

    /// Sets the margin for graphs and slide bars
    ///
    /// - Parameter value: graph and slide bar margins, defaults to `0`
    public func margin(_ value: CGFloat) -> some View {
        environment(\.margin, max(value, 0))
    }

    /// Set the minimum number that can be selected
    ///
    /// - Parameter value: minimum number, defaults to `1`
    public func minCount(_ value: Int) -> some View {
        environment(\.minCount, max(value, 1))
    }
}
