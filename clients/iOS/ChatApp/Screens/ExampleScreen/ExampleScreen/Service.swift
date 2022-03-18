//
//  Service.swift
//  ChatApp
//
//  Created by Александр Кравченков on 22/02/2022.
//

import Foundation
import Common
import Combine

/// Contains events which ``Service`` accept
public enum ServiceInputEvent: String {
    case loadData
}

/// Contains events which ``Service`` emits
public enum ServiceOutputEvent: String {
    case updateData
}

/// Lover-level part of screen module.
/// 
/// Can contain any logic you need. You can place a code for networking, db access, business logic, processing, etc.
/// So the main idea of service is to keep hard things or third-party-dependent things.
///
/// Also service can contains nested services to create pipelines.
///
/// Service how to communicate with ``Presenter`` through `Common.Bus` and fo this purpose there are have to be two types of events ``ServiceInputEvent`` and ``ServiceOutputEvent``
///
/// BEst practices are the same as for ``Presenter``
public final class Service {
    private let messageBus: AnyBus<String>
    private let logger: Logger
    
    private var cancelable: Set<AnyCancellable> = []
    
    init(messageBus: AnyBus<String>, logger: Logger) {
        self.messageBus = messageBus
        self.logger = logger
        self.initSubscriptions(msgBus: messageBus)
    }

}

// MARK: - API Calls

private extension Service {
    func apiCall(value: Int) {
        self.messageBus.dispatch(event: ServiceOutputEvent.updateData.rawValue, data: value + 1)
    }
}

// MARK: - Subscription

private extension Service {
    func initSubscriptions(msgBus: AnyBus<String>) {
        self.messageBus.subscribe(event: ServiceInputEvent.loadData.rawValue)
            .sink(receiveCompletion: { [weak self] completion in
                guard case .failure(let err) = completion else { return }
                self?.logger.error(err)
            }, receiveValue: { [weak self] (value: Int) in
                self?.apiCall(value: value)
            }).store(in: &self.cancelable)
    }
}
