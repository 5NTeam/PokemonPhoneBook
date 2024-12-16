//
//  PokeAPIManager.swift
//  PokemonPhoneBook
//
//  Created by 내일배움캠프 on 12/11/24.
//

import UIKit
import Alamofire

class PokeAPIManager {
    static let shared = PokeAPIManager()
    
    private init() {}
    
    func fetchPokemonData<T: Decodable>(url: URL, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    func fetchImage(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(NSError(domain: "PokeAPIManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
