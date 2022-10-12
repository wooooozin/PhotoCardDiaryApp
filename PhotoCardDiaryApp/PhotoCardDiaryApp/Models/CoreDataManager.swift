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
    
    func getPhotoListFromCoreData() -> [PhotoCardData] {
        var photoList: [PhotoCardData] = []
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            let dateOrder = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [dateOrder]
            
            do {
                if let fetchedPhotoCardData = try context.fetch(request) as? [PhotoCardData] {
                    photoList = fetchedPhotoCardData
                }
            } catch {
                print("코어데이터 불러 오기 실패")
            }
        }
        return photoList
    }
    
    func savePhotoCardData(
        title: String?,
        memoText: String?,
        image: Data?,
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
    
    func deleteToDo(data: PhotoCardData, completion: @escaping () -> Void) {
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
    
    func updateToDo(newPhotoData: PhotoCardData, completion: @escaping () -> Void) {
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
