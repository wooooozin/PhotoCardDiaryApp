//
//  EditViewController.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/13.
//

import UIKit
import CoreData

final class EditViewController: UIViewController {
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
        configureUIwithData()
    }
}

// MARK: - SetUI , Method

extension EditViewController {
    
    private func setupButtonAction() {
        writeView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        writeView.addButton.isEnabled = true
        writeView.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        writeView.mainImageView.addGestureRecognizer(tapGesture)
    }
    
    private func configureUIwithData() {
        guard let data = photoData?.image else { return }
        writeView.mainImageView.image = UIImage(data: data)
        writeView.memoTextView.text = photoData?.memoText
        writeView.titleTextField.text = photoData?.title
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func addButtonTapped() {
        if let photoData = self.photoData {
            photoData.memoText = writeView.memoTextView.text
            photoData.title = writeView.titleTextField.text
            photoData.image = writeView.mainImageView.image?.pngData()
            photoManager.updatePhotoCardData(newPhotoData: photoData) {
                print("업데이트 완료")
                self.dismiss(animated: true) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
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

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension EditViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
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
        picker.dismiss(animated: true, completion: nil)
    }
}
