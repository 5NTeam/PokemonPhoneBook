//
//  DataFetched.swift
//  PokemonPhoneBook
//
//  Created by 장상경 on 12/11/24.
//

import UIKit

// API 통신을 담당하는 프로토콜
protocol DataFetched {
    
    func fetchData<T: Decodable>(_ completion: @escaping (T?) -> Void)
    
}

extension DataFetched {
    /// 서버에서 데이터를 받아오는 메소드
    /// - Parameter completion: 받아온 데이터를 디코딩하고 클로저에 전달
    func fetchData<T: Decodable>(_ completion: @escaping (T?) -> Void) {
        let randomNumber = Int.random(in: 1...1000)
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(randomNumber)") else {
            print("잘못된 URL 입니다")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data, error == nil else {
                print("잘못된 호출입니다.")
                completion(nil)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                
                let successRange: Range = 200..<300
                guard successRange.contains(response.statusCode) else {
                    print("데이터 요청 실패")
                    completion(nil)
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    print("디코딩 성공")
                    completion(decodedData)
                    return
                } catch {
                    print(error)
                    completion(nil)
                }
                
            } else {
                print("http 요청 실패")
                completion(nil)
            }
        }.resume()
    }
}
