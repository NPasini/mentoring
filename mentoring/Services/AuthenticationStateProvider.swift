//
//  AuthenticationStateProvider.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import Resolver
import Foundation

protocol AuthenticationStateProvider {
    var authToken: String? { get }
    var authDomain: String? { get }
    var isUserLoggedIn: Bool { get }
}

extension Resolver {
    static func registerAuthenticationProvider() {
        register(AuthenticationStateProvider.self) { OAuthStateProvider() }
    }
}
 
class OAuthStateProvider: AuthenticationStateProvider {

    public var authDomain: String? {
        "domain"
    }

    public var authToken: String? {
        "token"
    }

    public var isUserLoggedIn: Bool {
        true
    }
}
