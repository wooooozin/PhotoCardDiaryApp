//
//  NetworkManager.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/14.
//

import UIKit
import CoreLocation

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    func fetchWeather(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        completion: @escaping (Result<WeatherData, NetworkError>) -> Void
    ) {
        let urlString = "\(WeatherApi.requestUrl)&lat=\(latitude)&lon=\(longitude)"
        print(urlString)
        
        performRequest(with: urlString) { result in
            completion(result)
        }
    }
    
    private func performRequest(
        with urlString: String,
        completion: @escaping (Result<WeatherData, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            if let weathers = self.parseJSON(safeData) {
                print("Parse 실행")
                completion(.success(weathers))
            } else {
                print("Parse 실패")
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    private func parseJSON(_ weatherData: Data) -> WeatherData? {
        do {
            let parseData = try JSONDecoder().decode(WeatherData.self, from: weatherData)
            print(parseData)
            return parseData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
