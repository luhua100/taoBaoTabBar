//
//  HZTabbarItem.swift
//  SwiftProject
//
//  Created by zyf_luhua on 2022/12/3.
//

import UIKit


public extension String {
    var image : UIImage?{
        return UIImage(named: self)
    }
}

extension UIColor {
    
    //三原色
    class func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    class func hex(_ name: String!, alpha: CGFloat = 1.0) -> UIColor {
        
        var hexName = name.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (hexName.hasPrefix("#")) {
            hexName.remove(at: hexName.startIndex)
        }
        if (hexName.count != 6) {
            return .gray
        }
        var rgbValue: UInt64 = 0
        Scanner(string: hexName).scanHexInt64(&rgbValue)
        
        // 保留前两位 向右位移4位就是2 的16 次方 （16 进制每一位为 2 的4次方 总共 4个 2的4次方 一共为 2的16次方）
        let red = CGFloat((rgbValue & 0xFF0000)>>16)///0xFF
        // 保留中间两位 向右位移2位就是2 的8 次方
        let green = CGFloat((rgbValue & 0x00FF00)>>8)///0xFF
        // 保留后两位
        let blue = CGFloat((rgbValue & 0x0000FF))///0xFF
        
        return rgb(red, green, blue, alpha: alpha)
    }
    
}



class HZTabbarItemListCell: UICollectionViewCell {
    
    
    lazy var iconImageView: UIImageView = { [weak self] in
        let  iconImageView = UIImageView()
        iconImageView.contentMode = .center
        return iconImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconImageView)
        iconImageView.frame = CGRect.init(x: 0, y: 0, width: 42, height: 42)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HZTabbarItem: UIView {
    
    lazy var titleLabel: UILabel = { [weak self] in
        let  titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        titleLabel.textColor = UIColor.hex("#575D66")
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    lazy var imageView: UIImageView = { [weak self] in
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var homeTabSelectedBgView: UIImageView = {  [weak self] in
        let  homeTabSelectedBgView = UIImageView()
        homeTabSelectedBgView.isHidden = true
        homeTabSelectedBgView.isUserInteractionEnabled = true
        return homeTabSelectedBgView
    }()
    
    
    lazy var collectionView: UICollectionView = { [weak self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize.init(width: 42, height: 42)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = .zero
        let  collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
   // flag，用以点击首页tabbar时 如果是火箭状态，则进行切换logo动画，且界面滑到顶部
    
    var flag : Bool = false
    
    ///指定构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///便利构造函数
    convenience init(frame : CGRect , _ index : Int) {
        self.init(frame: frame)
         self.addSubview(titleLabel)
         self.addSubview(imageView)
         self.addSubview(homeTabSelectedBgView)
         
         imageView.frame = CGRect.init(x: self.bounds.size.width / 2 - 14, y: 7, width: 28, height: 28)
         titleLabel.frame  = CGRect.init(x: 0, y: imageView.frame.maxY + 2, width: self.bounds.size.width, height: 14)
         homeTabSelectedBgView.frame = CGRect.init(x: self.bounds.size.width / 2 - 21, y: 7, width: 42, height: 42)
         
        
         if index == 0 {
             self.addSubview(homeTabSelectedBgView)
             homeTabSelectedBgView.addSubview(collectionView)
             homeTabSelectedBgView.frame = CGRect.init(x: self.bounds.size.width / 2 - 21, y: 7, width: 42, height: 42)
             collectionView.frame = CGRect.init(x: 0, y: 0, width: 42, height: 42)
             collectionView.center = CGPoint.init(x: homeTabSelectedBgView.frame.size.width/2, y: homeTabSelectedBgView.frame.size.height/2)
             collectionView.register(HZTabbarItemListCell.classForCoder(), forCellWithReuseIdentifier: "HZTabbarItemListCell")
         }
      
    }
    
    func configTitle(_ title : String , _ normalImage : String , _ selectedImage : String , _ index : Int , selected : Bool , _ lastSelectIndex : Int) {
        titleLabel.text = title
        // 当index == 0, 即首页tab
        if index == 0 {
            if selected {
                homeTabSelectedBgView.image = "tabbar_home_selecetedBg".image
                homeTabSelectedBgView.isHidden = false
                imageView.isHidden = true
                titleLabel.isHidden = true
                // 如果本次点击和上次是同一个tab 都是第0个，则执行push动画，否则执行放大缩小动画
                if lastSelectIndex == index {
                    if self.flag == true {
                        self.pushHomeTabAnimationDown()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kPushDownAnimationScrollTopNotification") , object: nil)
                    }
                }else{
                    self.animationWithHomeTab()
                }

            }else{
                imageView.image = normalImage.image
                homeTabSelectedBgView.isHidden = true
                imageView.isHidden = false
                titleLabel.isHidden = false
            }
        }else{
            homeTabSelectedBgView.isHidden = true
            imageView.isHidden = false
            titleLabel.isHidden = false
            if selected {
                imageView.image = selectedImage.image
                titleLabel.textColor = UIColor.hex("#18A2FF")
                // 如果本次点击和上次是同一个tab 则无反应，否则执行放大缩小动画
                if lastSelectIndex != index {
                    self.animationWithNormalTab()
                }
            }else{
                imageView.image = normalImage.image
                titleLabel.textColor = UIColor.hex("#575D66")
            }
        }
        
    }
    
    
    // push动画 - 火箭头上来，logo下来
    func pushHomeTabAnimationUp() {
        flag = true
        collectionView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: .centeredVertically, animated: true)
    }
    // push动画 - 火箭头落下, logo上来
    func pushHomeTabAnimationDown() {
        flag = false
        collectionView.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .centeredVertically, animated: true)
    }
    
    func animationWithHomeTab() {
        let animation = CABasicAnimation.init(keyPath: "transform.scale")
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        animation.duration = 0.2
        animation.fromValue = NSNumber.init(value:0.5)
        animation.byValue = NSNumber.init(value:0.2)
        animation.toValue = NSNumber.init(value:1)
        homeTabSelectedBgView.layer.add(animation, forKey: nil)
    }
    
    func animationWithNormalTab() {
        let animation = CABasicAnimation.init(keyPath: "transform.scale")
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        animation.duration = 0.25
        animation.fromValue = NSNumber.init(value:1.0)
        animation.fromValue = NSNumber.init(value:1.8)
        animation.fromValue = NSNumber.init(value:0.8)
        animation.fromValue = NSNumber.init(value:0.3)
        imageView.layer.add(animation, forKey: nil)
        titleLabel.layer.add(animation, forKey: nil)
    }
    

}


extension HZTabbarItem : UICollectionViewDataSource ,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HZTabbarItemListCell", for: indexPath) as? HZTabbarItemListCell

        cell?.iconImageView.image = indexPath.item == 0 ? "tabbar_home_selecetedLogo".image : "tabbar_home_selecetedPush".image
        return cell!
    }
}
