//
//  AccountService.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import Resolver
import Foundation

protocol AccountService {
    typealias FetchAccountResult = Result<String, Error>

    func fetchAccount(_ completion: @escaping (FetchAccountResult) -> Void)
}

public final class AppAccountService: AccountService {
    func fetchAccount(_ completion: @escaping (AccountService.FetchAccountResult) -> Void) {
        DispatchQueue(label: "servie", qos: .default).asyncAfter(deadline: .now() + .milliseconds(400)) {
            completion(.success("Account"))
        }
    }
}

extension Resolver {
    static func registerAccountService() {
        register(AccountService.self) { AppAccountService() }
    }
}
