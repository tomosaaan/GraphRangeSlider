import Charts

extension PlottableValue {
    static func value<S>(_ label: S, _ value: Value) -> PlottableValue<Value> where S : RawRepresentable, S.RawValue == String {
        .value(label.rawValue, value)
    }
}
