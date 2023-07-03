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
    
    let profileFilterCellIdendifier: String = "profileFilterCell"
    
    weak var delegate: ProfileFilterViewDelegate?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(ProfileFilterCell.self,  forCellWithReuseIdentifier: profileFilterCellIdendifier)
        
        addSubview(collectionView)
        
        // collectionView의 크기를 상위 뷰에 맞게 크기를 지정한다.
        collectionView.addConstraintsToFillView(self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
