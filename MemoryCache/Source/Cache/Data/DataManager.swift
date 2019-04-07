//
//  DataManager.swift
//  Downloader-Demo
//
//  Created by Ali Ghanavati on 1/13/1398 AP.
//  Copyright © 1398 AP Ali Ghanavati. All rights reserved.
//

import Foundation
import UIKit


public class DataManager {
    
    
    let cache = CacheMemory.default
    
    public init() {
        
    }
    
    func loadImage(urlString: String, completion: @escaping (_ image: UIImage?,_ link: String?,_ error: Error?) -> Void) throws {
        if cache.hasDataOnMemory(forKey: urlString) {
            let img = self.cache.getValue(key: urlString, type: UIImage.self)
            completion(img, urlString ,nil)
        }else{
            do{
                try Downloader(link: urlString).downloadFileAsync { (data, error) in
                    if error == nil{
                        guard let imageData = data else{
                            return
                        }
                        let imageToCache = UIImage(data: imageData)
                        if imageToCache != nil{
                            
                            self.cache.setValue(value: imageToCache! , key: urlString)
                        }
                        let img = self.cache.getValue(key: urlString, type: UIImage.self)
                        completion(img , urlString , nil)
                    }else{
                        completion(nil ,urlString, error)
                    }
                }
            }catch(let error){
                throw error
            }
        }
        
    }

    public func loadJson(urlString: String, completion: @escaping (_ json : JSON?,_ link: String?,_ error:  Error?) -> Void) throws {
        if cache.hasDataOnMemory(forKey: urlString) {
            let json = self.cache.getValue(key: urlString, type: JSON.self)
            completion(json, urlString ,nil)
        }else{
            do{
               try Downloader(link: urlString).downloadFileAsync { (data, error) in
                    do {
                        if let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [AnyObject] {
                            CacheMemory.default.setValue(value: JSON.Array(json) , key: urlString)
                            completion(JSON.Array(json), urlString ,nil)
                        }else if let json =  try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:AnyObject] {
                            CacheMemory.default.setValue(value: JSON.Dictionary(json!) , key: urlString)
                            completion(JSON.Dictionary(json!), urlString ,nil)
                        }
                        //                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [AnyObject]
                        
                    } catch(let error) {
                        print(error.localizedDescription)
                    }
                }
            }catch (let erorr){
                throw erorr
            }
        }
    }
   
    
    

}



