//
//  HZTabBarViewController.swift
//  SwiftProject
//
//  Created by zyf_luhua on 2022/12/3.
//

import UIKit

enum AnmationDirection {
    //up push动画，火箭头出来，logo下去  //down push动画，火箭头下去，logo出来
    case anmationDirectionUp,anmationDirectionDown
}


class HZTabBarViewController: UITabBarController {

    
     var wmTabBar: HZBaseTabbar?
    
    /***切换指定index的tabbar***/
    func changeTabBarAtIndex(_ index : Int) {
        self.selectedIndex = index
        wmTabBar?.selectedTabbarAtIndex(index: NSNumber.init(value: index))
    }
    /**暴露外部的切换动画logo和火箭的方法**/
    
    func pushHomeTabBarAnimationType(_ anmationDirection : AnmationDirection) {
        wmTabBar?.pushHomeTabBarAnimationType(anmationDirection)
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let homeVc = UIViewController()
        let hotVc = UIViewController()
        let circleVc = UIViewController()
        let mineVc = UIViewController()
        
        let titles = ["首页","热门","社区","我的"]
        let imageArray = ["home_home_grey","tabbar_collection","home_sprate_grey","tabbar_me"]
        let selectedImageArray = ["home_home_red","tabbar_collection_selected","home_sprate_red","tabbar_me_selected"]
        let childsArr = [homeVc,hotVc,circleVc,mineVc]
        
        var controllers = [UIViewController]()
        
        for vc in childsArr {
            let navi = UINavigationController.init(rootViewController: vc)
            controllers.append(navi)
        }
        
        wmTabBar = HZBaseTabbar.tabBarWithTitleArray(titles, imageArray, selectedImageArray)
        wmTabBar!.tabBarDelegate = self
        self.setValue(wmTabBar, forKey: "tabBar")
        self.viewControllers = controllers
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = self.tabBar.frame
        if frame.size.height != 64 {
            frame.size.height = 64
            frame.origin.y = view.frame.size.height - frame.size.height
            tabBar.frame = frame
        }
        
    }
    
    
}

extension HZTabBarViewController : WMTabBarDelegate {
    func selectedWMTabBarItemAtIndex(_ index: Int) {
        self.selectedIndex = index
    }
    
    
}
