//
//  SystemSettingsRepository.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import Resolver
import Foundation

protocol SystemSettingsRepository {
    var service: SystemSettingsService { get }
    var persister: SystemSettingsPersister { get }
}

class AppSystemSettingsRepository: SystemSettingsRepository {
    
    let service: SystemSettingsService
    let persister: SystemSettingsPersister

    init(service: SystemSettingsService, persister: SystemSettingsPersister) {
        self.service = service
        self.persister = persister
    }
}

extension SystemSettingsRepository {
    func getSystemSettings(_ completion: @escaping (SystemSettingsService.Result) -> Void) {
        if let settings = persister.getSystemSettings() {
            completion(.success(settings))
        } else {
            refreshSytemSettings(completion)
        }
    }

    func refreshSytemSettings(_ completion: @escaping (SystemSettingsService.Result) -> Void) {
        service.fetchSystemSettings { result in
            switch result {
            case .success(let settings):
                persister.setSystemSettings(systemSettings: settings)
            case .failure:
                persister.setSystemSettings(systemSettings: nil)
            }

            if let settings = persister.getSystemSettings() {
                completion(.success(settings))
            } else {
                completion(.failure(GenericError.generic))
            }
        }
    }

    func cleanPersistedSystemSettings() {
        persister.setSystemSettings(systemSettings: nil)
    }
}

extension Resolver {
    static func registerSystemSettingsRepository() {
        register(SystemSettingsRepository.self) { AppSystemSettingsRepository(service: resolve(), persister: resolve()) }
    }
}
