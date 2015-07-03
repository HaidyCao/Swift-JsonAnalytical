//
//  Json.swift
//  RiBao
//
//  Created by HD on 15/6/29.
//  Copyright © 2015年 Haidy. All rights reserved.
//

import Foundation

/// Json 解析
class Json {
    
    class func dataToModel(jsonData: NSData?, className: String) -> AnyObject! {
        if let data = jsonData {
            do {
                return try jsonToModel(NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers), className: className)
            } catch {
            }
        }
        return nil
    }
    
    /// json 解析到
    class func jsonToModel(dics: AnyObject?, className: String) -> AnyObject! {
        if dics == nil {
            return nil
        }
        let obj = instanceFromName(className)
        let properties = reflect(obj)
        
        let dic: AnyObject?
        if dics!.isKindOfClass(NSArray) {
            dic = (dics as! NSArray).lastObject
        } else {
            dic = dics
        }
        if dic != nil {
            for i in 0 ..< properties.count {
                let pro = properties[i]
                let key = pro.0
                let type = pro.1.valueType
                if let value = dic?.valueForKey(key) {
                    if isArray(type) {
                        let className = childClassName(type)
                        var array: [AnyObject] = [AnyObject]()
                        for item in (value as! NSArray) {
                            if isBaseType(className) {
                                array.append(item)
                            } else if let v: AnyObject! = jsonToModel(item, className: className) {
                                array.append(v)
                            }
                        }
                        setValue(obj, value: array, key: key)
                    } else if isBaseType(type) {
                        setValue(obj, value: value, key: key)
                    } else {
                        let className = childClassName(type)
                        if let value: AnyObject! = jsonToModel(value, className: className) {
                            obj.setValue(value, forKey: key)
                        }
                    }
                }
            }
        }
        return obj
    }
    
    private class func setValue(obj: AnyObject, value: AnyObject!, key: String) {
        if value != nil {
            obj.setValue(value, forKey: key)
        }
    }
    
    /// 从类名实例化
    private class func classFromName(className: String) -> AnyClass! {
        let appName: String? = Json.appName()
        let name = "_TtC\(appName!.utf16.count)\(appName!)\(className.characters.count)\(className)"
        let clazz: AnyClass? = NSClassFromString(name)
        if clazz != nil {
            return clazz
        }
        return nil
    }
    
    /// 直接从类名实例化
    private class func instanceFromName(className: String) -> AnyObject! {
        if className == "NSString" {
            return NSClassFromString(className)
        }
        if let clazz: AnyClass = classFromName(className) {
            return clazz.alloc()
        }
        return nil
    }
    
    /// 是否包含Key
    private class func classHasKey(className: String, key: String) -> Bool {
        if let obj: AnyObject! = instanceFromName(className) {
            let pros = reflect(obj)
            for i in 0 ..< pros.count {
                let pro = pros[i]
                if key == pro.0 {
                    return true
                }
            }
        }
        return false
    }
    
    /// app的名字
    private class func appName() -> String! {
        if let name =  NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as? String {
            return name.replace("-", to: "_")
        }
        return nil
    }
    
    /// string form object
    private class func stringFromObject(obj: AnyObject) -> String {
        let name = NSStringFromClass(obj.classForCoder).replace(appName(), to: "").replace(".", to: "")
        return name
    }
    
    /// Array包含的或者自己的类型
    private class func childClassName(type: Any.Type) -> String {
        let valueType = "\(type)"
        var name = valueType.replace("Swift.Optional", to: "").replace("Swift.Array", to: "").replace("<", to: "").replace(">", to: "").replace("\(appName()).", to: "")
        if name == "Swift.String" {
            name = "NSString"
        } else if name == "Swift.Int" || name == "Swift.Float" || name == "Swift.Double" || name == "Swift.Int64" || name == "Swift.Int32" {
            name = "NSNumber"
        }
        return name
    }
    
    /// 是否为数组
    private class func isArray(type: Any.Type) -> Bool {
        let valueType = "\(type)"
        return valueType.has("Swift.Array")
    }
    
    /// 是否为基础类型
    private class func isBaseType(type: Any.Type) -> Bool {
        return type is Int.Type || type is Int64.Type || type is Int32.Type || type is Float.Type || type is Double.Type || type is String.Type
    }
    
    /// 是否为基础类型
    private class func isBaseType(className: String) -> Bool {
        return className == "NSString" || className == "NSNumber"
    }
}

extension String {
    
    ///替换字符串
    func replace(from: String, to: String) -> String {
        return self.stringByReplacingOccurrencesOfString(from, withString: to, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    ///是否包含字符串
    func has(str: String) -> Bool{
        return self.rangeOfString(str) != nil
    }
}
