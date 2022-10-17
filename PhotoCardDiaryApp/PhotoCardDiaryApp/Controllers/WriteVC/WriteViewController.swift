//
//  WriteViewController.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/12.
//

import UIKit
import PhotosUI
import CoreLocation

final class WriteViewController: UIViewController {
    
    // MARK: - Property
    
    private let writeView = WriteView()
    
    var photoData: PhotoCardData?
    let photoManager = CoreDataManager.shared
    let weatherMager = NetworkManager.shared
    let locationManager = CLLocationManager()
    var weatherImageInt = 0
    var weatherImageString = ""
    var addAlertControl: () -> Void = { }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonAction()
        setupTapGestures()
        setupLocation()
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
    
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        writeView.mainImageView.addGestureRecognizer(tapGesture)
    }
    
    func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    
    private func weatherIntString(_ weatherId: Int) -> String {
        switch weatherId {
        case 200...232:
            return Icon.bolt
        case 300...321:
            return Icon.drizzle
        case 500...531:
            return Icon.rain
        case 600...622:
            return Icon.snow
        case 701...781:
            return Icon.fog
        case 800:
            return Icon.sunMax
        case 801...804:
            return Icon.bolt
        default:
            return Icon.sunMin
        }
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func addButtonTapped() {
        weatherImageString = weatherIntString(weatherImageInt)
        let memoText = writeView.memoTextView.text
        let title = writeView.titleTextField.text
        let fixImage = fixOrientation(img: writeView.mainImageView.image ?? UIImage())
        let image = fixImage.pngData()
        var weather = UIImage().pngData()
        guard let safeWeather = UIImage(
            systemName: weatherImageString)?.withTintColor(.white).pngData() else {
            return weather = UIImage(systemName: Icon.sunMin)?.withTintColor(.white).pngData()
        }
        weather = safeWeather
        photoManager.savePhotoCardData(
            title: title,
            memoText: memoText,
            image: image,
            weather: weather
        ) {
            self.dismiss(animated: true) {
                self.navigationController?.popToRootViewController(animated: true)
                self.addAlertControl()
            }
        }
    }
    
    @objc private func touchUpImageView() {
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
        
        if let updateImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = updateImage
        } else if let updateImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            newImage = updateImage
        }
        
        self.writeView.addButton.isEnabled = true
        self.writeView.mainImageView.image = newImage
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate

extension WriteViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherMager.fetchWeather(latitude: lat, longitude: lon) { result in
                switch result {
                case .success(let result):
                    self.weatherImageInt = result.weather[0].id
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

