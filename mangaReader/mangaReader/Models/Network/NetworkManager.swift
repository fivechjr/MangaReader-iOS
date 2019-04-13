//
//  NetworkManager.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/10.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import Alamofire

public typealias NetworkCompletion<T: Codable> = (T?, Error?) -> Void
public typealias ProgressHandler = (Double) -> Void

class NetworkManager {
    
    private static var sessionManager: SessionManager = {
        let sm = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        sm.adapter = CustomRequestAdapter()
        return sm
    }()
    
    static func get<T: Codable>(urlString: String?, responseType: T.Type, completion: @escaping NetworkCompletion<T>) {
        get(urlString: urlString, responseType: responseType, onProgress: nil, completion: completion)
    }
    
    static func get<T: Codable>(urlString: String?, responseType: T.Type, onProgress: ProgressHandler?, completion: @escaping NetworkCompletion<T>) {
        guard let urlString = self.safeUrlString(urlString), let url = URL(string: urlString) else {return}
        sessionManager.request(url)
            .downloadProgress(closure: { (progress) in
                onProgress?(progress.fractionCompleted)
            })
            .responseData { (response) in
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
    
    static func post<T: Codable>(urlString: String?, parameters: Parameters? = nil, responseType: T.Type, completion: @escaping NetworkCompletion<T>) {
        guard let urlString = urlString, let url = URL(string: urlString) else {return}
        sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { (response) in
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
    
    private static func safeUrlString(_ urlString: String?) -> String? {
        let allowedCharacterSet = CharacterSet(charactersIn: " ").inverted
        guard let safeUrlString = urlString?.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) else {return nil}
        return safeUrlString
    }
}
