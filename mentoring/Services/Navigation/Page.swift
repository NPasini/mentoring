//
//  Page.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import UIKit

enum Page {
    case tos
    case login
    case advisor
    case loadingDots
    case splashScreen

    var viewController: UIViewController {
        let storyboard = UIStoryboard(name: self.storyboardId, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: self.identifier)
    }

    var identifier: String {
        switch self {
        case .tos:
            return TermsOnboardingViewController.identifier
        case .login:
            return AuthenticationViewController.identifier
        case .advisor:
            return AdvisorViewController.identifier
        case .loadingDots:
            return LoadingDotsViewController.identifier
        case .splashScreen:
            return SplashScreenViewController.identifier
        }
    }

    var storyboardId: String {
        return "Main"
    }
}

public extension UIViewController {
    /// Returns the identifier of the current UIVIewController class.
    static var identifier: String {
        String(describing: self)
    }
}
