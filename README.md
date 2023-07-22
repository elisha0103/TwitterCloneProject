# Twitter Clone Project <img src="https://github.com/elisha0103/TwitterCloneProject/assets/41459466/8ca5eca7-c595-498e-8bd5-6d2183020112" width="25" height="25">
> Firebase - RealtimeDatabase를 사용한 Twitter Clone Project

<br>

<img src="https://github.com/elisha0103/TwitterCloneProject/assets/41459466/99151fe3-9544-40cf-b6cf-5b3f8035d71c">

<br>

## 프로젝트 목표
> - Codebase로 UI 구현하기
> - Delegate 패턴 이해하기
> - 비동기 처리에 따른 Lifecycle 이해하기
> - 실제 Twitter 앱 참고하여 UI/UX 반영하기
> - 효율적인 관계형 데이터베이스 테이블 구성하기

<br>

## 구현한 기능
- Realtime Database를 사용하여 Tweet 게시 기능 구현
 - Feed에 본인 Tweet과 Following 유저의 트윗만 보이도록 구현
 - FCM 도입시 알림 처리를 위한 Notification 데이터 모델 구현
 - Tweet 객체의 Database 객체를 구조화하여 리트윗 기능을 구현
 - 유저의 트윗, 리트윗, 좋아요 Filter 구현
 - API Data(Profile) 이미지 캐시 구현
 - `다크/라이트 모드` 전환에 대응

<br>

## 개발 환경
- Deployment Target: iOS 15.0
- Architecture: MVVM
- 프레임워크: UIKit
- Third Party: Firebase, ActiveLabel, SDWebImage
- Database: Firebase - RealtimeDatabase, Firebase - Storage

<br>
<br>

# 폴더 컨벤션

```
AppStoreClone
├── App
├── Model
├── View
│   ├── Authentication
│   │   └── Controller
│   ├── Feed
│   │   ├── Controller
│   │   └── ViewModel   
│   ├── Tweet
│   │   ├── Controller
│   │   └── ViewModel   
│   ├── Profile
│   │   ├── Controller
│   │   └── ViewModel 
│   ├── Notification
│   │   ├── Controller
│   │   └── ViewModel   
│   ├── Conversation
│   │   └── Controller  
│   └── Search
│       └── Controller  
├── Protocol
├── Extension
├── API
└── Utilis

```


