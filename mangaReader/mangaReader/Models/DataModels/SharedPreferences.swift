//
//  SharedPreferences.swift
//  mangaReader
//
//  Created by Yiming Dong on 29/10/18.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class SharedPreferences {
    
    private init() {}
    
    static let shared = SharedPreferences()
    
    fileprivate let cacheKeyPrefix = "manga_monster_cached_"
    
    fileprivate func cachedName(forKey key: String) -> String {
        return "\(cacheKeyPrefix)\(key)"
    }
    
    func save<T>(object: T, forKey key: String) where T: Encodable {
        let cacheKey = cachedName(forKey: key)
        if let value = object as? String {
            UserDefaults.standard.set(value, forKey: cacheKey)
        } else if let value = object as? Int {
            UserDefaults.standard.set(value, forKey: cacheKey)
        } else if let value = object as? Double {
            UserDefaults.standard.set(value, forKey: cacheKey)
        } else if let value = object as? Float {
            UserDefaults.standard.set(value, forKey: cacheKey)
        } else if let value = object as? URL {
            UserDefaults.standard.set(value, forKey: cacheKey)
        } else if let value = object as? Bool {
            UserDefaults.standard.set(value, forKey: cacheKey)
        } else if let value = object as? Decimal {
            UserDefaults.standard.set(value, forKey: cacheKey)
        } else {
            guard let encodedData = try? JSONEncoder().encode(object), let encodeString = String(data: encodedData, encoding: .utf8) else {
                UserDefaults.standard.set(nil, forKey: cacheKey)
                return
            }
            
            UserDefaults.standard.set(encodeString, forKey: cacheKey)
        }
        
    }
    
    func load<T>(forKey key: String, ofType type: T.Type) -> T? where T: Decodable {
        let cacheKey = cachedName(forKey: key)
        if type == String.self {
            return UserDefaults.standard.string(forKey: cacheKey) as? T
        }
        if type == Bool.self {
            return UserDefaults.standard.bool(forKey: cacheKey) as? T
        }
        if type == Double.self {
            return UserDefaults.standard.double(forKey: cacheKey) as? T
        }
        if type == Float.self {
            return UserDefaults.standard.float(forKey: cacheKey) as? T
        }
        if type == URL.self {
            return UserDefaults.standard.url(forKey: cacheKey) as? T
        }
        if type == Int.self {
            return UserDefaults.standard.integer(forKey: cacheKey) as? T
        }
        
        guard let encodedString = UserDefaults.standard.value(forKey: cacheKey) as? String, let data = encodedString.data(using: .utf8) else {
            return nil
        }
        
        var object: T?
        do {
            object  = try JSONDecoder().decode(type, from: data)
        } catch let error {
            print(error)
            return nil
        }
        
        return object
    }
    
    func removeObject(forKey key: String) {
        let cachedKey = cachedName(forKey: key)
        UserDefaults.standard.removeObject(forKey: cachedKey)
        UserDefaults.standard.synchronize()
    }
}
