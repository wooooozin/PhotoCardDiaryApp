//
//  WriteViewController.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/12.
//

import UIKit
import PhotosUI
import CoreLocation

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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - SetUI , Method

extension WriteViewController {
    
    private func setupButtonAction() {
        writeView.closeButton.addTarget(
            self,
            action: #selector(closeButtonTapped),
            for: .touchUpInside
        )
        writeView.addButton.addTarget(
            self,
            action: #selector(addButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        writeView.mainImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func addButtonTapped() {
        let memoText = writeView.memoTextView.text
        let title = writeView.titleTextField.text
        let image = writeView.mainImageView.image?.pngData()
        let weather = UIImage().pngData()
        photoManager.savePhotoCardData(title: title, memoText: memoText, image: image, weather: weather) {
            print("저장완료")
            self.dismiss(animated: true) {
                self.navigationController?.popToRootViewController(animated: true)
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
