import Foundation

extension Array where Element: Comparable {
    func argmin() -> Index? {
        indices.min(by: { self[$0] < self[$1] })
    }
}
