//
//  EventBus.swift
//  Common
//
//  Created by Александр Кравченков on 16.02.2022.
//

import Foundation
import Combine

/// This simple implementation can store only one listener for the same `EventKey`
/// 
/// If `EventKey` is the same as rigistred but `DataType` is different will print warning into console but won't dispatch anything.
///
/// For more infomation look at contract declared in ``Bus``
public class EventBus<EventKey>: Bus where EventKey: Hashable {
    
    private typealias __CallFutureAction = (Any) -> AnyObject?
    
    @DictionaryThreadSafeWrapper
    private var listeneres: [EventKey: __CallFutureAction]
    private let logger: Common.Logger
    
    public init(logger: Common.Logger) {
        self.listeneres = [:]
        self.logger = logger
    }
    
    public func dispatch<DataType>(event: EventKey, data: DataType) {
        guard let callAction = self.listeneres[event] else {
            self.logger.warn("There is no listener for event: \(event) in \(self.self)")
            return
        }
        
        guard let _ = callAction(data) else {
            self.logger.warn("Listner for data type \(DataType.self) with event \(event) not found")
            return
        }
    }
    
    public func dispatch(event: EventKey) {
        self.dispatch(event: event, data: ())
    }
    
    public func subscribe<DataType>(event: EventKey) -> AnyPublisher<DataType, Error> {
        
        let future = PassthroughSubject<DataType, Error>()
        
        let futureProvider = { (data: Any) -> AnyObject? in
            guard let casted = data as? DataType else {
                self.logger.warn("Can't cast \(type(of: data)) to \(DataType.self)")
                return nil
            }
            
            future.send(casted)
            return future
        }
        
        self.listeneres[event] = futureProvider
        
        return future.eraseToAnyPublisher()
    }
    
    public func unsubscribe(event: EventKey) {
        // TODO: - Doesnt support two listeners on one event
        self.listeneres[event] = nil
    }
}
