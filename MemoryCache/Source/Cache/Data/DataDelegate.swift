//
//  DataDelegate.swift
//  Downloader-Demo
//
//  Created by Ali Ghanavati on 1/16/1398 AP.
//  Copyright © 1398 AP Ali Ghanavati. All rights reserved.
//

import Foundation


public protocol DataConvertible {
    associatedtype Result
    
    static func convertFromData(_ data:Data) -> Result?
}

public protocol DataRepresentable {
    
    func asData() -> Data!
}
