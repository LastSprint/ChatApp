//
//  Service.swift
//  AuthScreen
//
//  Created by Александр Кравченков on 16/03/2022.
//

import Foundation
import Common

enum ServiceInputEvent: String {
    case signIn
}

enum ServiceOutputEvent: String {
    case signedIn
}

final class Service {
    
    private let msgBus: AnyBus<String>
    private let logger: Logger
    
    init(msgBus: AnyBus<String>, logger: Logger) {
        self.msgBus = msgBus
        self.logger = logger
    }
}
