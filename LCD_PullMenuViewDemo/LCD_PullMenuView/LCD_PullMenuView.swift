//
//  LCD_PullMenuView.swift
//  IEXBUY
//
//  Created by 刘才德 on 16/6/16.
//  Copyright © 2016年 IEXBUY. All rights reserved.
//

import UIKit

enum LCD_PullMenuViewType {
    case menuTable_L
    case menuTable_M
    case menuTable_R
}

class LCD_PullMenuView: UIView,UITableViewDelegate,UITableViewDataSource {
    var pullMenuViewSeleBlock: ((tag:LCD_PullMenuViewType, seleIndex:Int) -> Void)?
    private var menuBgView      = UIView()
    private var menuTableView_L: UITableView!
    private var menuTableView_M: UITableView!
    private var menuTableView_R: UITableView!
    
    private var hiddenImage_menuL:Bool {
        return (menuTableView_M != nil) ? true : false
    }
    private var hiddenImage_menM:Bool {
        return (menuTableView_R != nil) ? true : false
    }
    
    //MARK:----------- 数据源
    // 基准高度
    private var _HH:CGFloat {
        if CGFloat(_menuL_titlesL.count) * 44.0 >= self.bounds.height - 60 {
            return self.bounds.height - 60
        }
        return CGFloat(_menuL_titlesL.count) * 44.0
    }
    /*
     左边数据源
     */
    var _menuL_imageL = ""
    var _menuL_titlesL: [String] {
        didSet{
            setMenuTableViewFrame_L()
            menuTableView_L?.reloadData()
        }
        
    }
    
    var _menuL_titlesR: [String] {
        didSet{
            menuTableView_L?.reloadData()
        }
    }
    var _menuL_seleIndex: Int {
        didSet{
            menuTableView_L?.reloadData()
        }
    }
    
    /*
     中间数据源
     */
    var _menuM_titlesL: [String] {
        didSet{
            menuTableView_M?.reloadData()
        }
        
    }
    var _menuM_titlesR: [String] {
        didSet{
            menuTableView_M?.reloadData()
        }
    }
    var _menuM_seleIndex: Int {
        didSet{
            menuTableView_L?.reloadData()
        }
    }
    
