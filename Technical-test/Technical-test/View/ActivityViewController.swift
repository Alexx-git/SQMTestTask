//
//  ActivityViewController.swift
//  Technical-test
//
//  Created by Alexx on 31.03.2023.
//

import UIKit

class ActivityViewController: UIViewController {
    var activityView = UIActivityIndicatorView(style: .large)

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(white: 0.7, alpha: 0.3)

        activityView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityView)
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityView.startAnimating()
    }
    
    class func showOnViewController(_ viewController: UIViewController) -> ActivityViewController {
        let activityVC = ActivityViewController()
        viewController.addChild(activityVC)
        activityVC.view.frame = viewController.view.frame
        viewController.view.addSubview(activityVC.view)
        activityVC.didMove(toParent: viewController)
        return activityVC
    }
    
    func dismiss() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