# 목차
- [프로젝트 특징](#프로젝트-특징)
- [Troubleshooting](#troubleshooting)
- [구현 화면](#구현-화면)
- [보완할 점](#보완할-점)

<br>
<br>

# 프로젝트 특징
## 1. 트윗 
### 1-1 Feed
- Feed에 사용자의 트윗과 팔로우한 유저의 트윗을 나타냅니다.
- 사용자가 트윗을 작성하고 게시하면 RealtimeDatabase에 데이터가 업로드되고, 새로운 트윗 내용이 Feed에 반영됩니다.
- 특정 유저를 Unfollow하면 해당 유저의 트윗이 본인 Feed에서 사라집니다.

### 1-2 리트윗
- 리트윗 게시글을 작성하면 최상위 트윗에 종속되는 리트윗 게시글이 생성됩니다.
- 리트윗 게시글에 좋아요, 리트윗을 작성할 수 있습니다.
- 트윗 게시글을 볼 때, 하단에 리트윗 게시글이 표시됩니다.

### 1-3 좋아요
- 트윗 게시글에 좋아요 버튼을 누르면 트윗 작성자에게 좋아요 알림이 발송됩니다.
- 게시글을 좋아요하면 프로필 Filter에 본인이 좋아요한 트윗 게시글이 표시됩니다.

<br>
<br>

## 2. 프로필
- 유저의 프로필 이미지를 선택하면 프로필 View로 이동합니다.
### 2-1 프로필 헤더
- 프로필 헤더에 유저의 following/follow 수가 업데이트 됩니다.
- 프로필 헤더에서 유저를 follow 또는 unfollow 할 수 있습니다. unfollow를 하면 Feed에서 더이상 유저의 트윗이 표시되지 않습니다.

### 2-2 Filter
- 프로필 헤더에 Filter를 선택하면 하단에 다른 Tweet들을 업데이트 합니다.
- 유저의 트윗, 리트윗, 좋아요 트윗 게시물을 확인할 수 있습니다.

### 2-3 프로필 편집
- 유저의 프로필 화면에서 본인 프로필인 경우 편집을 할 수 있습니다.
- 사진을 변경하거나, 이름, 소개를 변경한 경우 Database에 변경사항이 업데이트 됩니다.

<br>
<br>


## 3. 알림
### 3-1 리트윗, 팔로우, 좋아요, 맨션
- 사용자가 리트윗, 팔로우, 좋아요, 맨션을 하면 해당 유저의 Notification 데이터베이스에 알림 정보를 보냅니다.
- 알림을 받은 유저는 다른 유저의 알림 정보를 확인할 수 있습니다.

### 3-2 팔로우
- 사용자가 팔로우를 보낸경우, 알림을 받은 유저는 해당 사용자의 팔로우, 언팔로우 상태를 확인할 수 있고 Notification View에서 팔로우 상호작용을 할 수 있습니다.
- Notification View에서 사용자의 Follow 변화를 감지하여 Feed에 트윗을 노출시키거나 감출 수 있습니다.

<br>
<br>

## 4. 맨션, 해시태그
### 4-1 맨션
- '@'로 시작하는 단어인 경우 자동으로 맨션처리가 됩니다.
- 사용자가 다른 유저를 맨션하면 맨션받은 유저는 맨션 알림을 받습니다.
- 맨션된 글을 탭하면 맨션된 유저의 프로필 화면으로 이동합니다.

### 4-2 해시태그
- '#'을 입력하고 뒤에오는 단어는 자동으로 해시태그 등록이 됩니다.

<br>
<br>

## Troubleshooting
### 1. 멈추지 않는 RefreshControl
- Feed에서 Tweet을 Fetch할 때, 표시될 Tweet이 없는 경우 Refesh 애니메이션이 멈추지 않는 현상 발생
    - **문제 해결**: Database 경로에 Fetch될 Data가 있는지 분기 처리하여 각 분기별 다른 코드 적용
    ```swift
        REF_USER_FOLLOWING.child(currentuid).observeSingleEvent(of: .value) { snapshot in
        if snapshot.exists() {  // 데이터가 존재하는지 확인
            // following 한 사람들 목록
            REF_USER_FOLLOWING.child(currentuid).observe(.childAdded) { snapshot in
                let followinguid = snapshot.key

                // following 한 사람들의 tweet 목록
                REF_USER_TWEETS.child(followinguid).observe(.childAdded) { snapshot in
                        
                        ...

                        completion(tweets)
                    }
                }
            }
        } else {

            ...
            
            completion(tweets)
        }
    }

    REF_USER_TWEETS.child(currentuid).observeSingleEvent(of: .value) { snapshot in
        if snapshot.exists() {  // 데이터가 존재하는지 확인
            REF_USER_TWEETS.child(currentuid).observe(.childAdded) { snapshot in

                    ...

                    completion(tweets)
                }
            }
        } else {
            
            ...

            completion(tweets)
        }
    }

    ```

### 2. Tweet 중복 업데이트
- Feed에서 Refresh할 때, 트윗이 중복 업데이트 되는 현상 발생
    - **문제 해결**: Refresh한 횟수만큼 Tweet Reference 관찰 함수가 생성되므로, Refresh할 때에 모든 관찰함수를 제거하고 다시 관찰함수를 호출하는 형식으로 수정

<br>
<br>

### 3. Tweet Cell 동적 높이 할당
- Tweet의 줄바꿈 수가 일정 수를 넘어가면 다른 Cell에 겹쳐서 표시되는 현상
    - **문제 해결**: 더미 UILabel을 생성해서 Tweet의 내용(text)을 더미 UILabel에 할당하여 UILabel의 높이를 얻어 cell별로 동적 높이 할당하는 함수 구현(ViewModel의 size함수)
    ```swift
        // Dynamic content size(about height)
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()    // 임시 UILabel 생성하여
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping // 줄바꿈 속성 - 줄바꿈할 때 단어를 다음줄로
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false// autolayout을 사용하면 automask는 비활성화
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        // UIView.layoutFittingExpanded: 가능한 큰 사이즈
        // UIView.layoutFittingCompressedSize: 가능한 작은 사이즈
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    ```

### 4. DB 데이터의 계층간 종속관계
- 유저의 Follow, 트윗의 리트윗, 사용자의 팔로워 수 등 데이터간 종속 관계를 표현할 데이터베이스 계층 구조 구현의 어려움
    - **문제 해결**: 데이터베이스의 공간 효율성을 고려하여 각 데이터간 종속 관계를 표현할 용도의 저장소를 만들고,
    User나 Tweet의 Key 값만 저장하고 데이터를 가져올 때에는 해당 Key를 추적하여 User, Tweet 데이터를 Fetch하는 형식으로 구현

        <img src="https://github.com/elisha0103/TwitterCloneProject/assets/41459466/b1d110a3-dec1-4e13-bcc7-29ff012b6ce2">

<br>
<br>

# 구현 화면
|검색 화면|리트윗|맨션/해시태그|
|-|-|-|
|<img src="https://github.com/elisha0103/TwitterCloneProject/assets/41459466/9e92f079-7404-4a1c-946a-b700a062a7bc" width="200">|<img src="https://github.com/elisha0103/TwitterCloneProject/assets/41459466/fa43c210-4ceb-4b9f-b6de-4602d65805ca" width="200">|<img src="https://github.com/elisha0103/TwitterCloneProject/assets/41459466/3d61b68c-e272-4339-bea9-49556cd47bae" width="200">|

<br>

|프로필 수정|로그아웃|다크/라이트 모드 대응|
|-|-|-|
|<img src="https://github.com/elisha0103/TwitterCloneProject/assets/41459466/0bfa4610-1fab-479c-bf82-bda36734f2bd" width="200">|<img src="https://github.com/elisha0103/TwitterCloneProject/assets/41459466/14aaa0e6-f77c-4976-bdbc-aa6a64cd6bc8" width="200">|<img src="https://github.com/elisha0103/TwitterCloneProject/assets/41459466/202bbce8-cf90-4359-bf23-eb5a5ac74701" width="200">|


<br>
<br>
    
## 활용기술

#### Platforms

<img src="https://img.shields.io/badge/iOS-5A29E4?style=flat&logo=iOS&logoColor=white"/>  

<br>

#### Language & Tools

<img src="https://img.shields.io/badge/Xcode-147EFB?style=flat&logo=Xcode&logoColor=white"/> <img src="https://img.shields.io/badge/UIKit-%232396F3.svg?&style=flat&logo=UIKit&logoColor=white" /> <img src="https://img.shields.io/badge/Swift-F05138?style=flat&logo=swift&logoColor=white"/>

<br>
<br>

# 보완할 점
   - [ ] 공유 버튼
   - [ ] Direct Message
   - [ ] FCM을 활용한 PushMessage      
   - [ ] Retweet Database 구조 개편(Retweet CRUD 함수 분리) 
   - [ ] 프로필 상단 배경화면 이미지 기능 구현   
   - [ ] 가로모드 대응을 위한 SafeLayoutGuide 수정
   - [ ] async/await 활용한 효율적인 collectionView.reloadData() 사용