    /*
     右边数据源
     */
    var _menuR_titlesL: [String] {
        didSet{
            menuTableView_R?.reloadData()
        }
        
    }
    var _menuR_seleIndex: Int {
        didSet{
            menuTableView_R?.reloadData()
        }
    }
    //MARK:----------- 初始化
     override init(frame: CGRect) {
        //数据源
        _menuL_titlesL = []
        _menuL_titlesR = []
        _menuL_seleIndex = 0
        _menuL_imageL = ""
        
        _menuM_titlesL = []
        _menuM_titlesR = []
        _menuM_seleIndex = 0
        
        _menuR_titlesL = []
        _menuR_seleIndex = 0
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        //添加背景毛玻璃效果
//        let blurEffect = UIBlurEffect(style: .Light)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
//        self.addSubview(blurView)
        
        makeMenuBgView()
        makeMenuTableView_L()
        setMenuTableViewFrame_L()
    }
    private func makeMenuBgView() {
        // 点击层
        let bgView = UIView(frame: self.bounds)
        self.addSubview(bgView)
        let viewTap = UITapGestureRecognizer.init(target: self, action: #selector(LCD_PullMenuView.viewTapClick))
        bgView.addGestureRecognizer(viewTap)
        // 显示层
        self.addSubview(menuBgView)
        menuBgView.backgroundColor = UIColor.xzMainColorBackground()
        menuBgView.frame = CGRectMake(0, 0, self.frame.size.width, 0)
    }
    
    //MARK:----------- 设置各个TableView
    private func makeMenuTableView_L() {
        menuTableView_L = UITableView()
        menuBgView.addSubview(menuTableView_L)
        menuTableView_L.delegate = self
        menuTableView_L.dataSource = self
        menuTableView_L.backgroundColor = UIColor.xzMainColorBackground()
        menuTableView_L.separatorStyle = .None
        menuTableView_L.registerNib(UINib(nibName: "LCD_PullMenuViewDefaultCell", bundle: nil), forCellReuseIdentifier: "LCD_PullMenuViewDefaultCell")
        menuTableView_L.snp_makeConstraints { (make) in
            make.leading.trailing.equalTo(menuBgView)
            make.top.bottom.equalTo(menuBgView)
        }
        
    }
    private func makeMenuTableView_M() {
        menuTableView_M = UITableView()
        menuBgView.addSubview(menuTableView_M)
        menuTableView_M.delegate = self
        menuTableView_M.dataSource = self
        menuTableView_M.backgroundColor = UIColor.xzMainColorBackground()
        menuTableView_M.separatorStyle = .None
        menuTableView_M.registerNib(UINib(nibName: "LCD_PullMenuViewDefaultCell", bundle: nil), forCellReuseIdentifier: "LCD_PullMenuViewDefaultCell")
        
        menuTableView_L.snp_updateConstraints { (make) in
            make.trailing.equalTo(menuBgView).offset(-self.frame.size.width/3 * 2)
        }
        
        menuTableView_M.snp_makeConstraints { (make) in
            make.leading.equalTo(menuTableView_L.snp_trailing)
            make.trailing.equalTo(menuBgView)
            make.top.bottom.equalTo(menuBgView)
        }
    }
    private func makeMenuTableView_R() {
        menuTableView_R = UITableView()
        menuBgView.addSubview(menuTableView_R)
        menuTableView_R.delegate = self
        menuTableView_R.dataSource = self
        menuTableView_R.backgroundColor = UIColor.xzMainColorBackground()
        menuTableView_R.separatorStyle = .None
        menuTableView_R.registerNib(UINib(nibName: "LCD_PullMenuViewDefaultCell", bundle: nil), forCellReuseIdentifier: "LCD_PullMenuViewDefaultCell")
        menuTableView_M.snp_updateConstraints { (make) in
            make.trailing.equalTo(menuBgView).offset(-self.frame.size.width/3)
        }
        menuTableView_R.snp_makeConstraints { (make) in
            make.leading.equalTo(menuTableView_M.snp_trailing)
            make.trailing.equalTo(menuBgView)
            make.top.bottom.equalTo(menuBgView)
        }
    }
    //MARK:----------- 设置这个显示区域，以menuTableView_L为基准
    private func setMenuTableViewFrame_L() {
        UIView.animateWithDuration(0.2, animations: {
            self.menuBgView.frame = CGRectMake(0, 0, self.frame.size.width, self._HH)
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        }) { (Bool) in
            
        }
    }
    
    
    //MARK:----------- UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case menuTableView_L:
            return _menuL_titlesL.count
        case menuTableView_M:
            return _menuM_titlesL.count
        case menuTableView_R:
            return _menuR_titlesL.count
        default:
            return 0
        }
        
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch tableView {
        case menuTableView_L:
            let cell = LCD_PullMenuViewDefaultCell.dequeueReusable(tableView, indexPath: indexPath)
            cell.model(_menuL_titlesL, titlesR: _menuL_titlesR, image: _menuL_imageL, indexPath: indexPath, seleIndex: _menuL_seleIndex, hiddenImage:hiddenImage_menuL)
            
            return cell
        case menuTableView_M:
            let cell = LCD_PullMenuViewDefaultCell.dequeueReusable(tableView, indexPath: indexPath)
            cell.model(_menuM_titlesL, titlesR: _menuM_titlesR, image: "", indexPath: indexPath, seleIndex: _menuM_seleIndex, hiddenImage:hiddenImage_menM)
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
            return cell
        case menuTableView_R:
            let cell = LCD_PullMenuViewDefaultCell.dequeueReusable(tableView, indexPath: indexPath)
            cell.model(_menuR_titlesL, titlesR: [], image: "", indexPath: indexPath, seleIndex: _menuR_seleIndex, hiddenImage:true)
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
            return cell
        default:
            return nullCell(tableView, indexPath: indexPath)
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch tableView {
        case menuTableView_L:
            _menuL_seleIndex = indexPath.row
            menuTableView_L.reloadData()
            pullMenuViewSeleBlock?(tag:.menuTable_L, seleIndex: indexPath.row)
            if menuTableView_M == nil {
                viewTapClick()
            }
        case menuTableView_M:
            _menuM_seleIndex = indexPath.row
            menuTableView_M.reloadData()
            pullMenuViewSeleBlock?(tag:.menuTable_M, seleIndex: indexPath.row)
            if menuTableView_R == nil {
                viewTapClick()
            }
        case menuTableView_R:
            _menuR_seleIndex = indexPath.row
            menuTableView_R.reloadData()
            pullMenuViewSeleBlock?(tag:.menuTable_R, seleIndex: indexPath.row)
            viewTapClick()
        default:
            break
        }
        
    }
    
