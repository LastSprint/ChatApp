//
//  Presenter.swift
//  ChatApp
//
//  Created by Александр Кравченков on 22/02/2022.
//

import Foundation
import Combine
import Common

protocol ViewOutput {
    func update(data: String?)
}

class Presenter {
    
    weak var view: ViewInput?
    var bag: [AnyObject]?
    
    
    private let msgBus: AnyBus<String>
    private let logger: Logger
    
    private var subscriptions: Set<AnyCancellable>
    
    init(msgBus: AnyBus<String>, logger: Logger) {
        self.msgBus = msgBus
        self.logger = logger
        self.subscriptions = []
        
        self.subscribe()
    }
    
    private func subscribe() {
        self.msgBus.subscribe(event: ServiceEvent.updateData.rawValue).sink(receiveCompletion: { [weak self] compl in
            guard case .failure(let err) = compl else { return }
            self?.logger.error(err)
        }, receiveValue: { [weak self] (value: Int) in
            self?.view?.update(data: value)
        }).store(in: &self.subscriptions)
    }
}

extension Presenter: ViewOutput {
    func update(data: String?) {
        
        guard let value = Int(data ?? "0") else { return }
        
        self.msgBus.dispatch(event: ServiceEvent.loadData.rawValue, data: value)
    }
}
