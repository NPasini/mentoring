//
//  AppDelegate+Injection.swift
//  mentoring
//
//  Created by Nicolò Pasini on 13/03/22.
//

import Resolver
import Foundation

extension Resolver: ResolverRegistering {

    public static func registerAllServices() {
        // App Services
        registerLoginService()
        registerNavigationService()
        registerStartupFlowService()
        registerTransitionDelegate()
        registerUserInactivityService()
        registerAuthenticationProvider()
        registerRootViewControllerProvider()

        // System Settings
        registerSystemSettingsService()
        registerSystemSettingsPersister()

        // Bio Auth
        registerBiometricAuthProvider()
        registerBiometricAuthPersister()

        // Account
        registerAccountService()
        registerAccountPersister()

        // Onboarding
        registerOnboardingPresenter()

        // Repositories
        registerLocalRepositories()
        registerAccountRepository()
        registerSystemSettingsRepository()
    }
}
