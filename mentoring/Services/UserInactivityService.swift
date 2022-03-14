//
//  UserInactivityService.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import Resolver
import Foundation

protocol UserInactivityService {
    var inactivityTimeHasExceedMaxValue: Bool { get }

    func stopInactivityTime()
    func startInactivityTime()
}

class UserInactivityTracker: UserInactivityService {

    private let maxInactivityTime: TimeInterval
    private let localRepository: LocalRepository
    private let repositoryKey: String = "inactivityTime"

    private(set) var inactivityTime = TimeInterval(0)

    var inactivityTimeHasExceedMaxValue: Bool {
        inactivityTime > maxInactivityTime
    }

    init(maxInactivityTime: TimeInterval, repository: LocalRepository) {
        self.maxInactivityTime = maxInactivityTime
        self.localRepository = repository
    }

    // MARK: - Public Methods

    func stopInactivityTime() {
        updateInactivityTime()
        localRepository.removeValue(forKey: repositoryKey)
    }

    func startInactivityTime() {
        resetInactivityTime()
        localRepository.persist(data: Date().timeIntervalSince1970, forKey: repositoryKey)
    }

    // MARK: - Private Methods

    private func updateInactivityTime() {
        guard let inactivityStartingTime = localRepository.retrieveValue(forKey: repositoryKey) as? Double, inactivityStartingTime > 0 else {
            inactivityTime = TimeInterval(0)
            return
        }
        inactivityTime = Date().timeIntervalSince1970 - TimeInterval(inactivityStartingTime)
    }

    private func resetInactivityTime() {
        inactivityTime = TimeInterval(0)
    }
}

extension Resolver {
    static func registerUserInactivityService() {
        register(name: .maxInactivityTime) { TimeInterval(14400) }
        register(UserInactivityService.self) {
            UserInactivityTracker(
                maxInactivityTime: resolve(name: .maxInactivityTime),
                repository: resolve(LocalRepository.self)
            )
        }.scope(.application)
    }
}

extension Resolver.Name {
    static let maxInactivityTime = Self("maxInactivityTime")
}
