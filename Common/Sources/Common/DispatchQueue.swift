import Foundation

public extension DispatchQueue {
    static let bg = DispatchQueue(label: "background_serial_" + UUID().uuidString )
}
