//
//  Assembler.swift
//  ChatApp
//
//  Created by Александр Кравченков on 22/02/2022.
//

import Foundation
import Common
import UIKit

struct Assembler {
    
    static func assemble(msgBus: AnyBus<String>) -> UIViewController {
        let view = Controller()
        let presenter = Presenter(msgBus: msgBus, logger: ConsoleLoger())
        let service = Service(messageBus: msgBus, logger: ConsoleLoger())
        
        view.output = presenter
        presenter.view = view
        presenter.bag = [service]
        
        return view
    }
}
