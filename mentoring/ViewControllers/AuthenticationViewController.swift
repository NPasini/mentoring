//
//  AuthenticationViewController.swift
//  mentoring
//
//  Created by Nicolò Pasini on 13/03/22.
//

import UIKit
import Resolver

class AuthenticationViewController: UIViewController {

    // MARK: - Injected Properties

    @LazyInjected private(set) var flowController: StartupFlowService

    // MARK: - Life-cycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Commenting out the animation part
        
//        guard self.isAppearingFirstTime else { return }
//        self.isAppearingFirstTime = false
//        self.performEnteringAnimation {
            self.flowController.moveToNextActionWith(.success)
//        }
    }
    
    func closeLogin() {
        flowController.moveToNextActionWith(.success)
    }
}
