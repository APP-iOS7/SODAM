![Image](https://github.com/user-attachments/assets/a5a14f53-07ed-45f7-902c-3c8a2d5dc415)
<br /><br />

# 소담<img src="https://github.com/user-attachments/assets/46692dd8-448e-4a55-b689-8d078aa6f765" align=left width=200>

소담은 위치기반 음성 안내 기능을 통해 사용자에게 특정 장소의 정보를 제공함으로써
편리하고 깊이있는 경험을 제공하는 오디오 가이드 앱입니다.

사용자가 특정 장소를 이동하며 현장의 분위기에 어울리는 음성 안내를 이야기 형식으로 들을 수 있으며,
장소의 역사와 정보 등을 음성으로 전달하여 시각적, 청각적 정보를 동시에 습득해 높은 몰입감을 경험할 수 있습니다.

<br /><br />

## 주요 특징

- 기존의 QR코드, 팸플릿, 표지판 등 시각 중심의 정보 제공 방식을 벗어나 음성 안내를 통해 직관적이고 편리한 경험을 제공합니다.

- 사용자는 자신의 위치를 중심으로 최대 **20km** 까지 주변 관광지를 확인 할 수 있으며, 해당 장소의 **1km 이내**에 접근하면 장소의 문화와 역사 등의 정보들이 담긴 이야기 형식의 음성 안내를 들을 수 있습니다.

- **방문한 관광지**는 거리가 멀어져도 이야기를 다시 들을 수 있습니다.

- **오늘의 이야기**를 통해 새로운 관광지의 이야기를 들을 수 있습니다.

- **초등교육 콘텐츠**를 통해 문화와 역사 등의 교육을 위한 이야기들을 들을 수 있습니다.

- **지역별 콘텐츠**의 지도를 통해 전국에 숨겨져있는 명소의 이야기들을 찾을 수 있습니다

- **시작 화면의 지도**를 통해 실시간으로 이동하며 사용자 근처에 들을 수 있는 이야기를 확인 할 수 있습니다.

<br/> <br/>

## 🎯 타깃 사용자

- 관광지에 대한 **역사와 문화에 관심이 있는 사람**
- 팸플릿이나 안내문 같은 **시각 자료 외에 음성 안내가 필요한 사람**
- **간편한 방법**으로 관광지의 이야기를 듣고 싶은 사람
- **초등 교과서 속 역사·문화 내용**을 생생하게 체험하고 싶은 학부모와 자녀

<br/> <br/>

## Git Commit Convention

![git](https://github.com/user-attachments/assets/d74e67e6-4164-47c3-882c-05790d312120)

<br /><br />

## Folder Convention

<pre lang="markdown"> <code>
📱 SODAM
┣ 📂 Configurations
┃ ┣ ⚙️ config.xcconfig
┣ 📂 SODAM
┃ ┣ 📂 Resource
┃   ┃ ┣🎨 Assets
┃   ┃ ┣📄 data.json
┃ ┣ 📂 Sources
┃   ┃ ┣ 📂 AppCommon
┃   ┃ ┃ ┃ ┣📄 APIConfig
┃   ┃ ┃ ┃ ┣📄 CustomAsyncImage
┃   ┃ ┃ ┃ ┣📄 SegmentControlsComponent
┃   ┃ ┃ ┃ ┣📄 TabBarComponent
┃   ┃ ┣ 📂 Manager
┃   ┃ ┃ ┃ ┣📄 DataManager
┃   ┃ ┃ ┃ ┣📄 ImageLoader
┃   ┃ ┃ ┃ ┣📄 NetworkManager
┃   ┃ ┃ ┃ ┣📄 RegionDataCacheManager
┃   ┃ ┃ ┃ ┣📄 UserDefaultManager
┃   ┃ ┃ ┃ ┣📄 UserLocation
┃   ┃ ┣ 📂 Model
┃   ┃ ┃ ┃ ┣📄 AddressResponse
┃   ┃ ┃ ┃ ┣📄 DetailModel
┃   ┃ ┃ ┃ ┣📄 GalleryResponse
┃   ┃ ┃ ┃ ┣📄 PlaceItem
┃   ┃ ┃ ┃ ┣📄 Region
┃   ┃ ┃ ┃ ┣📄 StoryResponse
┃   ┃ ┃ ┃ ┣📄 ThemeLocationBaseedModel
┃   ┃ ┣ 📂 Service
┃   ┃ ┃ ┃ ┣📄 APIService
┃   ┃ ┣ 📂 View
┃   ┃ ┃ ┃ ┣📄 AppSettingsView
┃   ┃ ┃ ┃ ┣📄 ContentView
┃   ┃ ┃ ┃ ┣📄 DetailView
┃   ┃ ┃ ┃ ┣📄 EducationListView
┃   ┃ ┃ ┃ ┣📄 EducationView
┃   ┃ ┃ ┃ ┣📄 HomeView
┃   ┃ ┃ ┃ ┣📄 KakaoMapStartView
┃   ┃ ┃ ┃ ┣📄 KakaoMapView
┃   ┃ ┃ ┃ ┣📄 MapView
┃   ┃ ┃ ┃ ┣📄 MenuView
┃   ┃ ┃ ┃ ┣📄 MyNearbyListView
┃   ┃ ┃ ┃ ┣📄 NearbyMapView
┃   ┃ ┃ ┃ ┣📄 NearTouristSpotView
┃   ┃ ┃ ┃ ┣📄 PlayerView
┃   ┃ ┃ ┃ ┣📄 RegionalListView
┃   ┃ ┃ ┃ ┣📄 RegionDetailListView
┃   ┃ ┃ ┃ ┣📄 RegionMapView
┃   ┃ ┃ ┃ ┣📄 StartView
┃   ┃ ┃ ┃ ┣📄 VisitedPlaceListView
┃   ┃ ┣ 📂 ViewModel
┃   ┃ ┃ ┃ ┣📄 ContentViewModel
┃   ┃ ┃ ┃ ┣📄 EducationListViewModel
┃   ┃ ┃ ┃ ┣📄 EducationViewModel
┃   ┃ ┃ ┃ ┣📄 HomeViewModel
┃   ┃ ┃ ┃ ┣📄 MyNearbyListViewModel
┃   ┃ ┃ ┃ ┣📄 PlayerViewModel
┃   ┃ ┃ ┃ ┣📄 RegionDetailListViewModel
┃   ┃ ┃ ┃ ┣📄 StartViewModel
┃   ┃ ┃ ┃ ┣📄 VisitedPlacesViewModel
┃ ┣ 📦 UICommon
┃   ┃ ┣📄 ColorExtension
┃   ┃ ┣📄 UIImageExtension
┃ ┣ 🚀 SODAMApp
</code> </pre>

<br /><br />

## 주요기능과 스크린샷

|                                                 홈화면                                                  |                                                시작화면                                                 |                                                전체메뉴                                                 |
| :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: | ------------------------------------------------------------------------------------------------------- |
| <img src="https://github.com/user-attachments/assets/dac955e3-219c-4963-b9a1-1e88374f7f66" width="200"> | <img src="https://github.com/user-attachments/assets/2f7fc99a-816a-452e-9a31-bc6d669ade48" width="200"> | <img src="https://github.com/user-attachments/assets/50a0b395-229a-4ddd-8e16-93530c6e703c" width="200"> | <img src="https://github.com/user-attachments/assets/32adebd5-2992-4ad2-8c45-70f1d3fd02dc" width="200"> |

|                                          내 주변 관광지(목록)                                           |                                          내 주변 관광지(지도)                                           |                                                지역 선택                                                |
| :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/4c0f8db4-7ede-40b3-85d4-1712524d3a00" width="200"> | <img src="https://github.com/user-attachments/assets/75565596-4a91-4f02-b98b-bd7da970e4fa" width="200"> | <img src="https://github.com/user-attachments/assets/0f5a3fad-3f6b-4033-85a4-e97ce9fe035b" width="200"> |

|                                           지역별 관광지(목록)                                           |                                           지역별 관광지(지도)                                           |                                                  설정                                                   |
| :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/998c0f19-b2de-4065-ba76-b132ad18b443" width="200"> | <img src="https://github.com/user-attachments/assets/d49f8bca-3afd-4676-a489-886b56dec431" width="200"> | <img src="https://github.com/user-attachments/assets/f800bbb7-74e9-4ce1-ab56-9a1cd1d6b8c8" width="200"> |

|                                               상세 페이지                                               |                                        상세 페이지(오디오 재생)                                         |                                            초등 교육 관광지                                             |
| :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/4bb714e4-b2c5-4928-b4fd-6133a32b0783" width="200"> | <img src="https://github.com/user-attachments/assets/4c36f209-10c7-4921-8876-ab7b3d48c8ec" width="200"> | <img src="https://github.com/user-attachments/assets/e4b09446-b485-4ab0-85ba-c8f406df9fd4" width="200"> |

|                                           교과서 속 문화 여행                                           |                                           교과서 속 역사 여행                                           |                                           교과서 속 인물 여행                                           |                                           교과서 속 과학 여행                                           |
| :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/f49bcdeb-f8de-4ea2-848a-e80781411f5d" width="200"> | <img src="https://github.com/user-attachments/assets/296b2a60-0a68-4398-84ff-2ba73809daae" width="200"> | <img src="https://github.com/user-attachments/assets/b3eaf75e-d2a0-43aa-91d7-a4142289697d" width="200"> | <img src="https://github.com/user-attachments/assets/34b162c4-1b96-4ac8-baa0-6da2cd441468" width="200"> |

|                                              방문한 관광지                                              |                                                잠금 화면                                                |                                             백그라운드 재생                                             |
| :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/32adebd5-2992-4ad2-8c45-70f1d3fd02dc" width="200"> | <img src="https://github.com/user-attachments/assets/99403720-bbd2-4e9a-a229-b2fabbff7794" width="200"> | <img src="https://github.com/user-attachments/assets/559e4aec-935c-4a02-882b-1b32f11ff4a1" width="200"> |

<br /><br />

## 개발 도구 및 활용 기술

- 개발 언어 : Swift
- 개발 환경 : XCode 16.4, iOS 17.0, iPhone SE3 ~ iPhone 16 Pro, 다크모드 지원
- 일정 관리 : Notion
- 기획/디자인 : Figma
- 프로젝트 이슈 관리 : GitHub
- 실시간 커뮤니케이션 : Discord
- 디자인 패턴 : MVVM
- 활용한 기술
  - SwiftData
  - Tuist
  - Combine
  - KaKaoMapSDK
  - AVFoundation
    <br /><br />

![Platform](https://img.shields.io/badge/Platforms-iOS%2017.0+-007AFF?logo=apple) ![Framework](https://img.shields.io/badge/Framework-Xcode%2016.2+-0047AB?logo=apple) ![Swift](https://img.shields.io/badge/Swift-6.0-F05138?logo=swift)

<img src="https://img.shields.io/badge/Figma-F24E1E?style=flat-square&logo=Figma&logoColor=white"/>
<img src="https://img.shields.io/badge/Notion-000000?style=flat-square&logo=Notion&logoColor=white"/>
<img src="https://img.shields.io/badge/Discord-5865F2?style=flat-square&logo=Discord&logoColor=white"/>/tn/
<img src="https://img.shields.io/badge/Git-F05032?style=flat-square&logo=Git&logoColor=white"/>
<img src="https://img.shields.io/badge/Github-181717?style=flat-square&logo=Github&logoColor=white"/>
<img src="https://img.shields.io/badge/카카오-FFCD00?style=flat-square&logo=카카오&logoColor=white"/>

<br /><br />

# 🧑🏻‍💻Team Members

|                                                        김태건                                                        |                                                        박세라                                                        |                                                        김용해                                                        |                                                        최하진                                                        |
| :------------------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/73dec387-ff6d-4da9-8484-de5108dcf095" alt="김태건" width="150"> | <img src="https://github.com/user-attachments/assets/d03792e7-ec24-4f76-88f6-82088c250a5e" alt="박세라" width="150"> | <img src="https://github.com/user-attachments/assets/4d1ea315-c734-4db6-aeb5-23e011d31192" alt="김용해" width="150"> | <img src="https://github.com/user-attachments/assets/4780a228-a67c-4247-b3f6-742c768c881d" alt="최하진" width="150"> |
|                                                        PM,IOS                                                        |                                                         iOS                                                          |                                                         iOS                                                          |                                                         iOS                                                          |
|                                        [GitHub](https://github.com/ktg-tfot)                                         |                                       [GitHub](https://github.com/hiereit-dev)                                       |                                        [GitHub](https://github.com/Kimyonhae)                                        |                                        [GitHub](https://github.com/hajinCHOI)                                        |
