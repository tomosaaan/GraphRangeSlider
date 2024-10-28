import Foundation

final class Delegate<Input, Output> {
    init() {}
    private var action: ((Input) -> Output)?

    func set(_ action: @escaping (Input) -> Output) {
        self.action = action
    }

    func call(_ input: Input) {
        action?(input)
    }
}
