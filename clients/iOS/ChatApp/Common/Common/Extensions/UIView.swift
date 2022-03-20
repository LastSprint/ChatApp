//
//  UIView.swift
//  Common
//
//  Created by Александр Кравченков on 16/03/2022.
//

import Foundation
import UIKit

public extension UIView.AnimationCurve {
    
    var animationOption: UIView.AnimationOptions {
        switch self {
        case .easeInOut:
            return .curveEaseInOut
        case .easeIn:
            return .curveEaseIn
        case .easeOut:
            return .curveEaseOut
        case .linear:
            return .curveLinear
        @unknown default:
            return .curveLinear
        }
    }
}

public extension UIView {

    func stretch(to view: UIView, insets: UIEdgeInsets = .zero) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom),
        ])
    }
    
    func stretch(insets: UIEdgeInsets = .zero) {
        guard let view = self.superview else {
             return
        }
        
        self.stretch(to: view, insets: insets)
    }
}
