//
//  SnackMessage.swift
//  Common
//
//  Created by Александр Кравченков on 16/03/2022.
//

import Foundation
import UIKit

public final class SnackMessage: UIView {
    
    public var contentView = UIView()
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    override public func layoutSubviews() {
        self.layer.cornerRadius = self.frame.height / 4
        super.layoutSubviews()
    }
}

extension SnackMessage {
    func close() {
        
    }
}

private extension SnackMessage {
    
    func configureUI() {
        
    }
}

@objc
private extension SnackMessage {
    
    func handleTouchGR() {
        self.close()
    }
}

private extension SnackMessage {
    
    func configureTouchGR() {
        let gr = UITapGestureRecognizer(target: self, action: #selector(self.handleTouchGR))
        self.addGestureRecognizer(gr)
    }
}
