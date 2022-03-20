//
//  Controller.swift
//  AuthScreen
//
//  Created by Александр Кравченков on 16/03/2022.
//

import Foundation
import UIKit
import Combine
import Common

final class Controller: UIViewController {
    
    // MARK: - Subviews
    
    private let imageViewLogo = UIImageView()
    private let textFieldUserName = TextFieldHint()
    private let textFieldPassword = TextFieldHint()
    private let buttonSignIn = LaodingButton()
    
    // MARK: - Properties
    
    var output: ViewOutput?
    
    private let snackManager: SnackManager
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var constraintSignInButtonToBottom: NSLayoutConstraint?
    
    // MARK: - Init
    
    public init(snackManager: SnackManager) {
        self.snackManager = snackManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.snackManager = DefaultSnackManager.shared
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.buttonSignIn.layer.cornerRadius = self.buttonSignIn.frame.height / 2
        self.textFieldPassword.textField.layer.cornerRadius = self.textFieldPassword.textField.frame.height / 2
        self.textFieldUserName.textField.layer.cornerRadius = self.textFieldUserName.textField.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeOnKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.unsubscribeFromKeyboardNotification()
    }
}

// MARK: - ViewInput

extension Controller: ViewInput {
    
    func showGeneralError() {
        self.snackManager.show(
            snack: DefaultSnackMessage.error(message: Localized.Error.general),
            in: self.view
        )
    }
    
    func onPasswordIsEmpty() {
        self.textFieldPassword.setStateToError(
            message: Localized.Auth.TextField.Password.Error.empty
        )
    }
    
    func onUsernameIsEmpty() {
        self.textFieldUserName.setStateToError(
            message: Localized.Auth.TextField.Username.Error.empty
        )
    }
    
    func onLoading(isStarted: Bool) {
        if isStarted {
            self.buttonSignIn.startLoading()
        } else {
            self.buttonSignIn.stopLoading()
        }
    }
}

// MARK: - Actions

private extension Controller {
 
    @objc
    func actionSignInButtonTap() {
        self.output?.signIn(
            userName: self.textFieldUserName.textField.text,
            password: self.textFieldPassword.textField.text
        )
    }
    
    @objc
    func actionGRGlobalTap() {
        self.view.endEditing(true)
    }
}

// MARK: - Keyboard notifications

private extension Controller {
    
    func subscribeOnKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.turnControlsUp(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.turnControlsUp(notification:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.turnControlsUp(notification:)),
            name: UIResponder.keyboardDidChangeFrameNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.dropControlsDown(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.dropControlsDown(notification:)),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }
    
