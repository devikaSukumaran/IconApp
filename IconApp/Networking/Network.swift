//
//  Network.swift
//  IconApp
//
//  Created by Devika Sukumaran on 18/05/2021.
//

import Foundation

protocol DataFetchable {
    func fetch(from url : String, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

final class Network : DataFetchable {
    func fetch(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            guard let data = data else {
                completion(.failure(.failedToFetch))
                return
            }
            
            if error == nil {
                completion(.success(data))
            }else {
                completion(.failure(.failedToFetch))
            }
        }
        task.resume()
    }
}


