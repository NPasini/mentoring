//
//  StartUpFlowController.swift
//  mentoring
//
//  Created by Nicolò Pasini on 08/03/22.
//

import UIKit
import RxSwift
import Resolver

/// Class used as a router for the App stratup flow.
class StartupFlowController: StartupFlowService {

    // MARK: - Injected Properties

    @Injected private var userDefaultsRepository: LocalRepository
    @Injected private var inactivityService: UserInactivityService
    @Injected private var navProvider: NavigationControllerProvider
    @Injected private var authenticationProvider: AuthenticationStateProvider

    @LazyInjected private var loginService: LoginService
    @LazyInjected private var accountRepository: AccountRepository
    @LazyInjected private var navigationService: NavigationService
    @LazyInjected private var bioAuthProvider: BiometricAuthProvider
    @LazyInjected private var tosOnboardingPresenter: OnboardingPresenter
    @LazyInjected private var systemSettingsRepository: SystemSettingsRepository

    // MARK: - Properties

    private let disposeBag: DisposeBag
    private var startupFlow: StartupFlow
    private let invitationLink: String = "invitation"

    // MARK: - Lifecycle Methods

    init() {
        disposeBag = DisposeBag()
        startupFlow = StartupFlow()

        subscribeToObservables()
    }

    /// Subscribes to all the properties to be observed (among the available dependencies).
    private func subscribeToObservables() {
        let scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
        startupFlow.actionToPerform.observe(on: scheduler).subscribe(on: scheduler).subscribe { [weak self] (actionToPerform: StartupAction) in
            self?.performNext(action: actionToPerform)
        }.disposed(by: disposeBag)
    }

    private func performNext(action: StartupAction) {
        switch action {
        case .idle: ()
        case .logout:
            self.logOutUser()
        case .checkToS:
            self.checkToS()
        case .fetchAccount:
            self.fetchAccount()
        case .systemSettings:
            self.fetchSystemSettings()
        case .bioAuthPermissions:
            self.askForBioAuthenticationPermissions()
        case .checkInvitationFlow:
            self.checkInvitationFlow()
        case .checkAuthentication:
            self.checkAuthentication()
        case .checkInactivityState:
            self.checkInactivityTime()
        case .showToS(animated: let animated):
            self.showOnboarding(animated: animated)
        case .showLogin(animated: let animated):
            changePage(to: .login, animated: animated)
        case .showAdvisor(animated: let animated):
            changePage(to: .advisor, animated: animated)
        case .showLoading(animated: let animated):
            changePage(to: .loadingDots, animated: animated)
        case .showSplash(animated: let animated):
            changePage(to: .splashScreen, animated: animated)
        case .invitationFlow:
            showInvitationFlow()
        default: ()
        }
    }

    // MARK: - Public Methods

    /// Performs actions needed before the app goes to background.
    func pauseFlowAppDidEnterBackground() {
        startupFlow.enterBackground()
        inactivityService.startInactivityTime()
    }

    func resumeFlow() {
        startupFlow.resumeFlow()
    }

    /// Restarts the flow from where it has been paused.
    ///
    /// - Parameter status: The result of the last performed action.
    func moveToNextActionWith(_ status: StartupActionStatus) {
        startupFlow.completeCurrentAction(with: status)
    }

    /// Resumes the flow logging out the user and presenting the login screen.
    func logOutAndShowLogin() {
        guard authenticationProvider.isUserLoggedIn else { return }
        startupFlow.logOutAndRestart()
    }

    // MARK: - Presentation Methods

    /// Logs the user out.
    private func logOutUser() {
        loginService.logoutUser { result in
            switch result {
            case .success:
                self.startupFlow.completeCurrentAction(with: .success)
            case .failure:
                self.startupFlow.completeCurrentAction(with: .failure)
            }
        }
    }

    private func changePage(to page: Page, animated: Bool) {
        stopLoadingIfNeeded { [weak self] in
            self?.pushPage(page, animated: animated)
        }
    }

