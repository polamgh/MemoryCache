//
//  Data.swift
//  Downloader-Demo
//
//  Created by Ali Ghanavati on 1/13/1398 AP.
//  Copyright © 1398 AP Ali Ghanavati. All rights reserved.
//

import UIKit

private let imageSync = NSLock()

extension UIImage : DataConvertible, DataRepresentable {
    
    public typealias Result = UIImage
    
    
    static func safeImageWithData(_ data:Data) -> Result? {
        imageSync.lock()
        let image = UIImage(data:data, scale: scale)
        imageSync.unlock()
        return image
    }
    
    public class func convertFromData(_ data: Data) -> Result? {
        let image = UIImage.safeImageWithData(data)
        return image
    }
    
    public func asData() -> Data! {
        return self.data()
    }
    
    fileprivate static let scale = UIScreen.main.scale
    
}


extension Data : DataConvertible, DataRepresentable {
    
    public typealias Result = Data
    
    public static func convertFromData(_ data: Data) -> Result? {
        return data
    }
    
    public func asData() -> Data! {
        return self
    }
    
}

extension String : DataConvertible, DataRepresentable {
    
    public typealias Result = String
    
    public static func convertFromData(_ data: Data) -> Result? {
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        return string as Result?
    }
    
    public func asData() -> Data! {
        return self.data(using: String.Encoding.utf8)
    }
    
}

public enum JSON : DataConvertible, DataRepresentable {
    public typealias Result = JSON
    
    case Dictionary([String:AnyObject])
    case Array([AnyObject])
    
    public static func convertFromData(_ data: Data) -> Result? {
        do {
            let object : Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
            switch (object) {
            case let dictionary as [String:AnyObject]:
                return JSON.Dictionary(dictionary)
            case let array as [AnyObject]:
                return JSON.Array(array)
            default:
                return nil
            }
        } catch {
            print("Invalid JSON data \(error)")
            
            return nil
        }
    }
    

    public func asData() -> Data! {
        switch (self) {
        case .Dictionary(let dictionary):
            return try? JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions())
        case .Array(let array):
            return try? JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions())
        }
    }
    
    public var array : [AnyObject]! {
        switch (self) {
        case .Dictionary(_):
            return nil
        case .Array(let array):
            return array
        }
    }
    
    public var dictionary : [String:AnyObject]! {
        switch (self) {
        case .Dictionary(let dictionary):
            return dictionary
        case .Array(_):
            return nil
        }
    }
    
}

