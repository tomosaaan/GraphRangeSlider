import Charts

public protocol GraphRangeElement: Hashable {
    associatedtype X: Plottable
    associatedtype Y: Plottable
    var x: X { get }
    var y: Y { get }
}
