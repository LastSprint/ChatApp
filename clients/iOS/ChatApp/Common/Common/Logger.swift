//
//  Logger.swift
//  Common
//
//  Created by Александр Кравченков on 16.02.2022.
//

import Foundation

public protocol Logger {
    func warn(_ msg: String)
    func error(_ msg: String)
    func info(_ msg: String)
}

extension Logger {
    func error(_ err: Error) {
        self.error(err.localizedDescription)
    }
}

public class ConsoleLoger: Logger {
    public func error(_ msg: String) {
        print("[ERR] \(msg)")
    }
    
    public func warn(_ msg: String) {
        print("[WARN] \(msg)")
    }
    
    public func info(_ msg: String) {
        print("[INFO] \(msg)")
    }
}
