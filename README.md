![Image](https://github.com/user-attachments/assets/16334b0d-36fd-4a25-bdc7-6045b285806b)
<br /><br />

# About 소담<img src="https://github.com/user-attachments/assets/46692dd8-448e-4a55-b689-8d078aa6f765" align=left width=100>

소담은 위치 기반 음성 안내 기능을 통해 사용자에게 특정 장소의 정보를 제공함으로써
편리하고 깊이있는 경험을 제공하는 오디오 가이드 앱입니다

<br /><br />

## 자기 소개

![소담](https://github.com/user-attachments/assets/63f7a4b5-439b-41b3-9368-d95fde3fca99)

<br /><br />

## Git & Foldering Convention

![git](https://github.com/user-attachments/assets/659b52c0-c169-4c40-8dfb-f0b02ad835df)

<br /><br />

<pre lang="markdown"> <code> 
📱 SODAM
┃
┣ 📂 Configurations
┃	┃ ┣ ⚙️ config.xcconfig
┃
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
┃   ┃ ┃ ┃ ┣📄 GalleryItem
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
┃   ┃ ┃ ┃ ┣📄 DetailViewModel  
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
| :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/72ed6d54-6c0d-40d3-a089-054756abf39f" width="200"> | <img src="https://github.com/user-attachments/assets/d46e6a15-9d9f-47bd-abb1-50430cba9908" width="200"> | <img src="https://github.com/user-attachments/assets/50a0b395-229a-4ddd-8e16-93530c6e703c" width="200"> |

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

<br /><br />

## 개발 도구 및 활용 기술

- 개발 언어 : Swift
- 개발 환경 : XCode 16.4, iOS 18.5, SE3 ~ iPhone 16 Pro, 다크모드 지원
- 일정/투두관리 : Notion
- 기획/디자인 : Figma
- 프로젝트 이슈 관리 : GitHub
- 실시간 커뮤니케이션 : Discord
- 활용한 기술
  - SwiftData
  - Tuist
  - Combine
  - KaKaoMapSDK,  
    <br /><br />
