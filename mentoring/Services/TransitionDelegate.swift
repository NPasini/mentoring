//
//  TransitionDelegate.swift
//  mentoring
//
//  Created by Nicolò Pasini on 13/03/22.
//

import UIKit
import Resolver
import Foundation

extension Resolver {
    static func registerTransitionDelegate() {
        register(UINavigationControllerDelegate.self) { NavigationControllerTransitionsDelegate() }
        register(UIViewControllerTransitioningDelegate.self) { ViewControllerTransitionsDelegate() }
    }
}

class ViewControllerTransitionsDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        nil
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        nil
    }
}

class NavigationControllerTransitionsDelegate: NSObject, UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        performPreliminarOperations(operation: operation, from: fromVC, to: toVC)
        return getTransitionControllerfor(operation: operation, from: fromVC, to: toVC)
    }

    private func getTransitionControllerfor(operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // Here we have our custom transition delegates defined for semplicity I am just returning nil
        switch operation {
        case .none:
            return nil

        case .push:
            return nil

        case .pop:
            return nil

        default:
            return nil
        }
    }

    private func performPreliminarOperations(operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) {
        switch operation {
        case .none: ()
        case .push: ()
        case .pop: ()
        default: ()
        }
    }
}