    func unsubscribeFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
    }
        
    @objc
    func turnControlsUp(notification: NSNotification) {
        guard
            let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuratin = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curveNumber = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
            let curve = UIView.AnimationCurve(rawValue: curveNumber.intValue)
        else {
            return
        }
        
        self.constraintSignInButtonToBottom?.constant = -frame.height - 24
        self.constraintSignInButtonToBottom?.priority = .defaultHigh
        self.view.setNeedsLayout()
        
        UIView.animate(withDuration: animationDuratin.doubleValue, delay: 0, options: curve.animationOption) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func dropControlsDown(notification: NSNotification) {
        guard
            let animationDuratin = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curveNumber = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
            let curve = UIView.AnimationCurve(rawValue: curveNumber.intValue)
        else {
            return
        }
        
        self.constraintSignInButtonToBottom?.constant = 0
        self.constraintSignInButtonToBottom?.priority = .defaultLow
        self.view.setNeedsLayout()
        
        UIView.animate(withDuration: animationDuratin.doubleValue, delay: 0, options: curve.animationOption) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Configure UI

private extension Controller {

    func configureUI() {
        self.configureView()
        self.configureTextFieldUserName()
        self.configureTextFieldPassword()
        self.configureButtonSignIn()
        self.configureImageView()
        self.configureGlobalTapGR()
    }
    
    func configureView() {
        self.view.backgroundColor = .systemBackground
    }
    
    func configureTextFieldUserName() {
        self.view.addSubview(self.textFieldUserName)
        self.textFieldUserName.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldUserName.textField.placeholder = Localized.Auth.TextField.Username.placeholder
        self.textFieldUserName.textField.backgroundColor = .secondarySystemBackground
        self.textFieldUserName.textField.textColor = .label
        self.textFieldUserName.textField.autocorrectionType = .no
        self.textFieldUserName.textField.textPadding = .init(top: 12, left: 8, bottom: 12, right: 0)
        
        NSLayoutConstraint.activate([
            self.textFieldUserName.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.textFieldUserName.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
        ])
    }
    
    func configureTextFieldPassword() {
        self.view.addSubview(self.textFieldPassword)
        self.textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldPassword.textField.placeholder = Localized.Auth.TextField.Password.placeholder
        self.textFieldPassword.textField.backgroundColor = .secondarySystemBackground
        self.textFieldPassword.textField.textColor = .label
        self.textFieldPassword.textField.isSecureTextEntry = true
        self.textFieldPassword.textField.textPadding = self.textFieldUserName.textField.textPadding
        
        let middleX = self.textFieldPassword.centerYAnchor.constraint(lessThanOrEqualTo: self.view.layoutMarginsGuide.centerYAnchor)
        middleX.priority = UILayoutPriority(UILayoutPriority.defaultHigh.rawValue - 1)
        
        NSLayoutConstraint.activate([
            self.textFieldPassword.leadingAnchor.constraint(equalTo: self.textFieldUserName.leadingAnchor),
            self.textFieldPassword.trailingAnchor.constraint(equalTo: self.textFieldUserName.trailingAnchor),
            self.textFieldPassword.topAnchor.constraint(equalTo: self.textFieldUserName.bottomAnchor, constant: 16),
            middleX
        ])
    }
    
    func configureButtonSignIn() {
        self.view.addSubview(self.buttonSignIn)
        self.buttonSignIn.translatesAutoresizingMaskIntoConstraints = false
        self.buttonSignIn.setTitle("Sign In", for: .normal)
        self.buttonSignIn.backgroundColor = .secondarySystemBackground
        self.buttonSignIn.setTitleColor(.label, for: .normal)
        
        self.buttonSignIn.addTarget(self, action: #selector(self.actionSignInButtonTap), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            self.buttonSignIn.centerXAnchor.constraint(equalTo: self.view.layoutMarginsGuide.centerXAnchor),
            self.buttonSignIn.topAnchor.constraint(equalTo: self.textFieldPassword.bottomAnchor, constant: 44),
            self.buttonSignIn.widthAnchor.constraint(equalToConstant: 120),
            self.buttonSignIn.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        let bottom = self.buttonSignIn.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor)
        bottom.priority = .defaultLow
        bottom.isActive = true
        self.constraintSignInButtonToBottom = bottom
    }
    
    func configureImageView() {
        self.view.addSubview(self.imageViewLogo)
        self.imageViewLogo.isUserInteractionEnabled = false
        
        self.imageViewLogo.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageViewLogo.image = UIImage(systemName: "message.and.waveform")
        
        NSLayoutConstraint.activate([
            self.imageViewLogo.widthAnchor.constraint(equalToConstant: 160),
            self.imageViewLogo.heightAnchor.constraint(equalToConstant: 160),
            self.imageViewLogo.bottomAnchor.constraint(equalTo: self.textFieldUserName.topAnchor, constant: -44),
            self.imageViewLogo.centerXAnchor.constraint(equalTo: self.textFieldUserName.centerXAnchor)
        ])
    }
    
    func configureGlobalTapGR() {
        let gr = UITapGestureRecognizer()
        gr.numberOfTapsRequired = 1
        gr.addTarget(self, action: #selector(self.actionGRGlobalTap))
        self.view.addGestureRecognizer(gr)
    }
}
 
