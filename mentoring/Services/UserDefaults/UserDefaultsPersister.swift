//
//  UserDefaultsPersister.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import Foundation

public class UserDefaultsPersister: Persister {

    // MARK: - Private Properties

    private(set) var userDefaults: UserDefaults?

    public var allKeys: [String] {
        if let keys = userDefaults?.dictionaryRepresentation().keys {
            return Array(keys)
        } else {
            return []
        }
    }

    // MARK: - Lifecycle Methods

    init() {
        self.userDefaults = UserDefaults.standard
    }

    // MARK: - CRPersister Methods

    public func set(_ value: Any?, forKey key: String) {
        guard let updatedValue = value else {
            removeValue(forKey: key)
            return
        }

        if valueNeedsToBePersistedAsData(updatedValue) {
            let valueData = NSKeyedArchiver.archivedData(withRootObject: updatedValue)
            userDefaults?.set(valueData, forKey: key)
        } else {
            userDefaults?.set(updatedValue, forKey: key)
        }
    }

    public func get(forKey key: String) -> Any? {
        if let dataValue = userDefaults?.data(forKey: key), let unarchivedValue = NSKeyedUnarchiver.unarchiveObject(with: dataValue) {
            return unarchivedValue
        } else {
            return userDefaults?.value(forKey: key)
        }
    }

    public func removeValue(forKey key: String) {
        userDefaults?.removeObject(forKey: key)
    }

    public func reset() {
        userDefaults?.dictionaryRepresentation().keys.forEach { key in
            set(nil, forKey: key)
        }
    }

    // MARK: - Private Methods

    private func valueNeedsToBePersistedAsData(_ value: Any) -> Bool {
        !(value is String) && !(value is Array<Any>) && !(value is Dictionary<AnyHashable,Any>) && !(value is NSNumber) && !(value is NSData) && !(value is NSDate)
    }
}
