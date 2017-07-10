//
//  Dictionary+ReadData.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/23.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func readBool(_ key: String, defaultValue: Bool! = false) -> Bool! {
        if let dic = self as? Dictionary<String, Any> {
            if dic.keys.contains(key) {
                
                if dic[key] is Int {
                    return (dic[key] as! Int != 0)
                } else if dic[key] is NSNumber {
                    return (dic[key] as! NSNumber).boolValue
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
                
                if dic[key] is Int {
                    return dic[key] as! Int
                } else if dic[key] is NSNumber {
                    return (dic[key] as! NSNumber).intValue
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
                
                if dic[key] is Int64 {
                    return dic[key] as! Int64
                } else if dic[key] is NSNumber {
                    return (dic[key] as! NSNumber).int64Value
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
                
                if dic[key] is Float {
                    return dic[key] as! Float
                } else if dic[key] is NSNumber {
                    return (dic[key] as! NSNumber).floatValue
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
                
                if dic[key] is Double {
                    return dic[key] as! Double
                } else if dic[key] is NSNumber {
                    return (dic[key] as! NSNumber).doubleValue
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
                
                if dic[key] is String {
                    return dic[key] as! String
                } else if dic[key] is NSString {
                    return dic[key] as! String
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
                
                if dic[key] is NSArray {
                    return dic[key] as! Array<Any>
                } else if dic[key] is Array<Any> {
                    return dic[key] as! Array<Any>
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
                
                if dic[key] is NSDictionary {
                    return dic[key] as! Dictionary<String, Any>
                } else if dic[key] is Dictionary<String, Any> {
                    return dic[key] as! Dictionary<String, Any>
                }
                
                return defaultValue
            }
            
            return defaultValue
        }
        
        return defaultValue
    }
    
}
