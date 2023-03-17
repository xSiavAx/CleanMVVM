import Foundation

public protocol KeyValueDataManager {
    func value(for key: String) throws -> Any?
    func set(value: Any?, for key: String) throws
    @discardableResult
    func synchronize() throws -> Bool
}

extension UserDefaults: KeyValueDataManager {
    public func value(for key: String) throws -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    public func set(value: Any?, for key: String) throws {
        UserDefaults.standard.set(value, forKey: key)
    }
}
