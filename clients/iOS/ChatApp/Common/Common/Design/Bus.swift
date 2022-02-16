//
//  Bus.swift
//  Common
//
//  Created by Александр Кравченков on 16.02.2022.
//

import Combine

/// Bus is interface for any data bus
/// The idea is this thing can be used to deliver different data portions between different parts of system
/// And this parts dont have to know about each oher
///
/// You can use different buses for different situations
public protocol Bus {
    
    /// Event kay to search listeners. It would be better to use enums as keys. Or at least string constants
    associatedtype EventKey: Hashable
    
    /// This method will dispatch event with data to this bus.
    /// And if somebody is listening for it (called `subscribe` later) - he will recive data by specific event
    func dispatch<DataType>(event: EventKey, data: DataType)
    
    /// This method will subscribe you on current event
    /// If somebody call `dispatch` with your `EventKey` and your `DataType`
    /// then you will recive data in publisher
    ///
    /// Publisher is multiemitable - you don't have to renew subscription after each emition.
    func subscribe<DataType>(event: EventKey) -> AnyPublisher<DataType, Error>
    
    /// Remove you listener from current bus
    /// It's important to call this method otherwise you will face with memoreleack
    func unsubscribe(event: EventKey)
}
