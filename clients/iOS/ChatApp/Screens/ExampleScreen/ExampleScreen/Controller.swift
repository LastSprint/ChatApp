//
//  Controller.swift
//  ChatApp
//
//  Created by Александр Кравченков on 22/02/2022.
//

import Foundation
import UIKit

/// Describes public ``Controller`` interface
///
/// the idea is to hide specific implementation from controller's backend
/// (``ViewOutput`` implementation)
/// so that you can change `View` part (for example different `Controllers` for different devices)
///
/// Also you have to consider that backend could be changed too, so that you don't have to expose any
/// paltform specific or implementation specific details.
///
/// The advice is `Leave state machine in presenter and manage animations in controller`
public protocol ViewInput: AnyObject {
    func update(data: Int)
}

/// UI part of the screen module `UIViewController`.
///
/// It's responsible **only** for UI part of the current `View`.
/// It doesn't have to contains any business logic, moreover,
/// all business logic have to be put in ``ViewOutput`` part of the screen.
///
/// Good practice is provide state changing methods in ``ViewOutput``
/// and call them from ``ViewOutput`` so that there will be only one place with state.
///
/// But if you are managing animations and other staff which is not connected to logic
/// it's better te leave it in `Controller`
///
/// ## About formatting
/// 1. It's better to implement ``ViewInput`` protocol in extension
/// 2. It's better to implement UI configuration in extension and call root configuration method `configureUI` and from this method call all other (layout, appearance, etc.)
/// 3. it's better to keep all your `@IBActions` or `action-target` selectors in defferent extension
/// 4. Use `MARKs` to keep your code navigatable
public final class Controller: UIViewController {
    
    // MARK: - Subviews
    
    let label = UILabel()
    let button = UIButton()
    
    // MARK: - Properties
    
    var output: ViewOutput?
    
    // MARK: - Lifecycle
    
    public override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        self.configureUI()
    }
}

// MARK: - ViewInput

extension Controller: ViewInput {
    public func update(data: Int) {
        self.label.text = "\(data)"
    }
}

// MARK: - UI Actions

extension Controller {
    
    @objc
    func handleUpdateButtonTap() {
        self.output?.update(data: self.label.text)
    }
    
}

// MARK: - Configure UI

extension Controller {
    
    func configureUI() {
        self.configureLabel()
        self.configureButton()
    }
    
    func configureLabel() {
        self.view.addSubview(self.label)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.textAlignment = .center
        self.label.textColor = .blue
        
        NSLayoutConstraint.activate([
            self.view.centerXAnchor.constraint(equalTo: self.label.centerXAnchor),
            self.view.centerYAnchor.constraint(equalTo: self.label.centerYAnchor),
            self.label.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
    }
    
    func configureButton() {
        self.button.setTitle("Update", for: .normal)
        self.button.setTitleColor(.systemBlue, for: .normal)
        
        self.button.addTarget(
            self,
            action: #selector(self.handleUpdateButtonTap), for: .touchUpInside
        )
        
        self.view.addSubview(self.button)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.button.widthAnchor.constraint(equalToConstant: 80),
            self.button.heightAnchor.constraint(equalToConstant: 40),
            self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.button.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 8)
        ])
    }
}
