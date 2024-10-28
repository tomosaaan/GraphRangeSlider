import SwiftUI

struct SliderToggle: View {
    private enum Position {
        case left, right
    }

    let togglePositions: ContiguousArray<CGFloat>
    let limitIndex: Int
    @Binding var isDragging: Bool
    @Binding var currentIndex: Int
    @Environment(\.activeColor) private var activeColor: Color
    @Environment(\.toggleRadius) private var toggleRadius: CGFloat

    private var position: Position {
        limitIndex < currentIndex ? .right: .left
    }

    private var currentOffsetX: CGFloat {
        switch position {
        case .left: togglePositions[currentIndex] - toggleRadius
        case .right: togglePositions[currentIndex] - toggleRadius * 5
        }
    }

    var body: some View {
        Circle()
            .fill(activeColor)
            .frame(width: toggleRadius * 2, height: toggleRadius * 2)
            .offset(x: currentOffsetX)
            .padding(.horizontal, toggleRadius)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        switch position {
                        case .left:
                            let locationX = value.location.x - toggleRadius
                            if let index = togglePositions.map { abs($0 - locationX) }.argmin() {
                                currentIndex = min(index, limitIndex - 1)
                            }
                        case .right:
                            let locationX = value.location.x + toggleRadius * 3
                            if let index = togglePositions.map { abs($0 - locationX) }.argmin() {
                                currentIndex = max(index, limitIndex + 1)
                            }
                        }
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
    }
}
