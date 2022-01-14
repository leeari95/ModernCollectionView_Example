//
//  ViewController.swift
//  ModernCollectionView_Example
//
//  Created by Ari on 2022/01/14.
//

import UIKit

class ViewController: UIViewController {
    
    let mainView = MainView()
    var dataSource: UICollectionViewDiffableDataSource<Section, User>!
    
    override func loadView() {
        super.loadView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        
    }
    
    func setUpCollectionView() {
        // 셀을 등록하기 위한 변수 선언
        let registration = UICollectionView.CellRegistration<MyListCell, User>  { cell, indexPath, user in
            cell.item = user
        }
        
        // 데이터소스를 선언
        dataSource = UICollectionViewDiffableDataSource<Section, User>(collectionView: mainView.collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, user: User) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: user)
            /*
             using: 위에서 선언한 registration를 전달하면 셀을 등록한다.
             for: 셀의 위치를 지정하는 인덱스
             item: 셀에 제공할 데이터
             */
            
            return cell
        }
    }


}

enum Section {
    case main
}

// 리스트셀에 데이터를 넣을 때 필요한 모델
struct User: Hashable {
    let image: UIImage
    let name: String
    let price: String
    let baganPrice: String
    let stock: String
    
    init(name: String, stock: String = "잔여수량: 123", baganPrice: String = "USD 123") {
        self.name = name
        self.image = UIImage(systemName: name)!
        self.price = "USD 1,234"
        self.baganPrice = baganPrice
        self.stock = stock
    }
}

