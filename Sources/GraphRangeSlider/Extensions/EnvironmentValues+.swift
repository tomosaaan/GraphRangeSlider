import SwiftUI
import Charts

extension EnvironmentValues {
    struct BarDimension {
        let width: MarkDimension
        let height: MarkDimension
    }
    @Entry var activeColor = Color.black
    @Entry var inactiveColor = Color.gray
    @Entry var graphDimension = BarDimension(width: .automatic, height: .automatic)
    @Entry var toggleRadius: CGFloat = 8
    @Entry var sliderBarHeight: CGFloat = 8
    @Entry var margin: CGFloat = 0
}
