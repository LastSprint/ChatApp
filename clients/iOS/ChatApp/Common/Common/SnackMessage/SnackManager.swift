//
//  SnackManager.swift
//  Common
//
//  Created by Александр Кравченков on 19.03.2022.
//

import Foundation
import UIKit

/// This entity is responsible for managing ``SnackMessage``
public protocol SnackManager {
    func show(snack: SnackMessage, in container: UIView)
}

/// Default implementation of ``SnackManager``
///
/// This implementation make sure that only one ``SnackMessage`` is displaying on the screen at the same time
/// If new massage is trying to get shown on the screen while another is displaying
/// the message will be put to the queue and will be shown later (when previous will be closed) automatically
public final class DefaultSnackManager {
    
    public static let shared = DefaultSnackManager()
    
    typealias SnackWithContainer = (snack: SnackMessage, container: UIView)
    
    var queue: [SnackWithContainer] = []
    var isShowing: Bool = false
}

// MARK: - SnackManager

extension DefaultSnackManager: SnackManager {
    public func show(snack: SnackMessage, in container: UIView) {
        guard !self.isShowing else {
            self.queue.append((snack, container))
            return
        }
        
        self.show(item: (snack, container))
    }
}

// MARK: - Private methods

private extension DefaultSnackManager {
    func show(item: SnackWithContainer) {
        self.isShowing = true
        var item = item
        
        item.snack.open(in: item.container)
        
        item.snack.didClose = { [weak self] in
            self?.onSnackClosed()
        }
    }
    
    private func onSnackClosed() {
        
        self.isShowing = false
        
        guard let next = self.queue.first else { return }
        
        self.queue.remove(at: 0)
        
        self.show(item: next)
    }
}
