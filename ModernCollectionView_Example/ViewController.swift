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
    var snapshot: NSDiffableDataSourceSnapshot<Section, User>!
    
    var items = [
        User(name: "mic"),
        User(name: "mic.fill"),
        User(name: "message", stock: "품절"),
        User(name: "message.fill", stock: "품절"),
        User(name: "sun.min", baganPrice: ""),
        User(name: "sun.min.fill"),
        User(name: "sunset", baganPrice: ""),
        User(name: "sunset.fill", baganPrice: ""),
        User(name: "pencil", baganPrice: ""),
        User(name: "pencil.circle"),
        User(name: "highlighter"),
        User(name: "pencil.and.outline"),
        User(name: "personalhotspot"),
        User(name: "network"),
        User(name: "icloud"),
        User(name: "icloud.fill"),
        User(name: "car"),
        User(name: "car.fill"),
        User(name: "bus"),
        User(name: "bus.fill"),
        User(name: "flame"),
        User(name: "flame.fill"),
        User(name: "bolt"),
        User(name: "bolt.fill")
    ]
    
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
        
        // 데이터소스에 넣을 데이터를 Snapshot을 이용하여 컬렉션뷰에 데이터를 제공한다.
        snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

class MyListCell: UICollectionViewListCell {
    
    var item: User?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // 셀의 구성을 업데이트하는 메소드
    override func updateConfiguration(using state: UICellConfigurationState) {
        var customConfiguration = MyContentConfiguration().updated(for: state)
        
        // contentView의 요소들을 전달받은 item으로 구성하기
        customConfiguration.text = item?.name
        customConfiguration.image = item?.image
        customConfiguration.stock = item?.stock
        customConfiguration.price = item?.price
        customConfiguration.baganPrice = item?.baganPrice
        
        contentConfiguration = customConfiguration
        
        accessories = [
            .disclosureIndicator(options: .init(tintColor: .systemGray2)),
        ]
        
        // 콘텐츠뷰를 다운캐스팅
        guard let myContentView = contentView as? MyContentView else {
            return
        }
        
        if myContentView.stockLabel.text == "품절" { // 품절 시 글씨 색깔 바꾸기
            myContentView.stockLabel.textColor = .systemOrange
        }
        if myContentView.baganPriceLabel.text != "" { // 세일가격이 존재한다면 글씨스타일 수정
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "USD 1,234")
            attributeString.addAttribute(
                NSAttributedString.Key.strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSRange(location: 0, length: attributeString.length)
            )
            
            myContentView.priceLabel.attributedText = attributeString
            myContentView.priceLabel.textColor = .systemRed
            
        } else { // 세일가격이 존재하지 않다면 해당 레이블 숨김처리
            myContentView.baganPriceLabel.isHidden = true
        }
            
        
    }
}

struct MyContentConfiguration: UIContentConfiguration {
    
    var text: String?
    var image: UIImage?
    var stock: String?
    var price: String?
    var baganPrice: String?
    
    func makeContentView() -> UIView & UIContentView { // ContentView 인스턴스 생성
        return MyContentView(self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        // ContentConfiguration을 자신이 가지고있는 프로퍼티로 업데이트
        return self
    }
}

class MyContentView: UIView, UIContentView { // 셀 내부를 구성하는 콘텐츠뷰
    var configuration: UIContentConfiguration {
        didSet {
            apply(configuration: configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setUpSubViews()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var backgroundStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    var stockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        label.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        label.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    var baganPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        label.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    func apply(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? MyContentConfiguration else {
            return
        }
        imageView.image = configuration.image
        productNameLabel.text = configuration.text
        stockLabel.text = configuration.stock
        priceLabel.text = configuration.price
        baganPriceLabel.text = configuration.baganPrice
    }
    
    func setUpSubViews() {
        addSubview(backgroundStackView)
        backgroundStackView.addArrangedSubview(imageView)
        backgroundStackView.addArrangedSubview(labelsStackView)
        labelsStackView.addArrangedSubview(topStackView)
        labelsStackView.addArrangedSubview(bottomStackView)
        topStackView.addArrangedSubview(productNameLabel)
        topStackView.addArrangedSubview(stockLabel)
        bottomStackView.addArrangedSubview(priceLabel)
        bottomStackView.addArrangedSubview(baganPriceLabel)
        
        let imageViewHeight = imageView.heightAnchor.constraint(equalToConstant: 43)
        imageViewHeight.priority = .defaultHigh
        NSLayoutConstraint.activate([
            backgroundStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            backgroundStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            backgroundStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            backgroundStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            imageViewHeight,
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1/1)
        ])

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

