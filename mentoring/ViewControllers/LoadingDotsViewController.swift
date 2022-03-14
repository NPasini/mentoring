//
//  LoadingDotsViewController.swift
//  mentoring
//
//  Created by Nicolò Pasini on 12/03/22.
//

import UIKit
import Resolver

public protocol AnimationDelegate: AnyObject {
    func animationDidFinish(in view: UIView)
}

class LoadingDotsViewController: UIViewController {

    // MARK: - Properties

    @LazyInjected private var flowController: StartupFlowService

    private let loadingViewVisibilityDuration: TimeInterval = 0.120

    private let loadingViewMaxWidth: CGFloat = 200

    private var closureAction: (() -> Void)?

    // MARK: - IBOutlets

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingViewWidthConstraint: NSLayoutConstraint!

    // MARK: - Life-cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        loadingView.showLoading(type: .switching)
        animateLoadingViewAlpha()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLoadingViewSize()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateLoadingViewSize()
    }

    // MARK: - Public Methods

    func stopAnimation(completion: @escaping () -> Void) {
//        loadingView.hideLoading(waitUntilEndOfAnimation: false)
        closureAction = completion
        
        // Simulating ending of animation
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.closureAction?()
        }
    }

    // MARK: - Private Methods

    private func configure() {
//        loadingView.alpha = 0
//        loadingView.delegate = self
//        loadingView.backgroundColor = .clear
//        loadingView.scheduler = scheduler
    }

    /// Calculates the `loadingView` size based to the current content/device size.
    private func updateLoadingViewSize() {
        var widthMultiplier: CGFloat = 0

        if view.isRegularRegularUserInterfaceSizeClass {
            widthMultiplier = 0.2
        } else {
            widthMultiplier = 0.33
        }

        let widthConstraintValue: CGFloat = min(loadingViewMaxWidth, view.bounds.width * widthMultiplier)
        loadingViewWidthConstraint.constant = widthConstraintValue
    }

    private func animateLoadingViewAlpha() {
        UIView.animate(withDuration: loadingViewVisibilityDuration, delay: 0, options: .curveLinear) {
            self.loadingView.alpha = 1
        } completion: { completed in
            if completed {
                self.flowController.moveToNextActionWith(.success)
            }
        }
    }
}

extension LoadingDotsViewController: AnimationDelegate {
    func animationDidFinish(in view: UIView) {
        closureAction?()
    }
}
 
extension UIView {
    var isRegularRegularUserInterfaceSizeClass: Bool {
        sizeClass() == (.regular, .regular)
    }
    
    func sizeClass() -> (UIUserInterfaceSizeClass, UIUserInterfaceSizeClass) {
        (self.traitCollection.horizontalSizeClass, self.traitCollection.verticalSizeClass)
    }
}
