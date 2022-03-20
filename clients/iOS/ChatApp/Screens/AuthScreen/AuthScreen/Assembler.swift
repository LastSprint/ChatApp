//
//  Assembler.swift
//  AuthScreen
//
//  Created by Александр Кравченков on 16/03/2022.
//

import Foundation
import Common
import UIKit

public struct Assembler {
    
    public static func assemble(bus: AnyBus<String>, logger: Logger) -> UIViewController {
        let view = Controller(snackManager: DefaultSnackManager.shared)
        let presenter = Presenter(msgBus: bus, logger: logger)
        let service = Service(msgBus: bus, logger: logger)
        
        presenter.view = view
        view.output = presenter
        presenter.bag = [service]
        
        return view
    }
}
