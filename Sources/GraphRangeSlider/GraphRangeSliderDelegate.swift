import Foundation

@MainActor
protocol GraphRangeSliderDelegate {
    associatedtype Data

    var onEnded: Delegate<Data, Void> { get }
}
