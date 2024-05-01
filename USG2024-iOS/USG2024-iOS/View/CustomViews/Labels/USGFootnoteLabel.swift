//
//  USGFootnoteLabel.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 30.04.2024.
//

import UIKit

class USGFootnoteLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        configure()
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 12)
        textColor = .label
        adjustsFontSizeToFitWidth = false
        
        lineBreakMode = .byTruncatingTail
        
    }
}
