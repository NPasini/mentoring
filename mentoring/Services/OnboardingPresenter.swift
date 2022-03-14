//
//  OnboardingPresenter.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import UIKit
import Resolver

protocol OnboardingPresenter {
    func showOnboarding(from navigationController: UINavigationController, animated: Bool)
}

class ToSOnboardingPresenter: OnboardingPresenter {

    private let flowController: StartupFlowService
    private let accountRepository: AccountRepository

    init(accountRepository: AccountRepository, flowController: StartupFlowService) {
        self.flowController = flowController
        self.accountRepository = accountRepository
    }

    func showOnboarding(from navigationController: UINavigationController, animated: Bool) {
        // Create onboarding view controller and show it
        // Pass StartupFlowService instance to showed viewcontroller
        // Showed viewcontroller will tell to StartupFlowService instance when to move to next action after onboarding is completed calling flowController.moveToNextActionWith(.success)
        
        // Here, for simplicity we just move to next action
        flowController.moveToNextActionWith(.success)
    }
}

extension Resolver {
    static func registerOnboardingPresenter() {
        register(OnboardingPresenter.self) { ToSOnboardingPresenter(accountRepository: resolve(), flowController: resolve()) }
    }
}
