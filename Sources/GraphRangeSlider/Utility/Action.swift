import Foundation

final class Action<Input, Output> {
    init() {}
    private var action: ((Input) -> Output)?

    func set(_ action: @escaping (Input) -> Output) {
        self.action = action
    }

    func call(_ input: Input) -> Output? {
        action?(input)
    }
}
