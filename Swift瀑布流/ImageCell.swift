//
//  ImageCell.swift
//  Swift瀑布流
//
//  Created by hiyue09 on 2017/7/11.
//  Copyright © 2017年 嗨约网信. All rights reserved.
//

import UIKit
import Kingfisher
class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imagePic: UIImageView!
    @IBOutlet weak var imagPrice: UILabel!
    var cellModel = ImagerModel() {
        didSet {
            if let urlStr = cellModel.img {
                let url = URL(string: urlStr)
                imagePic.kf.setImage(with: url)
            }
            
            if let priceText = cellModel.price {
                imagPrice.text = priceText
            }
            
        }
    }
    
}
