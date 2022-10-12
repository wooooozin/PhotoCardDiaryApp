//
//  WriteViewController.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/12.
//

import UIKit

class WriteViewController: UIViewController {

    private let writeView = WriteView()
    
    
    override func loadView() {
        view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
