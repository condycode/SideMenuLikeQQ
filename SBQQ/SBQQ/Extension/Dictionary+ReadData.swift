//
//  Dictionary+ReadData.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/23.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import Foundation

extension Dictionary where Dictionary.Key == String {
    func read<T>(_ key: String, defaultValue: T) -> T {
        if keys.contains(key) {
            if let value = self[key] as? T {
                return value
            }
        }
        return defaultValue
    }
}

extension Dictionary {
    
    func readBool(_ key: String, defaultValue: Bool! = false) -> Bool! {
        if let dic = self as? Dictionary<String, Any> {
            if dic.keys.contains(key) {
                
                if let value = dic[key] as? Bool {
                    return value
                } else if let value = dic[key] as? Int {
                    return (value != 0)
                } else if let value = dic[key] as? NSNumber {
                    return value.boolValue
                } else if let value = dic[key] as? String, let v = Int(value) {
                    return v != 0
                }
                
                return defaultValue
            }
            
            return defaultValue
        }
        
        return defaultValue
    }
    
    
    func readInt(_ key: String, defaultValue: Int! = 0) -> Int! {
        if let dic = self as? Dictionary<String, Any> {
            if dic.keys.contains(key) {
                
                if let value = dic[key] as? Int {
                    return value
                } else if let value = dic[key] as? NSNumber {
                    return value.intValue
                }
                
                return defaultValue
            }
            
            return defaultValue
        }
        
        return defaultValue
    }
    
    func readInt64(_ key: String, defaultValue: Int64! = 0) -> Int64! {
        if let dic = self as? Dictionary<String, Any> {
            if dic.keys.contains(key) {
                
                if let value = dic[key] as? Int64 {
                    return value
                } else if let value = dic[key] as? NSNumber {
                    return value.int64Value
                }
                
                return defaultValue
            }
            
            return defaultValue
        }
        
        return defaultValue
    }
    
    func readFloat(_ key: String, defaultValue: Float! = 0) -> Float! {
        if let dic = self as? Dictionary<String, Any> {
            if dic.keys.contains(key) {
                
                if let value = dic[key] as? Float {
                    return value
                } else if let value = dic[key] as? NSNumber {
                    return value.floatValue
                }
                
                return defaultValue
            }
            
            return defaultValue
        }
        
        return defaultValue
    }
    
    func readDouble(_ key: String, defaultValue: Double! = 0) -> Double! {
        if let dic = self as? Dictionary<String, Any> {
            if dic.keys.contains(key) {
                
                if let value = dic[key] as? Double {
                    return value
                } else if let value = dic[key] as? NSNumber {
                    return value.doubleValue
                }
                
                return defaultValue
            }
            
            return defaultValue
        }
        
        return defaultValue
    }
    
    
    
    func readString(_ key: String, defaultValue: String! = "") -> String! {
        if let dic = self as? Dictionary<String, Any> {
            if dic.keys.contains(key) {
                
                if let value = dic[key] as? String {
                    return value
                } else if let value = dic[key] as? NSString {
                    return value as String
                }
                
                return defaultValue
            }
            
            return defaultValue
        }
        
        return defaultValue
    }
    
    func readArray(_ key: String, defaultValue: Array<Any>! = Array<Any>()) -> Array<Any>! {
        if let dic = self as? Dictionary<String, Any> {
            if dic.keys.contains(key) {
                
                if let value = dic[key] as? NSArray, let v = value as? Array<Any> {
                    return v
                } else if let value = dic[key] as? Array<Any> {
                    return value
                }
                
                return defaultValue
            }
            
            return defaultValue
        }
        
        return defaultValue
    }
    
    func readDic(_ key: String, defaultValue: Dictionary<String, Any>! = Dictionary<String, Any>()) -> Dictionary<String, Any>! {
        if let dic = self as? Dictionary<String, Any> {
            if dic.keys.contains(key) {
                
                if let value = dic[key] as? NSDictionary, let v = value as? Dictionary<String, Any> {
                    return v
                } else if let value = dic[key] as? Dictionary<String, Any> {
                    return value
                }
                
                return defaultValue
            }
            
            return defaultValue
        }
        
        return defaultValue
    }
    
}
