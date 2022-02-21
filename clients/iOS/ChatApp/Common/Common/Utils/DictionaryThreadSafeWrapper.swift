//
//  ThreadSafeDictionary.swift
//  Common
//
//  Created by Александр Кравченков on 21/02/2022.
//

import Foundation

/// Each operation by subscript proxied through private DispatchQueue's sync operation.
/// But that's it. Nothing more
@propertyWrapper
public struct DictionaryThreadSafeWrapper<Key: Hashable, Value> {
    private let queue: DispatchQueue
    
    public var wrappedValue: [Key: Value]
    
    public init(queue: DispatchQueue? = nil, wrappedValue: [Key: Value] = [:]) {
        self.queue = queue ?? DispatchQueue(label: "example.\(Key.self).\(Value.self)")
        self.wrappedValue = wrappedValue
    }
    
    public subscript(key: Key) -> Value? {
        get {
            return self.queue.sync { return self.wrappedValue[key] }
        }
        set {
            return self.queue.sync { self.wrappedValue[key] = newValue }
        }
    }
}
