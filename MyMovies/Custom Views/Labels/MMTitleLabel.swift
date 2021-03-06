//
//  MMTitleLabel.swift
//  MyMovies
//
//  Created by user on 2/11/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit

final class MMTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(textAlignment:NSTextAlignment, fontSize:CGFloat) {
        self.init(frame:.zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    
    private func configure() {
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
