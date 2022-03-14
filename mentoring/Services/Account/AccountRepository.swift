//
//  AccountRepository.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import Resolver
import Foundation

protocol AccountRepository {
    var service: AccountService { get }
    var persister: AccountPersister { get }
}

extension AccountRepository {

    func getAccount(_ completion: @escaping (AccountService.FetchAccountResult) -> Void) {
        if let account = persister.getAccount() {
            completion(.success(account))
        } else {
            refreshAccount(completion)
        }
    }

    func refreshAccount(_ completion: @escaping (AccountService.FetchAccountResult) -> Void) {
        service.fetchAccount { result in
            switch result {
            case .success(let account):
                persister.setAccount(account: account)
            case .failure:
                persister.setAccount(account: nil)
            }

            if let account = persister.getAccount() {
                completion(.success(account))
            } else {
                completion(.failure(GenericError.generic))
            }
        }
    }

    func cleanPersistedAccount() {
        persister.setAccount(account: nil)
    }
}

class AppAccountRepository: AccountRepository {

    let service: AccountService
    let persister: AccountPersister

    init(service: AccountService, persister: AccountPersister) {
        self.service = service
        self.persister = persister
    }
}

extension Resolver {
    static func registerAccountRepository() {
        register(AccountRepository.self) { AppAccountRepository(service: resolve(), persister: resolve()) }
    }
}
