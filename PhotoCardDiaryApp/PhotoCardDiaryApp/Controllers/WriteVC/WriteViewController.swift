//
//  WriteViewController.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/12.
//

import UIKit
import PhotosUI

class WriteViewController: UIViewController {
    
    // MARK: - Property

    private let writeView = WriteView()
    var photoData: PhotoCardData?
    let photoManager = CoreDataManager.shared
    
    
    // MARK: - LifeCycle
    
    override func loadView() {
        view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonAction()
        setupTapGestures()
    }
}

// MARK: - SetUI , Method

extension WriteViewController {
    
    private func setupButtonAction() {
        writeView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        writeView.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
      }
    
    private func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        writeView.mainImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func addButtonTapped() {
        if let photoData = self.photoData {
            // 텍스트뷰에 저장되어 있는 메세지
            photoData.memoText = writeView.memoTextView.text
            photoData.title = writeView.titleLabel.text
            photoData.image = writeView.mainImageView.image?.pngData()
            photoManager.updatePhotoCardData(newPhotoData: photoData) {
                print("업데이트 완료")
                self.dismiss(animated: true)
            }
        } else {
            let memoText = writeView.memoTextView.text
            let title = writeView.titleLabel.text
            let image = writeView.mainImageView.image?.pngData()
            photoManager.savePhotoCardData(title: memoText, memoText: title, image: image) {
                print("저장완료")
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc private func touchUpImageView() {
        print(#function)
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}

extension WriteViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        var newImage: UIImage? = nil
        
        if let updateImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = updateImage
        } else if let updateImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            newImage = updateImage
        }
        
        self.writeView.mainImageView.image = newImage
        self.writeView.addButton.isEnabled = true
        picker.dismiss(animated: true, completion: nil)
    }
}
