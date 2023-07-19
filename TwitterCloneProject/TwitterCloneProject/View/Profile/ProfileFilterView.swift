//
//  ProfileFilterView.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/03.
//

import UIKit

class ProfileFilterView: UIView {
    
    // MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        
        return view
    }()

    let profileFilterCellIdendifier: String = "profileFilterCell"
    
    weak var delegate: ProfileFilterViewDelegate?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(ProfileFilterCell.self,  forCellWithReuseIdentifier: profileFilterCellIdendifier)
        
        // 첫 번째 자동 선택하는 과정
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
        addSubview(collectionView)
        
        // collectionView의 크기를 상위 뷰에 맞게 크기를 지정한다.
        collectionView.addConstraintsToFillView(self)
        

    }
    
    /*
     View의 Frame을 명시적으로 지정하지 않은 경우,
     명시적으로 지정하지 않은 View에 하위 View를 추가하고, 하위 View의 Frame을 지정한 경우
     autolayout을 사용하기 위해 해당 Frame을 알아야하는데, 모르기 때문에 나중에 rendering 한다는 목적으로 layoutSubView에 addSubView를 사용한다.
     */
    override func layoutSubviews() {
        addSubview(underlineView)
        let numberOfCells = CGFloat(ProfileFilterOptions.allCases.count)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / numberOfCells, height: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
