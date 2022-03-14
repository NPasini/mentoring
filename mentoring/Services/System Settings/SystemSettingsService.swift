//
//  SystemSettingsService.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import Resolver
import Foundation

protocol SystemSettingsService {
    typealias Result = Swift.Result<String, Error>

    func fetchSystemSettings(_ completion: @escaping (Result) -> Void)
}

class AppSystemSettingsService: SystemSettingsService {
    func fetchSystemSettings(_ completion: @escaping (SystemSettingsService.Result) -> Void) {
        DispatchQueue(label: "settings", qos: .default).asyncAfter(deadline: .now() + .milliseconds(400)) {
            completion(.success("Settings"))
        }
    }
}

extension Resolver {
    static func registerSystemSettingsService() {
        register(SystemSettingsService.self) { AppSystemSettingsService() }
    }
}
