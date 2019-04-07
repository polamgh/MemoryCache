//
//  CacheErrors.swift
//  Downloader-Demo
//
//  Created by Ali Ghanavati on 1/16/1398 AP.
//  Copyright © 1398 AP Ali Ghanavati. All rights reserved.
//

import Foundation


enum NetworkErorr : Error {
    case linkNotValid
    case urlNotValid
}

extension NetworkErorr: LocalizedError {
    
    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case .linkNotValid: return "Error : Link String Not Valid or Empty"
        case .urlNotValid: return "Error : URL Not Valid"
        
        }
    }
}
