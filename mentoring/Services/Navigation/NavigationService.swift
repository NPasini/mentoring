//
//  NavigationService.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import UIKit
import Resolver

protocol NavigationService {
    func popCurrentPage(on navigationController: UINavigationController, animated: Bool)
    func popToPage(page: Page, on navigationController: UINavigationController, animated: Bool)
    func dismiss(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func resetViewControllersStack(to page: Page, on navigationController: UINavigationController, animated: Bool)

    @discardableResult
    func push(_ page: Page, using navigationController: UINavigationController, animated: Bool) -> UIViewController

    @discardableResult
    func present(
        _ page: Page,
        presentationStyle: UIModalPresentationStyle,
        onTopOf presentingViewController: UIViewController,
        animated: Bool,
        withNavigationController: Bool,
        presentationDelegate: AnyObject?
    ) -> UIViewController
}

extension NavigationService {
    func dismiss(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        dismiss(viewController, animated: animated, completion: completion)
    }

    func present(_ page: Page, presentationStyle: UIModalPresentationStyle, onTopOf presentingViewController: UIViewController, animated: Bool) {
        present(
            page,
            presentationStyle: presentationStyle,
            onTopOf: presentingViewController,
            animated: animated,
            withNavigationController: false,
            presentationDelegate: nil
        )
    }
}

class Navigation: NavigationService {

    private let navigationTransitionDelegate: UINavigationControllerDelegate
    private let viewControllerTransitionDelegate: UIViewControllerTransitioningDelegate

    init(navigationTransitionDelegate: UINavigationControllerDelegate, viewControllerTransitionDelegate: UIViewControllerTransitioningDelegate) {
        self.navigationTransitionDelegate = navigationTransitionDelegate
        self.viewControllerTransitionDelegate = viewControllerTransitionDelegate
    }

    func resetViewControllersStack(to page: Page, on navigationController: UINavigationController, animated: Bool) {
        navigationController.delegate = navigationTransitionDelegate
        navigationController.setViewControllers([page.viewController], animated: animated)
    }

    func popCurrentPage(on navigationController: UINavigationController, animated: Bool) {
        navigationController.delegate = navigationTransitionDelegate
        navigationController.popViewController(animated: animated)
    }

    func popToPage(page: Page, on navigationController: UINavigationController, animated: Bool) {
        if let landingPage = navigationController.viewControllers.first(where: { type(of: $0).identifier == page.identifier }) {
            navigationController.delegate = navigationTransitionDelegate
            navigationController.popToViewController(landingPage, animated: animated)
        } else {
            popCurrentPage(on: navigationController, animated: animated)
        }
    }

    @discardableResult
    func push(_ page: Page, using navigationController: UINavigationController, animated: Bool) -> UIViewController {
        let viewController = page.viewController
        navigationController.delegate = navigationTransitionDelegate
        navigationController.pushViewController(viewController, animated: animated)
        return viewController
    }

    func dismiss(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        viewController.transitioningDelegate = viewControllerTransitionDelegate
        viewController.dismiss(animated: true, completion: completion)
    }

    @discardableResult
    func present(
        _ page: Page,
        presentationStyle: UIModalPresentationStyle,
        onTopOf presentingViewController: UIViewController,
        animated: Bool = true,
        withNavigationController: Bool = false,
        presentationDelegate: AnyObject? = nil
    ) -> UIViewController {
        let viewController = page.viewController
        viewController.modalPresentationStyle = presentationStyle
        viewController.transitioningDelegate = viewControllerTransitionDelegate
        presentingViewController.present(viewController, animated: animated, completion: nil)
        return viewController
    }
}

extension Resolver {
    static func registerNavigationService() {
        register(NavigationService.self) { Navigation(navigationTransitionDelegate: resolve(), viewControllerTransitionDelegate: resolve()) }
    }
}
