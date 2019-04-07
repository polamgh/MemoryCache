//
//  ImageViewExtention.swift
//  Downloader-Demo
//
//  Created by Ali Ghanavati on 1/10/1398 AP.
//  Copyright © 1398 AP Ali Ghanavati. All rights reserved.
//

import UIKit

public class CustomUIImage :  UIImageView {
    var urlImage : String?
    let loading = UIActivityIndicatorView()
    
    public func cacheImage(urlString: String){
        urlImage = urlString
        self.image = nil
        showLoading(true)
        do {
            try DataManager().loadImage(urlString: urlString) { (value , link , error) in
                if error == nil{
                    DispatchQueue.main.async {
                        if self.urlImage == urlString {
                            self.showLoading(false)
                            if self.image == nil{
                                UIView.transition(with: self,
                                                  duration: 0.5,
                                                  options: .transitionCrossDissolve,
                                                  animations: { self.image = value },
                                                  completion: nil)
                            }else{
                                self.image = value
                            }
                        }
                    }
                }
            }
        }catch (let error){
            print(error.localizedDescription)
        }
        
    }
    
    func showLoading(_ show : Bool)  {
        loading.startAnimating()
        loading.color = UIColor.red
        loading.frame = self.bounds
        loading.tag = 1000
        loading.backgroundColor = UIColor.white
        if show {
            self.addSubview(loading)
        }else{
            loading.startAnimating()
            loading.removeFromSuperview()
        }
    }
    
    override public func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
}
