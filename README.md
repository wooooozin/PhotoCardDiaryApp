
# 🖥 프로젝트 소개
| <center>순간의 순간</center> |
| --------------------------------------------------------- |
| ![playstore](https://user-images.githubusercontent.com/95316662/196094021-f92fdb57-a51f-47c4-9584-b26d1e82d63e.png)| 
<br>

### **애플리케이션 설명**
- CoreData를 활용해 포토카드 형태로 다이어리 작성이 가능한 앱입니다.
- 사용자 위치 정보를 기반으로 메인 포토카드에 날씨 아이콘이 추가 됩니다.
- 추억 및 최신 각 셀 Long PressGeture 시 수정 및 삭제가 가능합니다.
- 원하는 데이터는 캘린더 뷰를 이용해 일자별로 확인 가능합니다.
- 원하는 데이터는 본문 내용 텍스트 기반으로 검색 가능합니다.
<br>

### 실행 화면
| <center> 앱 진입/빈 화면 </center> | <center> 리스트 및 검색 </center> | <center> 업로드 및 저장 </center> | <center> 수정 </center> | <center> 삭제 </center> |  <center> 일별로 보기 </center> |
| ----------------------------------- | ---------------------------------| ------------------------------ | ------------------------------- | ------------------------------- | ------------------------------- |
|![empty](https://user-images.githubusercontent.com/95316662/196095658-59e48615-b920-4ebf-84f8-699592ba6ce5.gif)|![list](https://user-images.githubusercontent.com/95316662/196097801-bd3bdc7a-4b6f-4ad8-8e3a-7a4732ec7879.gif)|![create](https://user-images.githubusercontent.com/95316662/196095646-8954e593-fe59-41d8-a269-e927043009d4.gif)|![update](https://user-images.githubusercontent.com/95316662/196095642-15da0ab9-d3ba-41f8-8c03-be027b6120c2.gif)|!![delete](https://user-images.githubusercontent.com/95316662/196097242-1867e805-d8f5-41c9-b264-271225e6efd4.gif)|![calendar](https://user-images.githubusercontent.com/95316662/196095650-89ee1dd9-233f-40f4-90f8-08578c426813.gif)|




<br>


# ⏱️ 개발 기간 및 사용 기술
- 개발 기간: 2022.10.11 ~ 2022.10.17
- 사용 기술 및 라이브러리:  `UIKit`, `URLSession`, `MVC`, `CoreData`, `VerticalCardSwiper`, `FSCalendar`
<br>

# 🦊 이슈
- 화면 퍼포먼스 저하

  - 코어데이터를 불러오는 과정을 비동기 방식으로 변경하고 새로운 모델 인스턴스를 생성해 불러오는 것으로 변경
  - 이미지를 리사이징하여 Cell에 표시될 수 있도록 변경


```swift
// CoreDataManager
func getPhotoListFromCoreData(complition: (([PhotoModel]) -> Void)?) {
        var photoList: [PhotoModel] = []
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            let dateOrder = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [dateOrder]
            DispatchQueue.global().async {
                do {
                    if let fetchedPhotoCardData = try context.fetch(request) as? [PhotoCardData] {
                        fetchedPhotoCardData.forEach {
                            photoList.append(
                                PhotoModel(
                                    title: $0.title,
                                    date: $0.dateString,
                                    memoText: $0.memoText,
                                    image: $0.dataImage,
                                    weather: $0.weather,
                                    coreData: $0
                                )
                            )
                        }
                        complition?(photoList)
                        
                    }
                } catch {
                    print("코어데이터 불러 오기 실패")
                    complition?([])
                }
            }
        }
    }
    
// PhotoModel
struct PhotoModel {
    var title: String?
    var date: String?
    var memoText: String?
    var image: UIImage?
    var weather: Data?
    
    var coreData: PhotoCardData?
}
```
<br>

```swift
extension PhotoCardData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoCardData> {
        return NSFetchRequest<PhotoCardData>(entityName: "PhotoCardData")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var memoText: String?
    @NSManaged public var image: Data?
    @NSManaged public var weather: Data?
    
    var dateString: String? {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = self.date else { return "" }
        let savedDateString = myFormatter.string(from: date)
        return savedDateString
    }
    
    var dataImage: UIImage? {
        guard let image = self.image else { return UIImage() }
        let cellImage = UIImage(data: image)?.resize(newWidth: 250)
        return cellImage
    }
}
```
<br>

