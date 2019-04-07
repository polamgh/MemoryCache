//
//  ViewController.swift
//  Downloader-Demo
//
//  Created by Ali Ghanavati on 1/9/1398 AP.
//  Copyright © 1398 AP Ali Ghanavati. All rights reserved.
//

import UIKit
import MemoryCache

class ViewController: UIViewController {
    var refresher:UIRefreshControl!
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSourceAll : [PurplePastebinModel]?
    var dataSource = [PurplePastebinModel]()
    var lastIndex = 0
    var nextOffset = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.collectionView!.addSubview(refresher)

        loadData()
        
        
        
    }


    
    @objc func loadData() {
        self.refresher.beginRefreshing()
        do{
            try Downloader(link: "http://pastebin.com/raw/wgkJgazE").downloadFileAsync { (data, error) in
                self.stopRefresher()
                if error == nil  {
                    guard let data = data else {return}
                    if data.count == 0 {return}
                    self.lastIndex = 0
                    self.dataSourceAll = PastebinModel(data: data)
                    guard let dataAll = self.dataSourceAll else { return}
                    self.dataSource.removeAll()
                    
                    if dataAll.count <= self.nextOffset {
                        self.nextOffset = (dataAll.count) - 1
                    }
                    
                    for n in self.lastIndex...self.nextOffset {
                        self.dataSource.append(dataAll[n])
                        if n == self.nextOffset {
                            self.lastIndex = n
                            self.nextOffset = self.nextOffset + n
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }else{
                    Alert().showAlert(title: "Error", message: (error?.localizedDescription)!)
                }
            }
        }catch (let error){
            print(error.localizedDescription)
        }
        
    }
    
    func stopRefresher() {
        DispatchQueue.main.async {
            self.refresher.endRefreshing()
        }
    }
    
}


extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell" , for: indexPath) as! MainCollectionViewCell
        
            cell.imageView.cacheImage(urlString: dataSource[indexPath.row].urls.regular)
        
        return cell
    }
    

    
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = abs(diffHeight - frameHeight);
        print("pullHeight:\(pullHeight)");
        if pullHeight == 0.0
        {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer:Timer) in
                    if self.nextOffset == self.lastIndex {
                        return
                    }
                    let maxIndex = (self.dataSourceAll?.count ?? 0) - 1
                    if (self.nextOffset) > maxIndex {
                        self.nextOffset = maxIndex
                    }
                    if self.nextOffset == self.lastIndex {
                        return
                    }
                    for n in self.lastIndex...self.nextOffset {
                        self.dataSource.append(self.dataSourceAll![n])
                    }
                    let indexPaths = Array(self.lastIndex...self.nextOffset).map { IndexPath(item: $0, section: 0) }
                    let temp = self.nextOffset - self.lastIndex
                    self.lastIndex = self.nextOffset
                    self.nextOffset = self.nextOffset + temp

                    self.collectionView.insertItems(at: indexPaths)
                })

        }
    }
}


