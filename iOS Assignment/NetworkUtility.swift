//
//  NetworkUtility.swift
//  iOS Assignment
//
//  Created by Swarandeep on 12/05/24.
//

import Foundation


func fetchData<T: Decodable>(url: String, completion: @escaping (T) -> ()) {
    DispatchQueue.global().async {
        if let url = URL(string: url) {
            let task = URLSession.shared.dataTask(with: url) { data, urlResponse, error in
                if let error = error {
                    print("Error with fetching \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        let contentData = try JSONDecoder().decode(T.self, from: data)
                        DispatchQueue.main.async {
                            completion(contentData)
                        }
                    } catch {
                        print("Error while decoding \(error)")
                    }
                }
            }
            task.resume()
        }
    }
}
