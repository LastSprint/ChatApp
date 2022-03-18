//
//  Presenter.swift
//  ChatApp
//
//  Created by Александр Кравченков on 22/02/2022.
//

import Foundation
import Combine
import Common

/// Public presenter interface for ``Controller``
public protocol ViewOutput {
    func update(data: String?)
}

/// Clue between ``Controller`` and ``Service``. Sometimes smart glue.
///
/// This object is the most complex. Because its reponse isn't clear.
/// But **at least** it should be responsible for keeping state, handle `View` events
/// (which describen in ``ViewOutput``) and manage `View` state through ``ViewInput``.
///
/// Also presenter can keep all other screen components in property ``Presenter/bag`` (because we have ARC, you know)
///
/// Presenter can have other subcomponents and
/// it's good to divide presenter in small subpresenters to separate different kind of logic.
///
/// Communication with lover levels better to keep through `Common.Bus`
/// because it decouples presenter even from type of gathering data (if it's stream or unary calls).
/// Generally, all this `lover level thing` is ``Service`` responsiblity.
///
/// Also it's best practice to inject `Logger` instead of creating it inside or use `print`.
///
/// **IMPORTANT**
/// Subscriptions have to be placed in `subscriptions` array so that otherwise
/// all your `Common.Bus` subscriptions will be deallocated immidiately after your `initSubscribtions` finishes
///
/// ## Best practices
/// 1. inject `Logger` instead of creating it inside or use `print`.
/// 2. Move ``ViewOutput`` implementation to extension.
/// 3. Move `Common.Bus` subscriptions to another extension
public final class Presenter {
    
    public weak var view: ViewInput?
    public var bag: [AnyObject]?
    
    
    private let msgBus: AnyBus<String>
    private let logger: Logger
    
    private var subscriptions: Set<AnyCancellable>
    
    init(msgBus: AnyBus<String>, logger: Logger) {
        self.msgBus = msgBus
        self.logger = logger
        self.subscriptions = []
        
        self.initSubscribtions()
    }
}

// MARK: - ViewOutput

extension Presenter: ViewOutput {
    public func update(data: String?) {
        
        guard let value = Int(data ?? "0") else { return }
        
        self.msgBus.dispatch(event: ServiceInputEvent.loadData.rawValue, data: value)
    }
}

// MARK: - Subscription

extension Presenter {
    private func initSubscribtions() {
        self.msgBus.subscribe(event: ServiceOutputEvent.updateData.rawValue).sink(receiveCompletion: { [weak self] compl in
            guard case .failure(let err) = compl else { return }
            self?.logger.error(err)
        }, receiveValue: { [weak self] (value: Int) in
            self?.view?.update(data: value)
        }).store(in: &self.subscriptions)
    }
}
