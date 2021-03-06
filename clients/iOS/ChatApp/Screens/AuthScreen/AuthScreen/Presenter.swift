//
//  Presenter.swift
//  AuthScreen
//
//  Created by Александр Кравченков on 16/03/2022.
//

import Foundation
import Common
import Combine

protocol ViewOutput {
    /// Call this method when user wanted to sign in
    func signIn(userName: String?, password: String?)
}

final class Presenter {
    
    weak var view: ViewInput?
    var bag: [AnyObject]?
    
    private let msgBus: AnyBus<String>
    private let logger: Logger
    
    private var disposeBag: [AnyCancellable]
    
    init(msgBus: AnyBus<String>, logger: Logger) {
        self.msgBus = msgBus
        self.logger = logger
        self.disposeBag = []
        self.initSubscriptions()
    }
}

// MARK: - ViewOutput

extension Presenter: ViewOutput {
    func signIn(userName: String?, password: String?) {
        
        if userName?.isEmpty ?? true { self.view?.onUsernameIsEmpty() }
        if userName?.isEmpty ?? true { self.view?.onPasswordIsEmpty() }
        
        // i know that it's kind of doubling, but in the other hands it's much easier to read.
        
        guard
            let userName = userName,
            let password = password,
            !userName.isEmpty,
            !password.isEmpty
        else {
            return
        }
        
        self.view?.onLoading(isStarted: true)
        
        self.msgBus.dispatch(
            event: ServiceInputEvent.signIn.rawValue,
            data: SignInRequestModel(username: userName, password: password)
        )
    }
}

// MARK: - Subscriptions

private extension Presenter {
    
    func initSubscriptions() {
        self.msgBus.subscribe(event: ServiceOutputEvent.signedIn.rawValue)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.view?.onLoading(isStarted: false)
                guard case .failure(let err) = completion else { return }
                self.logger.error(err)
            } receiveValue: {
                self.view?.showGeneralError()
                self.logger.info("Auth was success")
                self.view?.onLoading(isStarted: false)
            }.store(in: &self.disposeBag)
    }
}


