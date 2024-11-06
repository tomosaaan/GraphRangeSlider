import Foundation

@MainActor
protocol GraphRangeSliderDelegate {
    associatedtype Data

    var onChanged: Delegate<Data, Void> { get }
    var onEnded: Delegate<Data, Void> { get }
}
