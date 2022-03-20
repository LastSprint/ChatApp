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

    enum Auth {
        enum TextField {
            enum Password {
                enum Error {
                    static var empty: String {
                        return "auth.textField.password.error.empty".localized(bundle: Localized.bundle)
                    }
                }
                
                static var placeholder: String {
                    return "auth.textField.password.placeholder".localized(bundle: Localized.bundle)
                }
            }
            
            enum Username {
                enum Error {
                    static var empty: String {
                        return "auth.textField.username.error.empty".localized(bundle: Localized.bundle)
                    }
                }
                
                static var placeholder: String {
                    return "auth.textField.username.placeholder".localized(bundle: Localized.bundle)
                }
            }
        }
    }
}
