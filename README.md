- 效果演示

![3.gif](http://upload-images.jianshu.io/upload_images/2419271-789fd7d8ec435728.gif?imageMogr2/auto-orient/strip)

- 简单易用，注释清晰，调用方便，欢迎共同交流，一起进步

- 实现思路
用collectionView实现各种吊炸天的布局，其精髓就在于UICollectionViewLayout，因此我们要自定义一个layout来继承系统的UICollectionViewLayout，所有工作都在这个类中进行。

####核心代码
1. 重写4个系统方法

`第一个方法
override func prepare() 
第二方法
override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
第三个方法
override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
第四个方法
override var collectionViewContentSize: CGSize`
2.布局思路 
瀑布流的思路就是，从上往下，那一列最短，就把下一个item放在哪一列，因此我们需要定义一个字典来记录每一列的最大y值

每一个item都有一个attributes，因此定义一个数组来保存每一个item的attributes。

我们还必须知道有多少列以及列间距、行间距、section到collectionView的边距。


![1.jpg](http://upload-images.jianshu.io/upload_images/2419271-5ebc6bfb79fab02a.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


`fileprivate let defaultColumnCout : Int = 3 //默认的列数
fileprivate let defaultColumnMargin : CGFloat = 10 //默认每一纵列的间距
fileprivate let defaultRowMargin : CGFloat = 10 //默认每一行的间距
fileprivate let defaultEdgInset : UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //默认边缘间距的大小`

- override func prepare() 方法
布局前的一些准备工作都在这里进行，初始化字典，有几列就有几个键值对，key为第几列，value为列的最大y值，初始值为上内边距：
` //初始化  首次布局和更新布局都会调用
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
    }`


- override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? 方法
该方法则用来设置每个item的attributes，在这里，我们只需要简单的设置每个item的attributes.frame即可
首先我们必须得知collectionView的尺寸，然后我们根据collectionView的宽度，以及列数、各个间距来计算每个item的宽度

`//设置每个item的布局属性
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
    }`

- 剩余的方法
`//返回所有的布局属性
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
`

通过代理可以在外部直接修改一些默认的属性，计算高度，所有的数据操作在类外部进行即可
`@objc protocol BigCatLayoutDelegate {
    
    func itemHeightInBigCatflowLayout(_ bigCatLayout : BigCatLayout , indexPath : IndexPath , itemWidth : CGFloat) -> CGFloat
    
    @objc optional func colunCount() -> Int
    @objc optional func columnMargin() -> CGFloat
    @objc optional func rowMargin() -> CGFloat
    @objc optional func collEdgInset() -> UIEdgeInsets
}`
