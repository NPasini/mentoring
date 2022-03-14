//
//  LocalRepository.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import Resolver
import Foundation

protocol LocalRepository {
    var localStorage: Persister { get }
    var persisterSerialQueue: DispatchQueue { get }
}

extension LocalRepository {

    func deleteAllStoredValues() {
        persisterSerialQueue.sync {
            localStorage.reset()
        }
    }

    func removeValue(forKey key: String) {
        persisterSerialQueue.sync {
            localStorage.removeValue(forKey: key)
        }
    }

    func persist<Value>(data: Value, forKey key: String) {
        persisterSerialQueue.sync {
            localStorage.set(data, forKey: key)
        }
    }

    func retrieveValue(forKey key: String) -> Any? {
        persisterSerialQueue.sync {
            localStorage.get(forKey: key)
        }
    }
}

class UserDefaultsRepository: LocalRepository {
    
    let localStorage: Persister
    let persisterSerialQueue: DispatchQueue

    init() {
        localStorage = UserDefaultsPersister()
        persisterSerialQueue = DispatchQueue(label: "localPersister", qos: .default)
    }
}

extension Resolver {
    static func registerLocalRepositories() {
        register(LocalRepository.self) { UserDefaultsRepository() }
    }
}
