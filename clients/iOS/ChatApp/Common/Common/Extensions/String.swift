//
//  String.swift
//  Common
//
//  Created by Александр Кравченков on 20.03.2022.
//

import Foundation

public extension String {
        
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
