//
//  Extension.swift
//  Downloader-Demo
//
//  Created by Ali Ghanavati on 1/16/1398 AP.
//  Copyright © 1398 AP Ali Ghanavati. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    
    func hasAlpha() -> Bool {
        guard let alphaInfo = self.cgImage?.alphaInfo else { return false }
        switch alphaInfo {
        case .first, .last, .premultipliedFirst, .premultipliedLast, .alphaOnly:
            return true
        case .none, .noneSkipFirst, .noneSkipLast:
            return false
        }
    }
    
    func data(compressionQuality: Float = 1.0) -> Data! {
        let hasAlpha = self.hasAlpha()
        let data = hasAlpha ? self.pngData() : self.jpegData(compressionQuality: CGFloat(compressionQuality))
        return data
    }
    
    
}
