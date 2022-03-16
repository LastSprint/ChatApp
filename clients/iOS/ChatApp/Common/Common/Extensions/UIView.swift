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
