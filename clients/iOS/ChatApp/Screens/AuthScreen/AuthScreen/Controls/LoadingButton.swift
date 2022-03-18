//
//  LoadingButton.swift
//  AuthScreen
//
//  Created by Александр Кравченков on 16/03/2022.
//

import Foundation
import UIKit

final class LaodingButton: UIButton {
    
    var activityIndicator = UIActivityIndicatorView() {
        didSet {
            oldValue.removeFromSuperview()
            self.configureActivityIndicator()
        }
    }
    
    var viewLoadingBackground = UIView() {
        didSet {
            oldValue.removeFromSuperview()
            self.configureActivityIndicator()
        }
    }
    
    private var title: String?
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.activityIndicator = UIActivityIndicatorView()
        self.configureUI()
    }
    
    var isLoading: Bool {
        return self.activityIndicator.isAnimating
    }
    
    func startLoading() {
        guard !self.isLoading else { return }
        
        self.viewLoadingBackground.isHidden = false
        
        self.viewLoadingBackground.layer.cornerRadius = self.layer.cornerRadius
        self.activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        guard self.isLoading else { return }
        
        self.activityIndicator.stopAnimating()
        self.viewLoadingBackground.isHidden = true
    }
    
    /// **WARNING**
    /// Different states aren't supported
    /// Because I'm too lazy
    override func setTitle(_ title: String?, for state: UIControl.State) {
        self.title = title
        super.setTitle(title, for: state)
    }
}

// MARK: - Configure UI

private extension LaodingButton {
    
    func configureUI() {
        self.configureLoadingBackground()
        self.configureActivityIndicator()
    }
    
    func configureActivityIndicator() {
        self.activityIndicator.style = .large
        self.activityIndicator.color = .systemBlue
        self.activityIndicator.hidesWhenStopped = true
        
        self.viewLoadingBackground.addSubview(self.activityIndicator)
        
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.viewLoadingBackground.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.viewLoadingBackground.centerYAnchor),
        ])
    }
    
    func configureLoadingBackground() {
        self.addSubview(self.viewLoadingBackground)
        
        self.viewLoadingBackground.translatesAutoresizingMaskIntoConstraints = false
        self.viewLoadingBackground.backgroundColor = self.backgroundColor
        
        self.viewLoadingBackground.isHidden = true
        
        NSLayoutConstraint.activate([
            self.viewLoadingBackground.topAnchor.constraint(equalTo: self.topAnchor),
            self.viewLoadingBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.viewLoadingBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.viewLoadingBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}
