//
//  PlantController.swift
//  Planty
//
//  Created by Craig Belinfante on 12/17/20.
//

import Foundation

typealias CompletionHandler = ((Result<Plant, NetworkError>) -> Void)

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
    
    let baseURL = URL(string: "https://planty-8839a-default-rtdb.firebaseio.com/")!
    
    private func putRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func deleteRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    //get
    func getAllPlants(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error \(error)")
                completion(.failure(.tryAgain))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                //this is what I would need to fix
                
                let jsonDecoder = JSONDecoder()
                let plantsArray = try jsonDecoder.decode(Plant.self, from: data)
                self.updatePlant(with: plantsArray)
                print(self.plant.count)
                completion(.success(plantsArray))
            } catch {
                print("Error decoding plants data: \(error)")
                completion(.failure(.tryAgain))
                return
            }
        }
        task.resume()
    }
    
    private func updatePlant(with plant: Plant, completion: @escaping CompletionHandler = { _ in}) {
        //put
        
        guard let jsonData = try? JSONEncoder().encode(plant) else {return}
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error \(error)")
                completion(.failure(.tryAgain))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let plantsArray = try jsonDecoder.decode(Plant.self, from: data)
                completion(.success(plantsArray))
            } catch {
                print("Error updating plant \(plant): \(error)")
                completion(.failure(.noData))
                return
            }
        }
        task.resume()
    }
    
    func addPlant(with plant: Plant, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        //post
        
        var request = putRequest(for: baseURL)
        
        do {
            
            let jsonData = try JSONEncoder().encode(plant)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Adding a plant was not complete: \(error)")
                    completion(.failure(.tryAgain))
                    return
                }
                guard let data = data else { return }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print("Data Error")
                    completion(.failure(.noData))
                }
                completion(.success(true))
            }
            task.resume()
        } catch {
            print("Error encoding user: \(error)")
            completion(.failure(.noEncode))
        }
    }
    
    func deletePlant(_ plant: Plant, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        var request = deleteRequest(for: baseURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            print("Delete Successful")
            completion(.success(true))
        }
        task.resume()
    }
}

