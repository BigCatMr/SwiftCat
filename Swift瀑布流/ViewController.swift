//
//  ViewController.swift
//  Swift瀑布流
//
//  Created by 嗨约网信 on 2017/7/10.
//  Copyright © 2017年 嗨约网信. All rights reserved.
//

import UIKit
import SwiftyJSON
class ViewController: UIViewController {

    @IBOutlet weak var collfallsView: UICollectionView!
    var modelArray = [ImagerModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelArray.removeAll()
        loadData()
        let layout = BigCatLayout()
        layout.delegate = self
        collfallsView.collectionViewLayout = layout
    }
    func loadData()  {
        let path = Bundle.main.path(forResource: "image.plist", ofType: nil)
        let imageArray = NSMutableArray(contentsOfFile: path!)
        guard let iArray = imageArray else {
            return
        }
        for item  in iArray {
            let imageModel  = ImagerModel(item as? [String : Any])
            modelArray.append(imageModel)
        }
        collfallsView.reloadData()
    }
   
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return modelArray.count
    }
  
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        let cellModel = modelArray[indexPath.row]
        cell.cellModel = cellModel
        return cell
    }
}

extension ViewController : BigCatLayoutDelegate {
    func itemHeightInBigCatflowLayout(_ bigCatLayout : BigCatLayout , indexPath : IndexPath , itemWidth : CGFloat) -> CGFloat{
        let cellModel = modelArray[indexPath.row]
        let h = itemWidth/cellModel.w! * cellModel.h!
        return h
    }
}
