//
//  ProfileFilterViewDelegate.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/03.
//

import Foundation

protocol ProfileFilterViewDelegate: AnyObject {
    func filterView(_ view: ProfileFilterView, didSelect: IndexPath)
}

/*
 계층구조
 ProfileHeader - ProfileFilterView(collectionView) - ProfileFilterCell
 
 ProfileFilterView에 delegate: ProfileFilterViewDelegate 선언
 
 ProfileFilterView(collectionView)에서 선택되는 cell 감지
 cell 선택될 때마다 delegate.filterView 실행
 
 ProfileHeader에서 filterBar(ProfileFilterView).delegate = self을 함으로써 대리인을 ProfileHeader 클래스로 할당
 
 대리인이 ProfileHeader이기 때문에 함수 정의를 해줌 -> 전달된 collectionView의 didSelect에 따라 xPosition을 설정하고
 underline: UIView의 xPosition을 변경하는 코드 작성 -> Animate 적용
 */
