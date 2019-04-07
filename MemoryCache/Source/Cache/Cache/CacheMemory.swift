//
//  CacheMemory.swift
//  Downloader-Demo
//
//  Created by Ali Ghanavati on 1/13/1398 AP.
//  Copyright © 1398 AP Ali Ghanavati. All rights reserved.
//

import Foundation
import UIKit

open class CacheMemory {
    
    private let defaultTotalCostLimit: Int = {
        
        let physicalMemory = ProcessInfo().physicalMemory
        let ratio = physicalMemory <= (1024 * 1024 * 512) ? 0.1 : 0.2
        let limit = physicalMemory / UInt64(1 / ratio)
        return min(Int.max, Int(limit))
    }()
    /// The maximum total cost that the memoryCache can hold before it starts evicting caches.
    ///
    /// If 0, there is no total cost limit. The default value is smaller of the amount cost of physical memory on the computer and `Int.max`.
    public var totalCostLimit: Int {
        get {
            
            return memoryCache.totalCostLimit
        }
        set {
            memoryCache.totalCostLimit = newValue
        }
    }
    
    /// The maximum number of caches the memoryCache should hold.
    ///
    /// If 0, there is no count limit. The default value is 0.
    public var countLimit: Int {
        get {
            return memoryCache.countLimit
        }
        set {
            memoryCache.countLimit = newValue
        }
    }
    
    /// Returns the default singleton instance.
    public static let `default` = CacheMemory()
    public init(totalCostLimit: Int? = nil,
                countLimit: Int = 0) {
        self.totalCostLimit = totalCostLimit ?? defaultTotalCostLimit
        self.countLimit = countLimit
    }
    
    let memoryCache = NSCache<AnyObject, AnyObject>()

    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}





// Store data
extension CacheMemory  {
    
    func getValue<T:DataConvertible>(key: String , type : T.Type) -> T? {
        guard let data = memoryCache.object(forKey: key as AnyObject) as? Data else{
            return nil
        }
        return T.convertFromData(data) as? T
    }
    
    func setValue<T:DataRepresentable>(value: T, key: String) {
        memoryCache.setObject(value.asData() as AnyObject, forKey: key as AnyObject)
    }
 
}


// Utils
extension CacheMemory {
    /// Check if has data on Memory
    public func hasDataOnMemory(forKey key: String) -> Bool {
        return (memoryCache.object(forKey: key as AnyObject) != nil)
    }
}


// Clean
extension CacheMemory {
    
    /// Clean all mem cache . This is an async operation.
    public func cleanAll() {
        cleanMemoryCache()
    }
    
    /// Clean cache by key. This is an async operation.
    public func clean(byKey key: String) {
        memoryCache.removeObject(forKey: key as AnyObject)
    }
    
    private func cleanMemoryCache() {
        memoryCache.removeAllObjects()
    }
    
}

