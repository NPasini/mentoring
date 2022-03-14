//
//  BiometricAuthProvider.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import UIKit
import Resolver

typealias BiometricAuthenticationPermissionCompletion = (Bool) -> Void

protocol BiometricAuthProvider {
    var biometricPermissionRequested: Bool { get set }

    func askForPermission(from vc: UIViewController, completion: BiometricAuthenticationPermissionCompletion?)
}

class AppBiometricAuthProvider: BiometricAuthProvider {

    private let persister: BiometricPersister

    init(persister: BiometricPersister) {
        self.persister = persister
    }

    var biometricPermissionRequested: Bool {
        get {
            persister.getBiometricPermissionRequested()
        }
        set {
            persister.setBiometricPermissionRequested(permissionRequested: newValue)
        }
    }

    // MARK: - Utility Methods

    func askForPermission(from vc: UIViewController, completion: BiometricAuthenticationPermissionCompletion?) {
        completion?(true)
    }
}

extension Resolver {
    static func registerBiometricAuthProvider() {
        register(BiometricAuthProvider.self) { AppBiometricAuthProvider(persister: resolve()) }
    }
}
