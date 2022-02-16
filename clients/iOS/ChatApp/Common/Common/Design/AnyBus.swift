//
//  AnyBus.swift
//  Common
//
//  Created by Александр Кравченков on 16.02.2022.
//

import Combine

public struct AnyBus<EventKey: Hashable>: Bus {

    private let nested: __AnyBusStub<EventKey>
    
    public init<T>(nested: T) where T: Bus, T.EventKey == EventKey {
        self.nested = __AnyBusBox(nested: nested)
    }
    
    public func dispatch<DataType>(event: EventKey, data: DataType) {
        self.nested.dispatch(event: event, data: data)
    }
    
    public func subscribe<DataType>(event: EventKey) -> AnyPublisher<DataType, Error> {
        return self.nested.subscribe(event: event)
    }
    
    public func unsubscribe(event: EventKey) {
        self.nested.unsubscribe(event: event)
    }
}

class __AnyBusStub<EventKey: Hashable>: Bus {
    
    func dispatch<DataType>(event: EventKey, data: DataType) {
        fatalError()
    }
    
    func dispatch(event: EventKey) {
        fatalError()
    }
    
    func subscribe<DataType>(event: EventKey) -> AnyPublisher<DataType, Error> {
        fatalError()
    }
    func unsubscribe(event: EventKey) {
        fatalError()
    }
}

class __AnyBusBox<EventKey, T>: __AnyBusStub<EventKey> where T: Bus, T.EventKey == EventKey {
    
    let nested: T
    
    init(nested: T) {
        self.nested = nested
    }
    
    override func dispatch<DataType>(event: EventKey, data: DataType) {
        self.nested.dispatch(event: event, data: data)
    }
    
    override func subscribe<DataType>(event: EventKey) -> AnyPublisher<DataType, Error> {
        return self.nested.subscribe(event: event)
    }
    
    override func unsubscribe(event: EventKey) {
        self.nested.unsubscribe(event: event)
    }
}
