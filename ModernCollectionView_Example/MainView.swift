//
//  MainView.swift
//  ModernCollectionView_Example
//
//  Created by Ari on 2022/01/14.
//

import UIKit

class MainView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)
        setUp()
        setUpSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setUp() {
        backgroundColor = .blue
    }
    
    func setUpSubViews() {
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
