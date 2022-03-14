//
//  StartupFlowService.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import Resolver
import Foundation

protocol StartupFlowService {
    func resumeFlow()
    func logOutAndShowLogin()
    func pauseFlowAppDidEnterBackground()
    func moveToNextActionWith(_ status: StartupActionStatus)
}

extension Resolver {
    static func registerStartupFlowService() {
        register(StartupFlowService.self) { StartupFlowController() }.scope(.application)
    }
}
