//
//  NetworkManager.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/10.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    static func get<T>(urlString: String?, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) where T: Codable {
        guard let urlString = urlString, let url = URL(string: urlString) else {return}
        Alamofire.request(url).responseData { (response) in
            guard let data = response.result.value else {
                completion(nil, response.result.error)
                return
            }
            
            do {
                let object = try JSONDecoder().decode(responseType, from: data)
                completion(object, nil)
            } catch let error {
                completion(nil, error)
            }
        }
    }
    
    static func post<T>(urlString: String?, parameters: Parameters? = nil, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) where T: Codable {
        guard let urlString = urlString, let url = URL(string: urlString) else {return}
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { (response) in
            guard let data = response.result.value else {
                completion(nil, response.result.error)
                return
            }
            
            do {
                let object = try JSONDecoder().decode(responseType, from: data)
                completion(object, nil)
            } catch let error {
                completion(nil, error)
            }
        }
    }
}
