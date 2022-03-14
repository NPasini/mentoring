//
//  LoginService.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import Resolver
import Foundation

public typealias AuthenticationProviderLogoutCompletion = (Result<Bool, Error>) -> Void

protocol LoginService {
    func logoutUser(completion: @escaping AuthenticationProviderLogoutCompletion)
}

class OAuthLoginService: LoginService {

    // MARK: - LoginService Methods

    func logoutUser(completion: @escaping AuthenticationProviderLogoutCompletion) {
        // Logging out user
        completion(.success(true))
    }
}

extension Resolver {
    static func registerLoginService() {
        register(LoginService.self) { OAuthLoginService() }
    }
}
