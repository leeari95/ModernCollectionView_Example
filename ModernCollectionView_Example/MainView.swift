//
//  MainView.swift
//  ModernCollectionView_Example
//
//  Created by Ari on 2022/01/14.
//

import UIKit

class MainView: UIView {
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setUp() {
        backgroundColor = .blue
    }
}
