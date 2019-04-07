//
//  Alert.swift
//  Downloader-Demo
//
//  Created by Macintosh on 1/18/1398 AP.
//  Copyright © 1398 Ali Ghanavati. All rights reserved.
//

import UIKit

class Alert {
    func showAlert(title : String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            //Cancel Action
        }))
        guard let controller = UIApplication.topViewController() else{
            return
        }
        controller.present(alert, animated: true, completion: nil)
    }
}


extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
