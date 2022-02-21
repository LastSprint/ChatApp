//
//  Logger.swift
//  Common
//
//  Created by Александр Кравченков on 16.02.2022.
//

import Foundation
import os

/// Custom protocol for logging
/// ``OS.Logger`` supports this protocol out of the box and also there is ``ConsoleLoger``
public protocol Logger {
    func warn(_ msg: String)
    func error(_ msg: String)
    func info(_ msg: String)
}

extension Logger {
    /// Logs error through ``error(_:)`` method
    func error(_ err: Error) {
        self.error(err.localizedDescription)
    }
}

extension os.Logger: Logger {
    
    public func warn(_ msg: String) {
        self.log(level: .error, "\(msg)")
    }
    
    public func info(_ msg: String) {
        self.log(level: .info, "\(msg)")
    }
    
    public func error(_ msg: String) {
        self.log(level: .error, "\(msg)")
    }
}

public class ConsoleLoger: Logger {
    /// Prints message into console in format `[ERR] {msg}`
    public func error(_ msg: String) {
        print("[ERR] \(msg)")
    }
    
    /// Prints message into console in format `[WARN] {msg}`
    public func warn(_ msg: String) {
        print("[WARN] \(msg)")
    }
    
    /// Prints message into console in format `[INFO] {msg}`
    public func info( _ msg: String) {
        print("[INFO] \(msg)")
    }
}
