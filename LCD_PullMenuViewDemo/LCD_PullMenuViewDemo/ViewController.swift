//
//  ViewController.swift
//  LCD_PullMenuViewDemo
//
//  Created by 刘才德 on 16/8/16.
//  Copyright © 2016年 sifenzi. All rights reserved.
//

import UIKit

var LCDScreenWidth:CGFloat {
    return UIScreen.mainScreen().bounds.size.width
}
var LCDScreenHeight:CGFloat {
    return UIScreen.mainScreen().bounds.size.height
}

class ViewController: UIViewController {

    
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    private var _menuSeleIndex_one = 0
    private var _menuSeleIndex_twoL = 0
    private var _menuSeleIndex_twoM = 0
    private var _menuSeleIndex_threeL = 0
    private var _menuSeleIndex_threeM = 0
    private var _menuSeleIndex_threeR = 0
    private var _menuView: LCD_PullMenuView?
    private lazy var _menuTitles_OneL = ["广东菜","四川菜","湖南菜","北京菜","云南菜","广西菜","天津菜","台湾菜"]
    private lazy var _menuTitles_OneR = ["123","324","54542","43545","123","324","54542","43545"]
    private lazy var _menuTitles_TwoL = ["猪","鸭","鱼","鸡","熊掌"]
    private lazy var _menuTitles_TwoR = ["99","88","77","66","55"]
    private lazy var _menuTitles_ThreeL = ["爆炒","油焖","清蒸"]
    @IBAction func buttonClick(sender: UIButton) {
        switch sender.tag {
        case 0:
            // 如果前面有二级菜单则删除，同时也会删除第三级
            _menuView?.removeTwoTable()
            _menuView = LCD_PullMenuView.showOneTable(self.view, frame: CGRectMake(0, 104, LCDScreenWidth, LCDScreenHeight - 104),titlesL:_menuTitles_OneL, titlesR:_menuTitles_OneR,  seleIndex: _menuSeleIndex_one)
            _menuView!.pullMenuViewSeleBlock = { (tag,seleIndex) in
                switch tag {
                case .menuTable_L:
                    self.buttonOne.setTitle(self._menuTitles_OneL[seleIndex], forState: .Normal)
                    self._menuSeleIndex_one = seleIndex
                case .menuTable_M:
                    break
                case .menuTable_R:
                    break
                }
            }
        case 1:
            // 如果前面有三级菜单则删除
            _menuView?.removeThreeTable()
            _menuView = LCD_PullMenuView.showOneTable(self.view, frame: CGRectMake(0, 104, LCDScreenWidth, LCDScreenHeight - 104),titlesL:self._menuTitles_OneL,seleIndex: _menuSeleIndex_twoL)
            _menuView!.openTwoTable(self._menuTitles_TwoL, titlesR:_menuTitles_TwoR ,seleIndex: _menuSeleIndex_twoM)
            _menuView!.pullMenuViewSeleBlock = { (tag,seleIndex) in
                switch tag {
                case .menuTable_L:
                    self._menuSeleIndex_twoL = seleIndex
                case .menuTable_M:
                    self.buttonTwo.setTitle(self._menuTitles_TwoL[seleIndex], forState: .Normal)
                    self._menuSeleIndex_twoM = seleIndex
                case .menuTable_R:
                    break
                }
            }
        case 2:
            // 显示菜单，这是一个三级菜单，不需要删除任何菜单
            _menuView = LCD_PullMenuView.showOneTable(self.view, frame: CGRectMake(0, 104, LCDScreenWidth, LCDScreenHeight - 104),titlesL:self._menuTitles_OneL,seleIndex: _menuSeleIndex_threeL)
            // 更新二级菜单数据 -- 
            _menuView!.openTwoTable(self._menuTitles_TwoL,seleIndex: _menuSeleIndex_threeM)
            // 更新三级菜单数据
            _menuView?.openThreeTable(_menuTitles_ThreeL, seleIndex: _menuSeleIndex_threeR)
            // 点击响应事件
            _menuView!.pullMenuViewSeleBlock = { (tag,seleIndex) in
                switch tag {
                case .menuTable_L:
                    self._menuSeleIndex_threeL = seleIndex
                case .menuTable_M:
                    self._menuSeleIndex_threeM = seleIndex
                case .menuTable_R:
                    self.buttonThree.setTitle(self._menuTitles_ThreeL[seleIndex], forState: .Normal)
                    self._menuSeleIndex_threeR = seleIndex
                }
            }
            
        
        default:
            break
        }
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

