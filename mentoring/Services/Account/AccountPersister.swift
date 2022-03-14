//
//  AccountPersister.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import Resolver
import Foundation

protocol AccountPersister {
    func getAccount() -> String?
    func setAccount(account: String?)
}

class AppAccountPersister: AccountPersister {

    private let accountKey: String = "account"
    private let localRepository: LocalRepository

    // MARK: - Life-cycle

    init(repository: LocalRepository) {
        self.localRepository = repository
    }

    // MARK: - Account Persister

    func getAccount() -> String? {
        if let data = localRepository.retrieveValue(forKey: accountKey) as? Data {
            return try? JSONDecoder().decode(String.self, from: data)
        }

        return nil
    }

    func setAccount(account: String?) {
        guard let account = account else {
            deleteAccount()
            return
        }

        if let encoded = try? JSONEncoder().encode(account) {
            localRepository.persist(data: encoded, forKey: accountKey)
        }
    }

    private func deleteAccount() {
        localRepository.removeValue(forKey: accountKey)
    }
}


extension Resolver {
    static func registerAccountPersister() {
        register(AccountPersister.self) { AppAccountPersister(repository: resolve(LocalRepository.self)) }
    }
}
