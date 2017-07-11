//
//  ImagerModel.swift
//  Swift瀑布流
//
//  Created by 嗨约网信 on 2017/7/10.
//  Copyright © 2017年 嗨约网信. All rights reserved.
//

import UIKit

class ImagerModel: NSObject {
    var h  : CGFloat?
    var img : String?
    var price : String?
    var w : CGFloat?
    convenience init( _ dic : [String : Any]?) {
        self.init()
        guard let modeDic = dic else {
            return
        }
        h = modeDic["h"] as? CGFloat
        img = modeDic["img"] as? String
        price = modeDic["price"] as? String
        w     = modeDic["w"] as? CGFloat
    }
}