    private func stopLoadingIfNeeded(completion: @escaping () -> Void) {
        Thread.guaranteeMainThread {
            if let currentVC = self.navProvider.getTopViewController() as? LoadingDotsViewController {
                currentVC.stopAnimation {
                    completion()
                }
            } else {
                completion()
            }
        }
    }

    private func pushPage(_ page: Page, animated: Bool) {
        Thread.guaranteeMainThread {
            if let topVC = self.navProvider.getTopViewController(), String(describing: type(of: topVC)) == page.identifier {
                self.startupFlow.completeCurrentAction(with: .success)
                return
            }

            let navController = self.navProvider.getRootNavigationController()
            self.navigationService.resetViewControllersStack(to: page, on: navController, animated: animated)
        }
    }

    private func showOnboarding(animated: Bool) {
        Thread.guaranteeMainThread {
            let navController = self.navProvider.getRootNavigationController()
            self.tosOnboardingPresenter.showOnboarding(from: navController, animated: animated)
        }
    }

    private func showInvitationFlow() {
        Thread.guaranteeMainThread {
            guard let topVC = self.navProvider.getTopViewController() as? InvitationFlowPresenter else { return }
            topVC.showInvitationFlowIfNeeded()
        }
    }

    // MARK: - Preliminary Checks Methods

    /// Checks if the app became active to start an invitation flow.
    private func checkInvitationFlow() {
        if userDefaultsRepository.retrieveValue(forKey: invitationLink) != nil {
            startupFlow.completeCurrentAction(with: .success)
        } else {
            startupFlow.completeCurrentAction(with: .failure)
        }
    }

    /// Checks if the user has been inactive for too long.
    private func checkInactivityTime() {
        inactivityService.stopInactivityTime()

        if inactivityService.inactivityTimeHasExceedMaxValue {
            startupFlow.completeCurrentAction(with: .failure)
        } else {
            startupFlow.completeCurrentAction(with: .success)
        }
    }

    /// Checks if the user is logged.
    private func checkAuthentication() {
        if authenticationProvider.isUserLoggedIn {
            startupFlow.completeCurrentAction(with: .success)
        } else {
            startupFlow.completeCurrentAction(with: .failure)
        }
    }

    /// Asks permissions to the user to use the biometric authentication.
    private func askForBioAuthenticationPermissions() {
        Thread.guaranteeMainThread {
            guard let currentVC = self.navProvider.getTopViewController() else { return }

            if self.bioAuthProvider.biometricPermissionRequested {
                self.bioAuthProvider.askForPermission(from: currentVC) { success in
                    if success {
                        self.startupFlow.completeCurrentAction(with: .success)
                    } else {
                        self.startupFlow.completeCurrentAction(with: .failure)
                    }
                }
            } else {
                self.startupFlow.completeCurrentAction(with: .failure)
            }
        }
    }

    /// Fetches the system settings.
    private func fetchSystemSettings() {
        systemSettingsRepository.refreshSytemSettings { [weak self] result in
            switch result {
            case .success:
                self?.startupFlow.completeCurrentAction(with: .success)
            case .failure:
                self?.startupFlow.completeCurrentAction(with: .failure)
            }
        }
    }

    /// Fetches the account for the current user.
    private func fetchAccount() {
        accountRepository.refreshAccount { [weak self] result in
            switch result {
            case .success:
                self?.startupFlow.completeCurrentAction(with: .success)
            case .failure:
                self?.startupFlow.completeCurrentAction(with: .failure)
            }
        }
    }

    /// Checks if the ToS have already been shown and accepted.
    private func checkToS() {
        accountRepository.getAccount { [weak self] result in
            switch result {
            case .success(let account):
                if !account.isEmpty {
                    self?.startupFlow.completeCurrentAction(with: .success)
                } else {
                    fallthrough
                }
            case .failure:
                self?.startupFlow.completeCurrentAction(with: .failure)
            }
        }
    }
}
