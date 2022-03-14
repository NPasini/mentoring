//
//  Persister.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import Foundation

protocol Persister {

    var allKeys: [String] { get }

    func set(_ value: Any?, forKey key: String)

    func get(forKey key: String) -> Any?

    func removeValue(forKey key: String)

    func reset()
}

extension Persister {

    func setData(_ data: Data?, forKey key: String) {
        set(data, forKey: key)
    }

    func setString(_ string: String?, forKey key: String) {
        set(string, forKey: key)
    }
    
    func setBool(_ bool: Bool?, forKey key: String) {
        set(bool, forKey: key)
    }
    
    func setDict(_ dict: [String: Any]?, forKey key: String) {
        set(dict, forKey: key)
    }

    func setInt(_ int: Int?, forKey key: String) {
        set(int, forKey: key)
    }

    func setInt64(_ int: Int64?, forKey key: String) {
        set(int, forKey: key)
    }

    func setDouble(_ double: Double?, forKey key: String) {
        set(double, forKey: key)
    }

    func getData(forKey key: String) -> Data? {
        get(forKey: key) as? Data
    }

    func getString(forKey key: String) -> String? {
        get(forKey: key) as? String
    }

    func getBool(forKey key: String) -> Bool? {
        get(forKey: key) as? Bool
    }

    func getDict(forKey key: String) -> [String: Any]? {
        get(forKey: key) as? [String: Any]
    }

    func getInt(forKey key: String) -> Int? {
        get(forKey: key) as? Int
    }

    func getInt64(forKey key: String) -> Int64? {
        get(forKey: key) as? Int64
    }

    func getDouble(forKey key: String) -> Double? {
        get(forKey: key) as? Double
    }
}
