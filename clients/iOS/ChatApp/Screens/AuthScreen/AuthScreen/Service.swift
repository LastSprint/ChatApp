//
//  Service.swift
//  AuthScreen
//
//  Created by Александр Кравченков on 16/03/2022.
//

import Foundation
import Common
import Combine

enum ServiceInputEvent: String {
    case signIn
}

enum ServiceOutputEvent: String {
    case signedIn
}

final class Service {
    
    private let msgBus: AnyBus<String>
    private let logger: Logger
    private var disposeBag: Set<AnyCancellable>
    
    init(msgBus: AnyBus<String>, logger: Logger) {
        self.msgBus = msgBus
        self.logger = logger
        self.disposeBag = []
        
        self.initSubscriptions()
    }
}

private extension Service {
    
    func doAuth(with credentials: SignInRequestModel) {
        self.msgBus.dispatch(event: ServiceOutputEvent.signedIn.rawValue, data: ())
    }
}

private extension Service {
    
    func initSubscriptions() {
        
        self.msgBus.subscribe(event: ServiceInputEvent.signIn.rawValue)
            .sink(receiveCompletion: { [weak self] completion in
                guard case .failure(let err) = completion else { return }
                self?.logger.error(err)
            }, receiveValue: { [weak self] (value: SignInRequestModel) in
                self?.doAuth(with: value)
            }).store(in: &self.disposeBag)
    }
}
