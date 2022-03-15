//
//  Service.swift
//  ChatApp
//
//  Created by Александр Кравченков on 22/02/2022.
//

import Foundation
import Common
import Combine

enum ServiceEvent: String {
    case loadData
    case updateData
}


class Service {
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
        self.messageBus.dispatch(event: ServiceEvent.updateData.rawValue, data: value + 1)
    }
}

// MARK: - Subscription

private extension Service {
    func initSubscriptions(msgBus: AnyBus<String>) {
        self.messageBus.subscribe(event: ServiceEvent.loadData.rawValue)
            .sink(receiveCompletion: { [weak self] completion in
                guard case .failure(let err) = completion else { return }
                self?.logger.error(err)
            }, receiveValue: { [weak self] (value: Int) in
                self?.apiCall(value: value)
            }).store(in: &self.cancelable)
    }
}
