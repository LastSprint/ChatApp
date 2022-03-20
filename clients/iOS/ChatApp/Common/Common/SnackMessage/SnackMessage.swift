//
//  SnackMessage.swift
//  Common
//
//  Created by Александр Кравченков on 16/03/2022.
//

import Foundation
import UIKit

/// Describes message wich could be shown by ``SnackManager``
public protocol SnackMessage {
    
    /// Lifecycle method which is used by ``SnackManager``
    /// You must not to write something in this property
    ///
    /// Also if you implement custom ``Snack`` you need to call this callback
    /// when your `Snack` should be considered as closed
    var didClose: (() -> Void)? { get set }
    
    func close()
    func open(in: UIView)
}
