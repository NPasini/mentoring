//
//  NavigationControllerProvider.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import UIKit
import Resolver
import Foundation

protocol NavigationControllerProvider {
    func getRootNavigationController() -> UINavigationController
}

extension NavigationControllerProvider {
    func getTopNavigationController() -> UINavigationController {
        let rootNav = getRootNavigationController()

        if let visibleViewController = rootNav.visibleViewController {
            if let nav = visibleViewController as? UINavigationController {
                return nav
            }
        }

        return rootNav
    }

    func getTopViewController() -> UIViewController? {
        let topNav = getTopNavigationController()
        return topNav.topViewController
    }
}

extension Resolver {
    static func registerRootViewControllerProvider() {
        register(NavigationControllerProvider.self) { AppNavigationControllerProvider() }
    }
}

class AppNavigationControllerProvider: NavigationControllerProvider {

    func getRootNavigationController() -> UINavigationController {
        guard let rootNavController = getAppRootController() as? UINavigationController else {
            fatalError("No root navigation controller found")
        }

        return rootNavController
    }

    private func getAppRootController() -> UIViewController? {
        if let appScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = appScene.delegate as? SceneDelegate {
            return delegate.window?.rootViewController
        }
        
        return nil
    }
}

