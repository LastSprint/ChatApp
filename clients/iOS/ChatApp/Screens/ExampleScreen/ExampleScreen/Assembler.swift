//
//  Assembler.swift
//  ChatApp
//
//  Created by Александр Кравченков on 22/02/2022.
//

import Foundation
import Common
import UIKit

/// Assembler is responsible for building screen.
/// It creates each components of the screen and inject approprieate dependencies in it.
///
/// The good way is to pass dependencies to `Assembler's` functions but it also can
/// create them (or get somwhere else) if it's appropriate in your logic.
///
/// Generally it's not necessary to use `Assembler` as dynamic object
/// so that you can mark all methods as `static` because each method is different builder
///
/// Also it doesn't make sense to write tests on `Assembler` (generally)
/// because it should contain only building logic.
public struct Assembler {
    public static func assemble(msgBus: AnyBus<String>) -> UIViewController {
        let view = Controller()
        let presenter = Presenter(msgBus: msgBus, logger: ConsoleLoger())
        let service = Service(messageBus: msgBus, logger: ConsoleLoger())
        
        view.output = presenter
        presenter.view = view
        presenter.bag = [service]
        
        return view
    }
}
