//
//  ProfileFilterView+.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/03.
//

import UIKit

// MARK: - UICollectionViewDataSource
extension ProfileFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOptions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileFilterCellIdendifier, for: indexPath) as? ProfileFilterCell
        
        guard let cell = cell else { fatalError("ProfileFilterView Cell Error") }
        
        let option = ProfileFilterOptions(rawValue: indexPath.row)
        cell.option = option
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        let xPosition = cell?.frame.origin.x ?? 0
        
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
        
        delegate?.filterView(self, didSelect: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    // 아이템 별 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCells = CGFloat(ProfileFilterOptions.allCases.count)
        
        return CGSize(width: frame.width / numberOfCells, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
