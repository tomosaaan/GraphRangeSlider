import SwiftUI

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
    /// - Parameter barWidthRatio: Ratio of the bar to the range that can be drawn, defaults to `0.8`
    /// - Note: This setting value is equivalent to the `MarkDimension.ratio` on Swift Charts.
    public func graph(barWidthRatio: CGFloat) -> some View {
        environment(\.graphBarWidth, max(min(barWidthRatio, 1), 0))
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
}
