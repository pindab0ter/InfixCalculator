import Foundation

extension Double {
    var display: String {
        get {
            return String(format: "%.12g", self)
        }
    }
}
