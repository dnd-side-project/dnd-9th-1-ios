//
//  DefaultLeftBarButton.swift
//  Milestone
//
//  Created by 서은수 on 2023/09/18.
//

import UIKit

// MARK: - 기본 nav left bar button

class DefaultLeftBarButton: UIBarButtonItem {
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        
        configUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func configUI() {
        image = UIImage(systemName: "chevron.left")
        imageInsets = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 0)
        style = .plain
        tintColor = .gray05
    }
}
