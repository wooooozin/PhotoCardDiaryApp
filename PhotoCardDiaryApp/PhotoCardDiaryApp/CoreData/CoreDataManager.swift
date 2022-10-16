//
//  CoreDataManager.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/12.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() { }
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    let modelName: String = "PhotoCardData"
    
    func searchDatePhotoListFromCoreData(date: Date) -> [PhotoModel] {
        var photoList: [PhotoCardData] = []
        var photoModel: [PhotoModel] = []
        let request: NSFetchRequest<PhotoCardData> = PhotoCardData.fetchRequest()
        request.predicate = NSPredicate(
            format: "date >= %@ && date <= %@",
            Calendar.current.startOfDay(for: date) as CVarArg,
            Calendar.current.startOfDay(for: date + 86400) as CVarArg
        )
        
        do{
            let objects = try context?.fetch(request)
            photoList = objects ?? []
            photoList.forEach {
                photoModel.append(
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
        } catch {
            print(error)
        }
        return photoModel
    }
    
    func searchPhotoListFromCoreData(text: String) -> [PhotoModel] {
        var photoList: [PhotoCardData] = []
        var photoModel: [PhotoModel] = []
        let query = text
        let request: NSFetchRequest<PhotoCardData> = PhotoCardData.fetchRequest()
        request.predicate = NSPredicate(format: "memoText CONTAINS %@", query)
            do{
                let objects = try self.context?.fetch(request)
                photoList = objects ?? []
                photoList.forEach {
                    photoModel.append(
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
            } catch {
                print(error)
            }
        
            return photoModel
    }
    
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
    
    func savePhotoCardData(
        title: String?,
        memoText: String?,
        image: Data?,
        weather: Data?,
        completion: @escaping () -> Void
    ) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                if let photoCardData = NSManagedObject(
                    entity: entity,
                    insertInto: context
                ) as? PhotoCardData {
                    photoCardData.title = title
                    photoCardData.memoText = memoText
                    photoCardData.date = Date()
                    photoCardData.image = image
                    photoCardData.weather = weather
                    
                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print(error)
                            completion()
                        }
                    }
                }
            }
        }
        completion()
    }
    
    func deletePhotoCardData(data: PhotoCardData, completion: @escaping () -> Void) {
        guard let date = data.date else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            do {
                if let fetchedPhotoList = try context.fetch(request) as? [PhotoCardData] {
                    if let targetData = fetchedPhotoList.first {
                        context.delete(targetData)
                        
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("삭제 실패")
                completion()
            }
        }
    }
    
    func updatePhotoCardData(newPhotoData: PhotoCardData, completion: @escaping () -> Void) {
        guard let date = newPhotoData.date else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            
            do {
                if let fetchedPhotoList = try context.fetch(request) as? [PhotoCardData] {
                    if var targetData = fetchedPhotoList.first {
                        targetData = newPhotoData
                        
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("업데이트 실패")
                completion()
            }
        }
    }
}
