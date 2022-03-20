//
//  DefaultSnackMessage.swift
//  Common
//
//  Created by Александр Кравченков on 19.03.2022.
//

import Foundation
import UIKit

/// Simple implementation of ``SnackMessage``
///
/// Provides possiblity to show any content you want
/// via ``DefaultSnackMessage/contentView`` property.
///
/// Use it through ``SnackManager``
///
/// You can use ``InfoSnackView`` directly or one of builders:
/// - ``DefaultSnackMessage/error(message:)``
/// - ``DefaultSnackMessage/warning(message:)``
/// - ``DefaultSnackMessage/info(message:)``
public final class DefaultSnackMessage: UIView {
    
    public var contentView: UIView {
        didSet {
            oldValue.removeFromSuperview()
            self.configureUI()
        }
    }
    
    public var didClose: (() -> Void)?
    
    public init(contentView: UIView) {
        self.contentView = contentView
        super.init(frame: .zero)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        self.contentView = UIView()
        super.init(coder: coder)
        self.configureUI()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK: - SnackMessage

extension DefaultSnackMessage: SnackMessage {
    public func close() { }
    
    public func open(in view: UIView) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // add left and right limits
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
        
        // calculate size of the snack view hieracy

        self.layoutIfNeeded()
        
        // place the snack under the current view
        
        let topConstraint = self.topAnchor.constraint(equalTo: view.topAnchor, constant: -self.frame.height)
        topConstraint.isActive = true
        
        self.frame = .init(x: view.layoutMarginsGuide.layoutFrame.origin.x,
                           y: -self.contentView.frame.height,
                           width: view.layoutMarginsGuide.layoutFrame.width,
                           height: self.contentView.frame.height
        )
        
        // run animation loop
        
        UIView.animate(withDuration: 1.5, delay: 0.5, options: [.curveEaseIn]) {
            topConstraint.constant = self.frame.height
            self.superview?.layoutIfNeeded()
        } completion: { isCompleted in
            guard isCompleted else { return }

            UIView.animate(withDuration: 1.5, delay: 3, options: [.curveEaseIn]) {
                topConstraint.constant = -self.frame.height
                self.superview?.layoutIfNeeded()
                self.frame.origin.y = -self.frame.size.height
            } completion: { isCompleted in
                guard isCompleted  else { return }
                self.removeFromSuperview()
                self.didClose?()
            }
        }

    }
}

// MARK: - Public configurations

public extension DefaultSnackMessage {
    
    static func error(message: String) -> DefaultSnackMessage {
        let content = InfoSnackView()
            .configure(as: .error, message: message)
        
        return DefaultSnackMessage(contentView: content)
    }
    
    static func warning(message: String) -> DefaultSnackMessage {
        let content = InfoSnackView()
            .configure(as: .warning, message: message)
        
        return DefaultSnackMessage(contentView: content)
    }
    
    static func info(message: String) -> DefaultSnackMessage {
        let content = InfoSnackView()
            .configure(as: .info, message: message)
        
        return DefaultSnackMessage(contentView: content)
    }
}

// MARK: - Configure UI

private extension DefaultSnackMessage {
    
    func configureUI() {
        self.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        
        self.contentView.stretch(insets: .init(top: 4, left: 4, bottom: 6, right: 4))
    }
}
