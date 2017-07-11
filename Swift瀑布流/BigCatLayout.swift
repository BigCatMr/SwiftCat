//
//  BigCatLayout.swift
//  Swift瀑布流
//
//  Created by 嗨约网信 on 2017/7/10.
//  Copyright © 2017年 嗨约网信. All rights reserved.
//

import UIKit

fileprivate let defaultColumnCout : Int = 3 //默认的列数
fileprivate let defaultColumnMargin : CGFloat = 10 //默认每一纵列的间距
fileprivate let defaultRowMargin : CGFloat = 10 //默认每一行的间距
fileprivate let defaultEdgInset : UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //默认边缘间距的大小

@objc protocol BigCatLayoutDelegate {
    
    func itemHeightInBigCatflowLayout(_ bigCatLayout : BigCatLayout , indexPath : IndexPath , itemWidth : CGFloat) -> CGFloat
    
    @objc optional func colunCount() -> Int
    @objc optional func columnMargin() -> CGFloat
    @objc optional func rowMargin() -> CGFloat
    @objc optional func collEdgInset() -> UIEdgeInsets
}
class BigCatLayout: UICollectionViewLayout {
    
    var delegate : BigCatLayoutDelegate?
    
    let attrArray = NSMutableArray()//保存布局属性
    var heightArray = [CGFloat]()//保存每列的高度
    
    
    //列数
    fileprivate var columnCount : Int {
        get{
            let columnCout = delegate?.colunCount?()
           return columnCout ?? defaultColumnCout
        }
    }
    //列间距
    var columnMargin : CGFloat {
        get {
            let columnMargin = delegate?.columnMargin?()
            
            return columnMargin ?? defaultColumnMargin
        }
    }
    //行间距
    var rowMargin : CGFloat {
        get {
            let rowMargin  = delegate?.rowMargin?()
            return rowMargin ?? defaultRowMargin
        }
    }
    //边缘间距
    var collEdgInset : UIEdgeInsets {
        get {
            let collEdgInset = delegate?.collEdgInset?()
            
            return collEdgInset ?? defaultEdgInset
        }
    }
    

    
    //初始化  首次布局和更新布局都会调用
    override func prepare() {
        
        //清除缓存数据
        attrArray.removeAllObjects()
        heightArray.removeAll()
        //初始化高度数据
        for _ in 0..<self.columnCount {
            heightArray.append(self.collEdgInset.top)
        }
        let count = self.collectionView?.numberOfItems(inSection: 0)
        for i in 0..<count! {
            //获取每个item
            let index = IndexPath(item: i, section: 0)
            //设置item的属性
            let attr = layoutAttributesForItem(at: index)
            attrArray.add(attr!)
        }

        
    }
    //设置每个item的布局属性
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        //设置位置坐标
        let collW = self.collectionView?.bounds.size.width
        let w = (collW! - collEdgInset.left - collEdgInset.right - (CGFloat(columnCount - 1) * columnMargin)) / CGFloat(columnCount)
        var itemH : CGFloat = 100
        if let h = delegate?.itemHeightInBigCatflowLayout(self, indexPath: indexPath, itemWidth: w) {
            itemH = h
        }
        //找出高度最短的那一列
        var minHeight  = heightArray[0]
        var minIdex   = 0
        //找出最短的那列并记录更新
        for i in 1..<columnCount{
            if minHeight > heightArray[i] {
                minHeight    = heightArray[i]
                minIdex      = i
            }
        }
        let x = collEdgInset.left + CGFloat(minIdex) * ( w + columnMargin)
        var y = minHeight
        if y != collEdgInset.top { //不是第一行的时候
            y = minHeight + rowMargin
        }
        heightArray[minIdex] = y + itemH //更新最短高度
        attr.frame = CGRect(x: x, y: y, width: w, height: itemH)
        return attr
    }
    //返回所有的布局属性
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attrArray as? [UICollectionViewLayoutAttributes]
    }
    //返回 collectionViewContentSize
    override var collectionViewContentSize: CGSize {
        //找出高度最高的那一列
        var maxHeight  = heightArray[0]
        for i in 1..<columnCount{
            if maxHeight < heightArray[i] {
                maxHeight    = heightArray[i]
            }
        }

        return CGSize(width: 0 , height: maxHeight)
    }
   
}
