//
//  BiometricPersister.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import Resolver
import Foundation

protocol BiometricPersister {
    func getBiometricPermissionRequested() -> Bool
    func setBiometricPermissionRequested(permissionRequested: Bool)
}

class AppBiometricPersister: BiometricPersister {

    private let localRepository: LocalRepository
    private let biometricsKey: String = "biometrics_permission"
    
    init(repository: LocalRepository) {
        self.localRepository = repository
    }

    func getBiometricPermissionRequested() -> Bool {
        localRepository.retrieveValue(forKey: biometricsKey) as? Bool ?? false
    }

    func setBiometricPermissionRequested(permissionRequested: Bool) {
        localRepository.persist(data: permissionRequested, forKey: biometricsKey)
    }
}

extension Resolver {
    static func registerBiometricAuthPersister() {
        register(BiometricPersister.self) { AppBiometricPersister(repository: resolve(LocalRepository.self)) }
    }
}
