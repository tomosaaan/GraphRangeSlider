import SwiftUI

struct SliderToggle: View {
    private enum Position {
        case left, right
    }

    let togglePositions: [CGFloat]
    let limitIndex: Int
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
                        let nextIndex = min(currentIndex + 1, togglePositions.endIndex - 1)
                        let previousIndex = max(currentIndex - 1, 0)

                        switch position {
                        case .left:
                            let locationX = value.location.x - toggleRadius
                            if togglePositions[nextIndex] < locationX {
                                currentIndex = min(nextIndex, limitIndex - 1)
                            } else if locationX < togglePositions[previousIndex] {
                                currentIndex = previousIndex
                            }
                        case .right:
                            let locationX = value.location.x + toggleRadius * 3
                            if togglePositions[nextIndex] < locationX {
                                currentIndex = nextIndex
                            } else if locationX < togglePositions[previousIndex] {
                                currentIndex = max(previousIndex, limitIndex + 1)
                            }
                        }
                    }
            )
    }
}
