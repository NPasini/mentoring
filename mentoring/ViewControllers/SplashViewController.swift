//
//  SplashViewController.swift
//  mentoring
//
//  Created by Nicolò Pasini on 13/03/22.
//

import UIKit
import Resolver
import Foundation

class SplashScreenViewController: UIViewController {

    // MARK: - Properties

    @LazyInjected private var flowController: StartupFlowService

    private let logoMaxWidth: CGFloat = 200

    let logoFadeDuration: TimeInterval = 0.200
    let logoScalingDuration: TimeInterval = 0.400
    let logoFullVisibilityDuration: TimeInterval = 1.400

    // MARK: - IBOutlets

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!

    // MARK: - Life-cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLogo()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLogoSize()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateLogoSize()
    }

    // MARK: - Private functions

    private func updateLogoSize() {
        var widthMultiplier: CGFloat = 0
        if view.isRegularRegularUserInterfaceSizeClass {
            widthMultiplier = 0.2
        } else {
            widthMultiplier = 0.33
        }

        let widthConstraintValue: CGFloat = min(logoMaxWidth, view.bounds.width * widthMultiplier)
        logoWidthConstraint.constant = widthConstraintValue
    }

    private func initialSetup() {
        logoImageView.alpha = 0
        logoImageView.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
    }

    private func showLogo() {
        // Fade in of logo
        UIView.animate(withDuration: logoFadeDuration, delay: 0, options: .curveLinear) {
            self.logoImageView.alpha = 1
        }

        // Logo expansion
        UIView.animate(withDuration: logoScalingDuration) {
            self.logoImageView.transform = .identity
        } completion: { completed in
            if completed {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.logoFullVisibilityDuration) {
                    self.flowController.moveToNextActionWith(.success)
                }
            }
        }
    }
}
