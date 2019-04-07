//
//  ViewController2.swift
//  Downloader-Demo
//
//  Created by Ali Ghanavati on 1/13/1398 AP.
//  Copyright © 1398 AP Ali Ghanavati. All rights reserved.
//

import UIKit
import MemoryCache

class ViewController2: UIViewController {

    @IBOutlet weak var txtResult: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {

            try DataManager().loadJson(urlString: "http://pastebin.com/raw/wgkJgazE") { (json, link, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        self.txtResult.text = "Result : \(json!)"
                    }
                }
            }
        }catch (let error){
            print(error.localizedDescription)
            self.txtResult.text = "Result : \(error.localizedDescription)"
        }
        

        
    }
    



}
