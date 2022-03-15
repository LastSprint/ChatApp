//
//  Controller.swift
//  ChatApp
//
//  Created by Александр Кравченков on 22/02/2022.
//

import Foundation
import UIKit

protocol ViewInput: AnyObject {
    func update(data: Int)
}

class Controller: UIViewController {
    
    let label = UILabel()
    let button = UIButton()
    
    var output: ViewOutput?
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        self.configureUI()
    }
}

extension Controller: ViewInput {
    func update(data: Int) {
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
