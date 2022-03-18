//
//  CustomUITextField.swift
//  AuthScreen
//
//  Created by Александр Кравченков on 16/03/2022.
//

import Foundation
import UIKit

/// This text field provides possiblity to change text position by setting `CustomUITextField.textextPadding`
final class CustomTextField: UITextField {
    
    let labelHint = UILabel()
    
    var textPadding = UIEdgeInsets.zero
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
}

// MARK: - Configure UI

private extension CustomTextField {
    func configureUI() {
         
    }
}
