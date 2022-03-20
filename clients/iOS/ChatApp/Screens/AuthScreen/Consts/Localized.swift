//
//  L10n.swift
//  AuthScreen
//
//  Created by Александр Кравченков on 20.03.2022.
//

import Foundation

enum Localized {
    
    static let bundle = Bundle(for: Controller.self)
    
    enum Error {
        static var general: String {
            return "error.general".localized(bundle: Localized.bundle)
        }
    }
}