    func viewTapClick() {
        UIView.animateWithDuration(0.2, animations: {
            self.menuBgView.frame = CGRectMake(0, 0, self.frame.size.width, 0)
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (Bool) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}
extension LCD_PullMenuView {
    //MARK:----------- 默认一个tableView样式
    class func showOneTable(view:UIView ,frame: CGRect,titlesL:[String], titlesR:[String] = [], imageL:String = "",seleIndex:Int = 0) -> LCD_PullMenuView{
        
        for subView in view.subviews {
            if let subview = subView as? LCD_PullMenuView {
                subview._menuL_titlesL = titlesL
                subview._menuL_titlesR = titlesR
                subview._menuL_imageL = imageL
                subview._menuL_seleIndex = seleIndex
                return subview
            }
        }
        
        let payView = LCD_PullMenuView(frame: frame)
        view.addSubview(payView)
        payView._menuL_titlesL = titlesL
        payView._menuL_titlesR = titlesR
        payView._menuL_seleIndex = seleIndex
        payView._menuL_imageL = imageL
        return payView
    }
    //MARK:----------- 打开二级
    func openTwoTable(titlesL:[String],titlesR:[String] = [],seleIndex:Int = 0) {
        if menuTableView_M == nil {
            makeMenuTableView_M()//如果没有二级菜单则创建
        }
        _menuM_titlesL = titlesL
        _menuM_titlesR = titlesR
        _menuM_seleIndex = seleIndex
    }
    //MARK:----------- 打开三级
    func openThreeTable(titlesL:[String],seleIndex:Int = 0) {
        if menuTableView_M == nil {
            makeMenuTableView_M()
        }
        if menuTableView_R == nil {
            makeMenuTableView_R()
        }
        
        _menuR_titlesL = titlesL
        _menuR_seleIndex = seleIndex
    }
    //MARK:----------- 删除二级
    func removeTwoTable() {
        guard menuTableView_M != nil else{return}
        // 如果有三级菜单则一并删除
        menuTableView_R?.removeFromSuperview()
        menuTableView_R = nil
        menuTableView_M.removeFromSuperview()
        menuTableView_M = nil
        
        menuTableView_L.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(menuBgView)
        }
    }
    //MARK:----------- 删除三级
    func removeThreeTable() {
        guard menuTableView_R != nil else{return}
       
        menuTableView_R.removeFromSuperview()
        menuTableView_R = nil
        
        menuTableView_M.snp_updateConstraints { (make) in
            make.trailing.equalTo(menuBgView)
        }
    }
    
    //MARK:----------- 回收
    func removeOneTable(view:UIView){
        for subView in view.subviews {
            if let subview = subView as? LCD_PullMenuView {
                subview.viewTapClick()
                continue
            }
        }
    }
}



