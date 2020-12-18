//
//  PlantController.swift
//  Planty
//
//  Created by Craig Belinfante on 12/17/20.
//

import Foundation

typealias CompletionHandler = ((Result<Bool, NetworkError>) -> Void)

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noData
    case noEncode
    case noDecode
    case noToken
    case tryAgain
    case otherError
}


class PlantController {
    
    var plant: [Plant] = []
    
    let baseURL = URL(string: "https://mockplantdata.firebaseio.com/")!
    
    func getAllPlants(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let plantsArray = Array(try JSONDecoder().decode([String: Plant].self, from: data).values)
                self.plant = plantsArray
              //  try self.updatePlant(with: plantsArray)
                print(self.plant.count)
                completion(.success(true))
            } catch {
                print("Error decoding plants data: \(error)")
                completion(.failure(.tryAgain))
                return
            }
        }
        task.resume()
    }
    
    private func updatePlant(with: Plant) {
        
    }
    
    func addPlant() {
        
    }
    
    func deletePlant() {
        
    }
    
    
}

