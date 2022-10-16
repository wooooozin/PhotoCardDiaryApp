//
//  PhotoModel.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/17.
//

import UIKit

struct PhotoModel {
    var title: String?
    var date: String?
    var memoText: String?
    var image: UIImage?
    var weather: Data?
    
    var coreData: PhotoCardData?
}
