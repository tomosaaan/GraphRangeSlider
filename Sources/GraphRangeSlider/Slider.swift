import SwiftUI

struct Slider: View {
    let positions: [CGFloat]
    @Binding var leftCurrentIndex: Int
    @Binding var rightCurrentIndex: Int
    @State private var viewSize = CGSize.zero
    @State private var width = CGFloat.zero
    @Environment(\.activeColor) private var activeColor: Color
    @Environment(\.inactiveColor) private var inactiveColor: Color
    @Environment(\.toggleRadius) private var toggleRadius: CGFloat
    @Environment(\.sliderBarHeight) private var sliderBarHeight: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: sliderBarHeight / 2, style: .continuous)
                    .foregroundStyle(inactiveColor)
                    .frame(
                        width: geometry.size.width - toggleRadius * 2,
                        height: sliderBarHeight
                    )
                    .offset(x: toggleRadius)

                Rectangle()
                    .foregroundStyle(activeColor)
                    .frame(
                        width: positions[rightCurrentIndex] - positions[leftCurrentIndex],
                        height: sliderBarHeight
                    )
                    .offset(x: positions[leftCurrentIndex] + toggleRadius)

                HStack(spacing: 0) {
                    SliderToggle(
                        togglePositions: positions,
                        limitIndex: rightCurrentIndex,
                        currentIndex: $leftCurrentIndex
                    )
                    SliderToggle(
                        togglePositions: positions,
                        limitIndex: leftCurrentIndex,
                        currentIndex: $rightCurrentIndex
                    )
                }
            }
        }
    }
}
