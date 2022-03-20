//
//  ErrorSnackView.swift
//  Common
//
//  Created by Александр Кравченков on 19.03.2022.
//

import Foundation
import UIKit

/// It's view for ``DefaultSnackMessage/contentView``
///
/// This snack contains one image and text label
///
/// Also it could be configured with predefined appearance via ``Kind`` and ``configure(as:)``
public final class InfoSnackView: UIView {

    // MARK: - Nested types
    
    /// Contains condiguration types
    public enum Kind {
        case error
        case warning
        case info
    }
    
    // MARK: - Subviews
    
    private let stackView = UIStackView()
    private let imageCallToAction = UIImageView()
    private let labelMessage = UILabel()
    
    // MARK: - Init
    
    public init() {
        super.init(frame: .zero)
        self.configureUI()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 4
    }
}

// MARK: - Public methods

public extension InfoSnackView {
    func configure(as kind: Kind, message: String) -> Self {
        
        self.labelMessage.text = message
        
        switch kind {
        case .error:
            self.backgroundColor = .systemRed
            self.labelMessage.textColor = .white
            self.imageCallToAction.image = .init(systemName: "xmark.octagon")
            self.imageCallToAction.tintColor = .white
        case .warning:
            self.backgroundColor = .systemYellow
            self.labelMessage.textColor = .white
            self.imageCallToAction.image = .init(systemName: "exclamationmark.triangle")
            self.imageCallToAction.tintColor = .white
        case .info:
            self.backgroundColor = .systemFill
            self.labelMessage.textColor = .label
            self.imageCallToAction.image = .init(systemName: "info.circle")
            self.imageCallToAction.tintColor = .label
        }
        
        return self
    }
}

// MARK: - Private methods

private extension InfoSnackView {
    
    func configureUI() {
        self.configureStackView()
        self.layer.masksToBounds = true
    }
    
    func configureStackView() {
        self.addSubview(self.stackView)
        self.stackView.stretch(insets: .init(top: 4, left: 4, bottom: 4, right: 4))

        self.stackView.axis = .horizontal
        self.stackView.alignment = .center
        self.stackView.spacing = 8
        
        self.configureImage()
        self.configureLabel()
    }
    
    func configureImage() {
        self.stackView.addArrangedSubview(self.imageCallToAction)
        self.imageCallToAction.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageCallToAction.heightAnchor.constraint(equalToConstant: 42),
            self.imageCallToAction.widthAnchor.constraint(equalToConstant: 46)
        ])
    }
    
    func configureLabel() {
        self.stackView.addArrangedSubview(self.labelMessage)
        self.labelMessage.numberOfLines = 0
    }
}
