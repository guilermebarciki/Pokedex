//
//  UIViewController+Extensions.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 31/07/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    private struct AssociatedKeys {
        static var activityIndicator = "activityIndicator"
    }
    
    private var activityIndicator: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.activityIndicator) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.activityIndicator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showLoadingIndicator() {
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator?.center = self.view.center
            activityIndicator?.hidesWhenStopped = true
            if let activityIndicator = activityIndicator {
                self.view.addSubview(activityIndicator)
            }
        }
        activityIndicator?.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator?.stopAnimating()
    }
}
