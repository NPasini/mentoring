//
//  SystemSettingsPersister.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import Resolver
import Foundation

protocol SystemSettingsPersister {
    func getSystemSettings() -> String?
    func setSystemSettings(systemSettings: String?)
}

class AppSystemSettingsPersister: SystemSettingsPersister {

    private let localRepository: LocalRepository
    private let settingsKey: String = "settings"

    init(repository: LocalRepository) {
        self.localRepository = repository
    }

    func getSystemSettings() -> String? {
        if let data = localRepository.retrieveValue(forKey: settingsKey) as? Data {
            return try? JSONDecoder().decode(String.self, from: data)
        }

        return nil
    }

    func setSystemSettings(systemSettings: String?) {
        guard let systemSettings = systemSettings else {
            deleteSystemSettings()
            return
        }

        if let encoded = try? JSONEncoder().encode(systemSettings) {
            localRepository.persist(data: encoded, forKey: settingsKey)
        }
    }

    private func deleteSystemSettings() {
        localRepository.removeValue(forKey: settingsKey)
    }
}

extension Resolver {
    static func registerSystemSettingsPersister() {
        register(SystemSettingsPersister.self) { AppSystemSettingsPersister(repository: resolve(LocalRepository.self)) }
    }
}
