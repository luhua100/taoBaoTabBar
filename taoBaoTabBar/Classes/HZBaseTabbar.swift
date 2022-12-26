//
//  HZBaseTabbar.swift
//  SwiftProject
//
//  Created by zyf_luhua on 2022/12/3.
//

import UIKit

protocol WMTabBarDelegate : NSObjectProtocol {
    func selectedWMTabBarItemAtIndex(_ index : Int)
}

class HZBaseTabbar: UITabBar {
  
  //  var WMTabBarItemBlock : ((_ index : Int)->())?
    
    var itemArray = [HZTabbarItem?]()
    var titleArray = [String?]()
    var imageArray = [String?]()
    var selectedImageArray = [String?]()
    weak var tabBarDelegate : WMTabBarDelegate?
    //记录上一次点击index
    private var lastSelectIndex : Int = 0
    private var selectedIndex : Int?{
        didSet{
            for (i,v) in itemArray.enumerated() {
                // 当遍历的idx=selectedIndex时，记录选中状态
                let selected = i == selectedIndex
                // 配置tabBarItem的内容信息
                v?.configTitle(titleArray[i]!, imageArray[i]!, selectedImageArray[i]!, i, selected: selected, lastSelectIndex)
                if i == itemArray.count - 1 {
                    lastSelectIndex = selectedIndex!
                }
            }
        }
    }
    
    static func tabBarWithTitleArray(_ titleArray : [String?], _ imageArray : [String?] , _ selectedImageArray : [String?]) -> HZBaseTabbar {
        let tabbar = HZBaseTabbar()
        tabbar.titleArray = titleArray
        tabbar.imageArray = imageArray
        tabbar.selectedImageArray = selectedImageArray
        tabbar.setupUI()
        return tabbar
        
    }
    
    func setupUI() {
        lastSelectIndex = 100
        self.backgroundColor = UIColor.white
        for (i,_) in titleArray.enumerated() {
            let itemWidth = Int(UIScreen.main.bounds.size.width) / titleArray.count
            let frame = CGRect.init(x: i * itemWidth, y: 0, width: itemWidth, height: 56)
            let tabBarItem = HZTabbarItem.init(frame: frame, i)
            tabBarItem.tag = i
            let  tap  = UITapGestureRecognizer.init(target: self, action: #selector(selectTabBarItemAction(sender:)))
            tabBarItem.addGestureRecognizer(tap)
            self.addSubview(tabBarItem)
            itemArray.append(tabBarItem)
        }
        self.selectedIndex = 0
    }
    
    @objc func selectTabBarItemAction(sender: UITapGestureRecognizer){
        self.classForCoder.cancelPreviousPerformRequests(withTarget: self, selector: #selector(selectTabBarItemAction(sender:)), object: NSNumber.init(value:sender.view!.tag))
        self.perform(#selector(selectedTabbarAtIndex(index:)), with: NSNumber.init(value:sender.view!.tag), afterDelay: 0.15)
    }
    
    
    // 外部指定跳转到某个tab时调用
   @objc func selectedTabbarAtIndex(index : NSNumber) {
       self.selectedIndex = index.intValue
       self.tabBarDelegate?.selectedWMTabBarItemAtIndex(index.intValue)
    }
    // 暴露外部的切换动画logo和火箭的方法
    func pushHomeTabBarAnimationType(_ anmationDirection : AnmationDirection) {
        if itemArray.count > 0 {
            let tabbarItem = itemArray.first!
            if anmationDirection == .anmationDirectionUp {
                tabbarItem?.pushHomeTabAnimationUp()
            }else{
                tabbarItem?.pushHomeTabAnimationDown()
            }
        }
    }
    
    //删除系统的UITabbarButton
    override func layoutSubviews() {
        super.layoutSubviews()
        for view in self.subviews {
            if view.isKind(of: NSClassFromString("UITabBarButton")!) {
                view.removeFromSuperview()
            }
        }
    }
    
}
