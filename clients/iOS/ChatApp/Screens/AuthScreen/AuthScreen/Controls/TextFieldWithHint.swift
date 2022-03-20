//
//  TextFieldWithHint.swift
//  AuthScreen
//
//  Created by Александр Кравченков on 20.03.2022.
//

import Foundation
import UIKit

public final class TextFieldHint: UIView {
    
    // MARK: - Subviews
    
    let textField = CustomTextField()
    private let labelHint = UILabel()
    
    // MARK: - Properties
    
    private var constraintTextViewBottom: NSLayoutConstraint?
    
    // MARK: - Init
    
    public init() {
        super.init(frame: .zero)
        self.configureUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
}

// MARK: - Public methods

public extension TextFieldHint {
    
    func setStateToError(message: String) {
        self.labelHint.textColor = .systemRed
        self.labelHint.text = message
        self.constraintTextViewBottom?.isActive = false
        self.labelHint.isHidden = false
    }
    
    func setStateToNormal() {
        self.labelHint.isHidden = true
        self.constraintTextViewBottom?.isActive = true
    }
}

// MARK: - Actions

@objc
private extension TextFieldHint {
    func onTextEdited() {
        self.setStateToNormal()
    }
}

// MARK: - Configure UI

private extension TextFieldHint {
    
    func configureUI() {
        self.backgroundColor = .clear
        self.configureTextField()
        self.configureLabelHint()
    }
    
    func configureTextField() {
        self.addSubview(self.textField)
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        
        self.textField.addTarget(
            self,
            action: #selector(self.onTextEdited),
            for: .editingDidBegin
        )
        
        self.textField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        let bottom = self.textField.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        self.constraintTextViewBottom = bottom
        NSLayoutConstraint.activate([
            self.textField.topAnchor.constraint(equalTo: self.topAnchor),
            self.textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottom
        ])
    }
    
    func configureLabelHint() {
        self.addSubview(self.labelHint)
        self.labelHint.translatesAutoresizingMaskIntoConstraints = false
        self.labelHint.numberOfLines = 0
        self.labelHint.isHidden = true

        NSLayoutConstraint.activate([
            self.labelHint.topAnchor.constraint(equalTo: self.textField.bottomAnchor),
            self.labelHint.leadingAnchor.constraint(equalTo: self.textField.leadingAnchor),
            self.labelHint.trailingAnchor.constraint(equalTo: self.textField.trailingAnchor),
            self.labelHint.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
