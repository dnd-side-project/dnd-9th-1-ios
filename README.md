
<div align="center"> 

<h2><i>💎 목표를 작게 나누고 차근차근 깨나가보세요! Milestone 💎</i></h2>


<img src="https://github.com/dnd-side-project/dnd-9th-1-ios/assets/75518683/7ca4040d-ce90-4351-a000-acb11a07e6d2" width="200" />


[<img width="200" alt="스크린샷 2021-11-19 오후 3 52 02" src="https://github-production-user-asset-6210df.s3.amazonaws.com/75518683/268173445-322afec8-38fa-46ba-bbe0-3fffd0c93f5b.png">](https://apps.apple.com/kr/app/milestone/id6465692785?l=en)

[📑 9th DND Milestone 발표자료 📑](https://github.com/dnd-side-project/dnd-9th-1-ios/files/12640253/DND.9.1.pdf)  

[📹 9th DND Milestone 시연영상 📹](https://www.youtube.com/watch?v=CRG0wGTOHTA)

</div>

### 🛠 Development Environment

<img width="77" alt="스크린샷 2021-11-19 오후 3 52 02" src="https://img.shields.io/badge/iOS-16.0+-silver"> <img width="95" alt="스크린샷 2021-11-19 오후 3 52 02" src="https://img.shields.io/badge/Xcode-13.2.1-blue">

### 🎁 Library

| 라이브러리        | Version     |       |
| ----------------- | :-----:  | ----- |
| Then              | `3.0.0`  | `SPM` |
| SnapKit           | `5.6.0`  | `SPM` |
| RxSwift           | `6.6.0`  | `SPM` |
| RxCocoa           | `6.6.0`  | `SPM` |
| RxKakaoOpenSDK    | `2.17.0` | `SPM` |

### 📖 Milestone SwiftLint Rule & Usage
```
disabled_rules:
- trailing_whitespace
- force_cast
- force_try
- force_unwrapping
- identifier_name
- line_length
- shorthand_operator
- type_name
- function_parameter_count
- function_body_length
- nesting
- cyclomatic_complexity
- mark

opt_in_rules:
- empty_count
- empty_string
- vertical_parameter_alignment_on_call
```

### 🗂 Folder Structure
```
dnd-9th-1-ios
└── Milestone
    └── Milestone
        ├── Core
        │   ├── API
        │   ├── Foundation
        │   └── Services
        ├── Global
        │   ├── Base
        │   ├── Component
        │   ├── Enum
        │   ├── Extension
        │   ├── Literal
        │   ├── Resource
        │   │   ├── Assets.xcassets
        │   │   └── Font
        │   ├── Support
        │   └── Utils
        ├── Model
        ├── Network
        │   └── Foundation
        └── Screens
            ├── Onboarding
            │   ├── View
            │   └── ViewModel
            ├── Main
            │   └── View
            ├── StorageBox
            │   ├── View
            │   └── ViewModel
            ├── FillBox
            │   ├── Protocol
            │   ├── View
            │   │   └── Cell
            │   └── ViewModel
            ├── CompletionBox
            │   ├── View
            │   │   └── Cell
            │   └── ViewModel
            └── Setting
                ├── Cell
                └── ViewModel
```

### 🍎 iOS Developers

| [@Parkjju](https://github.com/Parkjju) | [@EunsuSeo01](https://github.com/EunsuSeo01) |
|:---:|:---:|
|<img width="220" alt="스크린샷 2021-11-19 오후 3 52 02" src="https://avatars.githubusercontent.com/parkjju">|<img width="220" alt="스크린샷 2021-11-19 오후 3 52 02" src="https://avatars.githubusercontent.com/EunsuSeo01">|<img width="220" alt="스크린샷 2021-11-19 오후 3 52 02" src="https://avatars.githubusercontent.com/EunsuSeo01">|
| `완료함` <br/> `설정화면` <br/> `Alamofire 네트워크 세팅` <br/> `카카오톡 & 애플 로그인` <br/> `키체인 옵저버블` | `프로젝트 세팅` <br/> `메인 PageVC + SegmentControl` <br/> `채움함` <br/> `복구함` <br/> |
