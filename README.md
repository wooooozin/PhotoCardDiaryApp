
# ๐ฅ ํ๋ก์ ํธ ์๊ฐ
| <center>์๊ฐ์ ์๊ฐ</center> |
| --------------------------------------------------------- |
| ![playstore](https://user-images.githubusercontent.com/95316662/196094021-f92fdb57-a51f-47c4-9584-b26d1e82d63e.png)| 
<br>

### **์ ํ๋ฆฌ์ผ์ด์ ์ค๋ช**
- CoreData๋ฅผ ํ์ฉํด ํฌํ ์นด๋ ํํ๋ก ๋ค์ด์ด๋ฆฌ ์์ฑ์ด ๊ฐ๋ฅํ ์ฑ์๋๋ค.
- ์ฌ์ฉ์ ์์น ์ ๋ณด๋ฅผ ๊ธฐ๋ฐ์ผ๋ก ๋ฉ์ธ ํฌํ ์นด๋์ ๋ ์จ ์์ด์ฝ์ด ์ถ๊ฐ ๋ฉ๋๋ค.
- ์ถ์ต ๋ฐ ์ต์  ๊ฐ ์ Long PressGeture ์ ์์  ๋ฐ ์ญ์ ๊ฐ ๊ฐ๋ฅํฉ๋๋ค.
- ์ํ๋ ๋ฐ์ดํฐ๋ ์บ๋ฆฐ๋ ๋ทฐ๋ฅผ ์ด์ฉํด ์ผ์๋ณ๋ก ํ์ธ ๊ฐ๋ฅํฉ๋๋ค.
- ์ํ๋ ๋ฐ์ดํฐ๋ ๋ณธ๋ฌธ ๋ด์ฉ ํ์คํธ ๊ธฐ๋ฐ์ผ๋ก ๊ฒ์ ๊ฐ๋ฅํฉ๋๋ค.
<br>

### ์คํ ํ๋ฉด
| <center> ์ฑ ์ง์/๋น ํ๋ฉด </center> | <center> ๋ฆฌ์คํธ ๋ฐ ๊ฒ์ </center> | <center> ์๋ก๋ ๋ฐ ์ ์ฅ </center> | <center> ์์  </center> | <center> ์ญ์  </center> |  <center> ์ผ๋ณ๋ก ๋ณด๊ธฐ </center> |
| ----------------------------------- | ---------------------------------| ------------------------------ | ------------------------------- | ------------------------------- | ------------------------------- |
|![empty](https://user-images.githubusercontent.com/95316662/196095658-59e48615-b920-4ebf-84f8-699592ba6ce5.gif)|![list](https://user-images.githubusercontent.com/95316662/196097801-bd3bdc7a-4b6f-4ad8-8e3a-7a4732ec7879.gif)|![create](https://user-images.githubusercontent.com/95316662/196095646-8954e593-fe59-41d8-a269-e927043009d4.gif)|![update](https://user-images.githubusercontent.com/95316662/196095642-15da0ab9-d3ba-41f8-8c03-be027b6120c2.gif)|!![delete](https://user-images.githubusercontent.com/95316662/196097242-1867e805-d8f5-41c9-b264-271225e6efd4.gif)|![calendar](https://user-images.githubusercontent.com/95316662/196095650-89ee1dd9-233f-40f4-90f8-08578c426813.gif)|




<br>


# โฑ๏ธ ๊ฐ๋ฐ ๊ธฐ๊ฐ ๋ฐ ์ฌ์ฉ ๊ธฐ์ 
- ๊ฐ๋ฐ ๊ธฐ๊ฐ: 2022.10.11 ~ 2022.10.17
- ์ฌ์ฉ ๊ธฐ์  ๋ฐ ๋ผ์ด๋ธ๋ฌ๋ฆฌ:  `UIKit`, `URLSession`, `MVC`, `CoreData`, `VerticalCardSwiper`, `FSCalendar`
<br>

# ๐ฆ ์ด์
- ํ๋ฉด ํผํฌ๋จผ์ค ์ ํ

  - ์ฝ์ด๋ฐ์ดํฐ๋ฅผ ๋ถ๋ฌ์ค๋ ๊ณผ์ ์ ๋น๋๊ธฐ ๋ฐฉ์์ผ๋ก ๋ณ๊ฒฝํ๊ณ  ์๋ก์ด ๋ชจ๋ธ ์ธ์คํด์ค๋ฅผ ์์ฑํด ๋ถ๋ฌ์ค๋ ๊ฒ์ผ๋ก ๋ณ๊ฒฝ
  - ์ด๋ฏธ์ง๋ฅผ ๋ฆฌ์ฌ์ด์งํ์ฌ Cell์ ํ์๋  ์ ์๋๋ก ๋ณ๊ฒฝ


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
                    print("์ฝ์ด๋ฐ์ดํฐ ๋ถ๋ฌ ์ค๊ธฐ ์คํจ")
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

