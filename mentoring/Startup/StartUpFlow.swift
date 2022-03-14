//
//  StartUpFlow.swift
//  mentoring
//
//  Created by Nicolò Pasini on 08/03/22.
//

import RxSwift
import Foundation

struct StartupFlow {

    let actionToPerform: PublishSubject<StartupAction>

    @TrackChange<AppState>(value: .launched) private var appActivityState: AppState
    @TrackChange<StartupAction>(value: .idle) private var action: StartupAction {
        didSet {
            actionToPerform.onNext(action)
        }
    }

    init(action: StartupAction = .idle) {
        self.actionToPerform = PublishSubject<StartupAction>()
        self.action = action
        self.appActivityState = .launched
    }

    mutating func resumeFlow() {
        switch appActivityState {
        case .launched:
            action = .showSplash(animated: true)
            appActivityState = .active
        case .inactive:
            action = .checkInvitationFlow
            appActivityState = .active
        case .active: ()
        }
    }

    mutating func enterBackground() {
        action = .idle
        appActivityState = .inactive
    }

    mutating func logOutAndRestart() {
        action = .logout
    }

    mutating func completeCurrentAction(with result: StartupActionStatus) {
        switch result {
        case .success:
            onSuccess()
        case .failure:
            onFailure()
        }
    }

    // MARK: - Private Methods

    private mutating func onSuccess() {
        switch action {
        case .showSplash:
            action = .checkInvitationFlow
        case .login:
            action = .showLoading(animated: _appActivityState.previousValue != .inactive)
        case .logout:
            action = .showLogin(animated: shouldAnimateLogout())
        case .checkInvitationFlow:
            action = .logout
        case .invitationFlow:
            action = .login
        case .checkInactivityState:
            action = .checkAuthentication
        case .checkAuthentication:
            actionAfterSuccessfulAuthCheck()
        case .bioAuthPermissions:
            action = .systemSettings
        case .systemSettings:
            action = .fetchAccount
        case .fetchAccount:
            action = .checkToS
        case .checkToS:
            action = .showToS(animated: _appActivityState.previousValue != .inactive)
        case .showToS:
            action = .showAdvisor(animated: _appActivityState.previousValue != .inactive)
        case .showLogin:
            action = .invitationFlow
        case .showLoading:
            actionAfterSuccessfulLoading()
        default: ()
        }
    }

    private mutating func onFailure() {
        switch action {
        case .checkInvitationFlow:
            action = .checkInactivityState
        case .invitationFlow:
            action = .login
        case .checkInactivityState:
            action = .logout
        case .checkAuthentication:
            action = .showLogin(animated: _appActivityState.previousValue != .inactive)
        case .bioAuthPermissions:
            action = .systemSettings
        case .systemSettings:
            action = .logout
        case .fetchAccount:
            action = .logout
        default: ()
        }
    }

    private mutating func actionAfterSuccessfulLoading() {
        if case .checkAuthentication = _action.previousValue {
            action = .systemSettings
        } else if case .login = _action.previousValue {
            action = .bioAuthPermissions
        }
    }

    private mutating func actionAfterSuccessfulAuthCheck() {
        if _appActivityState.previousValue == .launched {
            action = .showLoading(animated: true)
        } else {
            action = .checkToS
        }
    }

    private func shouldAnimateLogout() -> Bool {
        _appActivityState.previousValue != .inactive || _action.previousValue == .checkInvitationFlow
    }
}
