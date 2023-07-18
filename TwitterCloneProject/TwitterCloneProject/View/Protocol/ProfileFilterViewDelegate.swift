//
//  ProfileFilterViewDelegate.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/03.
//

import Foundation

protocol ProfileFilterViewDelegate: AnyObject {
    func filterView(_ view: ProfileFilterView, didSelect index: Int)
}

/*
 계층구조
 ProfileController - ProfileHeader - ProfileFilterView(collectionView) - ProfileFilterCell
 
 ProfileFilterView에 delegate: ProfileFilterViewDelegate 선언
 
 ProfileFilterView(collectionView)에서 선택되는 cell 감지
 cell 선택될 때마다 delegate.filterView 실행
 
 ProfileHeader에서 filterBar(ProfileFilterView).delegate = self을 함으로써 대리인을 ProfileHeader 클래스로 할당
 
 대리인이 ProfileHeader이기 때문에 함수 정의 해줌 -> 함수에서 ProfileHeader의 delegate 호출
 
 ProfileHeader의 delegate의 대리인은 ProfileController 이다.
 ProfileHeader에서 정의한 filterView(_ view: ProfileFilterView, didSelect index: Int) 함수 내에
 delegate.didSelect(filter: ProfileFilterOptions) 함수를 호출
 
 ProfileController에서 didSelect(filter: ProfileFilterOptions) 함수를 정의해 줌
 
 ProfileFilterView의 delegate는 ProfileHeaderView
 ProfileHeaderView의 delegate는 ProfilController
 
 ProfileHeader에서 delegate 함수(filterView 함수)를 정의하고 함수 내에 본인의 delegate 함수(didSelect 함수)를 호출
 ProfileController에서 delegate 함수(didSelect)를 정의하여 ProfileFilterView에서 2계층 ProfileController까지 연결되도록 함
 */
