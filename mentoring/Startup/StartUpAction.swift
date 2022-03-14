//
//  StartUpAction.swift
//  mentoring
//
//  Created by Nicolò Pasini on 08/03/22.
//

enum StartupActionStatus {
    case failure, success
}

enum StartupAction: Equatable {
    case idle
    case login
    case logout
    case checkToS
    case fetchAccount
    case systemSettings
    case invitationFlow
    case bioAuthPermissions
    case checkAuthentication
    case checkInvitationFlow
    case checkInactivityState
    case showToS(animated: Bool)
    case showLogin(animated: Bool)
    case showSplash(animated: Bool)
    case showLoading(animated: Bool)
    case showAdvisor(animated: Bool)
}
