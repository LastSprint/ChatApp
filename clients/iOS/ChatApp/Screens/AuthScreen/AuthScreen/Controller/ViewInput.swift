//
//  ViewInput.swift
//  AuthScreen
//
//  Created by Александр Кравченков on 20.03.2022.
//

import Foundation

protocol ViewInput: AnyObject {
    func onPasswordIsEmpty()
    func onUsernameIsEmpty()
    func showGeneralError()
    
    func onLoading(isStarted: Bool)
}
