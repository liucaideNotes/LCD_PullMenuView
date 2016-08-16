//
//  LCDExtension.swift
//  iexbuy
//
//  Created by sifenzi on 16/4/21.
//  Copyright © 2016年 IEXBUY. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
func nullCell(tableView:UITableView, indexPath:NSIndexPath, cellId:String = "CellID_null",lineHidden:Bool = false) -> UITableViewCell {
    let cellID_null = cellId
    var cell = tableView.dequeueReusableCellWithIdentifier(cellID_null)
    if (cell == nil)
    {
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellID_null)
    }
    for  view in cell!.contentView.subviews {
        view.removeFromSuperview()
    }
    cell!.selectionStyle = UITableViewCellSelectionStyle.None
    cell?.backgroundColor = UIColor.xzMainColorBackground()
    if !lineHidden {
        UIView.xzSetLineView(cell!, placeType: .Bottom)
    }
    return cell!
}

//MARK:----------- 扩展 Bool
extension Bool {
    enum LimitErrorType {
        case Length
        case Unlawful
    }
    //MARK:---------- 价格类
    static func xzLimitTextFieldForPrice(textField: UITextField,  range: NSRange,  string: String, stringLength:Int = 7, errorType:(LimitErrorType) ->Void ) -> Bool {
        print("-->\(string)")
        
        // -1- 限制首字
        if textField.text == "" &&  string == "."{
            return false
        }
        // -2- 判断首字为 0 的情况， 再次输入不为 . 替换
        if textField.text == "0" &&  string != "."{
            textField.text = string
            return false
        }
        // -3- 排除 (0123456789.退格) 之外的字符
        let remin = 2
        let pointRange = textField.text?.rangeOfString(".")
        if ( pointRange != nil )
        {
            switch string {
            case "0","1","2","3","4","5","6","7","8","9","":
                // -4- 限制只能保留到小数点后2位
                if string != "" {
                    let textRange = Range(pointRange!.startIndex..<textField.text!.endIndex)
                    let subStr = textField.text!.substringWithRange(textRange)
                    
                    if subStr.characters.count > remin {
                        return false  // 超出小数后两位
                    }
                    // -5- 限制长度
                    if (range.location >= stringLength + 3) {
                        errorType(.Length)
                        return false
                    }
                }
                return true
            default:
                errorType(.Unlawful)
                return false // -- 输入非法字符
            }
        }
        else
        {
            switch string {
            case "0","1","2","3","4","5","6","7","8","9",".","":
                // -5- 限制长度
                if (range.location >= stringLength) {
                    errorType(.Length)
                    return false
                }
                
                return true
            default:
                errorType(.Unlawful)
                return false  // -- 输入非法字符
            }
        }
    }
    //MARK:---------- 纯数字类
    static func xzLimitTextFieldForNumbers(textField: UITextField,  range: NSRange,  string: String, firstcanfor0:Bool = false, stringLength:Int = 7, errorType:(LimitErrorType) ->Void ) -> Bool {
        //print("-->\(string)")
        // -1- 判断首字为 0 的情况， 再次输入替换
        if !firstcanfor0 {
            if textField.text == "0"{
                textField.text = string
                return false
            }
            if range.location == 0 && string == "0" && !textField.text!.isEmpty{
                return false
            }
        }
        // -2- 排除 (0123456789退格) 之外的字符
        switch string {
        case "0","1","2","3","4","5","6","7","8","9","":
                // -3- 限制长度
                if (range.location >= stringLength) {
                    errorType(.Length)
                    return false
                }
            
            return true
        default:
            errorType(.Unlawful)
            return false // -- 输入非法字符
        }
    }
    //MARK:---------- 纯字母类
    static func xzLimitTextFieldForABC(textField: UITextField,  range: NSRange,  string: String, stringLength:Int = 16, errorType:(LimitErrorType) ->Void ) -> Bool {
        print("-->\(string)")
        // -1- 排除 (abc--XYZ退格) 之外的字符
        switch string {
        case "","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z":
            // -2- 限制长度
            if (range.location >= stringLength) {
                errorType(.Length)
                return false
            }
            
            return true
        default:
            errorType(.Unlawful)
            return false // -- 输入非法字符
        }
    }
}
//MARK:---------- 扩展 CGSize
extension CGSize {
    static func xzLabelSize(text:String, font:UIFont, size:CGSize) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        let attributes: Dictionary = [NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        var labelSize = text.boundingRectWithSize(size, options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes:attributes,context: nil ).size
        
        
        labelSize.height = ceil(labelSize.height)
        labelSize.width = ceil(labelSize.width)
        return labelSize
    }
}
//MARK:---------- 扩展String
extension String {
    // 取子串  下标脚本
    /*
     //插入
     var str = "1234"
     str[1..<1] = "345"
     print(str) //1345234
     //替换
     str[1...4] = "000"
     print(str) //100034
     //删除
     str[1...3] = ""
     print(str) //134
     //取子串
     let subStr = str[0...1]
     print(subStr) //13
     */
    subscript (range: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(range.startIndex)
            let endIndex = self.startIndex.advancedBy(range.endIndex)
            return self[Range(startIndex..<endIndex)]
        }
        
        set {
            let startIndex = self.startIndex.advancedBy(range.startIndex)
            let endIndex = self.startIndex.advancedBy(range.endIndex)
            let strRange = Range(startIndex..<endIndex)
            self.replaceRange(strRange, with: newValue)
        }
    }

    //MARK:---------- 汉字转拼音
    func transformToPinYin()->String{
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        // 首字母大写
        var str1 = string.stringByReplacingOccurrencesOfString(" ", withString: "")
        str1 = str1.capitalizedString
        return str1
    }
    //MARK:---------- 计算时间
    func byNowDateString() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(self)
        if let _ = date{
            let nowDate = NSDate()
            var spceTime = date!.timeIntervalSinceDate(nowDate)
            spceTime += 24 * 3600
            let calendar = NSCalendar.currentCalendar()
            let unitValue = NSCalendarUnit.Day.rawValue | NSCalendarUnit.Hour.rawValue | NSCalendarUnit.Minute.rawValue
            
            let unit = NSCalendarUnit(rawValue: unitValue)
            let cmps = calendar.components(unit, fromDate: nowDate, toDate: date!, options: NSCalendarOptions.WrapComponents)
            if cmps.day > 365 {
                return "一年之内不过期"
            }else{
                return "\(cmps.day)天\(cmps.hour)小时\(cmps.minute)分钟"
            }
        }
        return "已过期"
    }
}
//MARK:---------- UIColor
extension UIColor {
    //主题色
    class func xzMainColor1() -> UIColor {
        return UIColor(red: 248/255, green: 97/255, blue: 53/255, alpha:1)
    }
    //第二主题色 -- 按钮蓝 天空蓝
    class func xzMainColor2() -> UIColor {
        return UIColor(red: 102/255, green: 204/255, blue: 255/255, alpha: 1)
    }
    //第三主题色 ———— 背景色
    class func xzMainColorBackground() -> UIColor {
        return UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    //线条颜色
    class func xzMainColor_Line() -> UIColor {
        return UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha:1)
    }
    //警告颜色
    class func xzMainColorWarning() -> UIColor {
        return UIColor(red: 255/255, green: 254/255, blue: 102/255, alpha: 1)
    }
    
    //字体颜色 铅黑
    class func xzTextBlaQian() -> UIColor {
        return UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha:1)
    }
    //字体颜色 钨黑
    class func xzTextBlaWu() -> UIColor {
        return UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha:1)
    }
    //字体颜色 深灰
    class func xzTextGra1() -> UIColor {
        return UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha:1)
    }
    //字体颜色 浅灰
    class func xzTextGra2() -> UIColor {
        return UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1)
    }
    
//    // 按钮 主题色
//    class func xzBtnBluColor() -> UIColor {
//        return UIColor(red: 102/255, green: 204/255, blue: 255/255, alpha: 1)
//    }
//    class func xzBtnGraColor() -> UIColor {
//        return UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1)
//    }
//    class func xzBtnOraColor() -> UIColor {
//        return UIColor(red: 255/255, green: 128/255, blue: 1/255, alpha: 1)
//    }
    
}
//MARK:---------- UIView
extension UIView {
    enum PlaceType {
        case Top
        case Bottom
        case Left
        case Right
        case CenterX
        case CenterY
        case OtherH
        case OtherV
        case Remove
    }
    //MARK:---------- 线条 应写在 awakeFromNib() 中，否则会发生重影
    class func xzSetLineView(superview:UIView, placeType:PlaceType, width:Float = 0.5, height:Float = 0.5,otherX:Float = 0, otherY:Float = 0, offL:Double = 0.0, offR:Double = 0.0, offT:Double = 0.0, offB:Double = 0.0){
        
        let shuLine = UIView()
        shuLine.backgroundColor = UIColor.xzMainColor_Line()
        superview.addSubview(shuLine)
        
        switch placeType {
        case .Top:
            shuLine.snp_makeConstraints { (make) in
                make.height.equalTo(height)
                make.top.equalTo(superview)
                make.left.equalTo(superview).offset(offL)
                make.right.equalTo(superview).offset(offR)
            }
        case .Bottom:
            shuLine.snp_makeConstraints { (make) in
                make.height.equalTo(height)
                make.bottom.equalTo(superview)
                make.left.equalTo(superview).offset(offL)
                make.right.equalTo(superview).offset(offR)
            }
        case .Left:
            shuLine.snp_makeConstraints { (make) in
                make.width.equalTo(width)
                make.top.equalTo(superview).offset(offT)
                make.bottom.equalTo(superview).offset(offB)
                make.left.equalTo(superview)
            }
        case .Right:
            shuLine.snp_makeConstraints { (make) in
                make.width.equalTo(width)
                make.top.equalTo(superview).offset(offT)
                make.bottom.equalTo(superview).offset(offB)
                make.right.equalTo(superview)
            }
        case .CenterX:
            shuLine.snp_makeConstraints { (make) in
                make.width.equalTo(width)
                make.centerX.equalTo(superview)
                make.top.equalTo(superview).offset(offT)
                make.bottom.equalTo(superview).offset(offB)
            }
        case .CenterY:
            shuLine.snp_makeConstraints { (make) in
                make.height.equalTo(height)
                make.centerY.equalTo(superview)
                make.left.equalTo(superview).offset(offL)
                make.right.equalTo(superview).offset(offR)
            }
        case .OtherH:
            shuLine.snp_makeConstraints { (make) in
                make.height.equalTo(height)
                make.top.equalTo(superview).offset(otherY)
                make.left.equalTo(superview).offset(offL)
                make.right.equalTo(superview).offset(offR)
            }
        case .OtherV:
            shuLine.snp_makeConstraints { (make) in
                make.width.equalTo(width)
                make.left.equalTo(superview).offset(otherX)
                make.top.equalTo(superview).offset(offT)
                make.bottom.equalTo(superview).offset(offB)
            }
        case .Remove:
            shuLine.removeFromSuperview()
        }
        
    }
    
    
//    //MARK:----------- Loading
//    enum XZ_ActivityViewType {
//        case Loading
//        case Botton
//    }
//    func xz_activityView(frame:CGRect = CGRectMake(0,100,LCDScreenWidth,50)) {
//        self.addSubview(activityView)
//        activityView.frame = frame
//        activityView.backgroundColor = UIColor.clearColor()
//        for item in activityView.subviews {
//            item.removeFromSuperview()
//        }
//        
//        let activity = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
//        activityView.addSubview(activity)
//        activity.center = CGPoint(x: activityView.center.x - 20, y: activityView.center.y)
//        activity.startAnimating()
//        
//        
//        let titleLab = UILabel.xzTextBounds(CGPoint(x: activityView.center.x + 50, y: activityView.center.y), width: 100, height: 20, text: "努力加载中...", alignment: .Left, textColor: UIColor.xzTextGra1(), font: 15.0, xzFont: true)
//        activityView.addSubview(titleLab)
//    }
//    func xz_activityButton(frame:CGRect = CGRectMake(0,100,LCDScreenWidth,50)) -> UIView {
//        activityView.frame = CGRectMake(0,100,LCDScreenWidth,50)
//        activityView.backgroundColor = UIColor.clearColor()
//        for item in activityView.subviews {
//            item.removeFromSuperview()
//        }
//        
//        let label = UILabel.xzTextBounds(activityView.center, width: 100, height: 35, text: "😂网络不给力，请点我重试！", textColor: UIColor.xzTextGra1(), font: 15.0, xzFont: true)
//        label.layer.cornerRadius = 4.0
//        label.clipsToBounds = true
//        label.layer.borderColor = UIColor.xzTextGra2().CGColor
//        label.layer.borderWidth = 0.5
//        activityView.addSubview(label)
//        return activityView
//    }
    
    
}

//MARK:---------- UILabel
extension UILabel {
    
    
}
//MARK:---------- UIButton
extension UIButton {
    
    
}
//MARK:---------- UITextField
extension UITextField {
    
}

//MARK:---------- NSDate
extension NSDate {
    //MARK:---------- 取得设备时间
    class func xzReturnDateFormat(format:String)-> String {
        let date = NSDate()
        var format2 = format;
        if format.isEmpty {
            format2 = "YYYY-MM-dd"
        }
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = format2
        let datestr = dateformatter.stringFromDate(date)
        return datestr
    }
    //MARK:---------- 根据格式截取时间
    class func xzReturnDateFormat(date:String, format:String) -> String {
        let dateTime = NSDate.init(timeIntervalSince1970: Double(date)!)
        let formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.NoStyle
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let formatterLocal = NSLocale.init(localeIdentifier: "en_us")
        formatter.locale = formatterLocal
        formatter.dateFormat = format
        return formatter.stringFromDate(dateTime)
    }
    //MARK:----------- 时间戳转换成时间
    class func xz_timestampToDate(timestamp:Double) -> String {
        
        let dates:NSDate = NSDate.init(timeIntervalSince1970: timestamp)
        
        let time = NSDate.xz_setDateFormat(dates, formatter: "yyyy-MM-dd HH:mm")
        return time
    }
    //MARK:----------- 取特定时间格式
    class func xz_setDateFormat(date:NSDate , formatter:String = "yyyy-MM-dd HH:mm:ss") ->String {
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        //设定时间格式,这里可以设置成自己需要的格式
        dateFormatter.dateFormat = formatter
        let time = dateFormatter.stringFromDate(date)
        return time
        
        
    }
    
    
}
//MARK:---------- NSTimer
public typealias TimerExcuteClosure = @convention(block)()->()
extension NSTimer{
    public class func LCD_scheduledTimerWithTimeInterval(ti:NSTimeInterval, closure:TimerExcuteClosure, repeats yesOrNo: Bool) -> NSTimer{
        return self.scheduledTimerWithTimeInterval(ti, target: self, selector: #selector(NSTimer.excuteTimerClosure(_:)), userInfo: unsafeBitCast(closure, AnyObject.self), repeats: true)
        
    }
    
    class func excuteTimerClosure(timer: NSTimer)
    {
        let closure = unsafeBitCast(timer.userInfo, TimerExcuteClosure.self)
        closure()
    }
}

//MARK:---------- UIViewController
extension UIViewController {
    
    
}


/*
private var key: Void?
private var naviLine: UIView?
extension UINavigationBar {
    var overlay: UIView? {
        get {
            return objc_getAssociatedObject(self, &key) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /**
     滚动时动态修改NavigationBar颜色
     - parameter color: 颜色
     */
    func cgy_setBackgroundColor(color: UIColor) {
        setBackgroundImage(UIImage(), forBarMetrics: .Default)
        shadowImage = UIImage()
        backgroundColor = UIColor.clearColor()
        if overlay == nil {
            overlay = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.mainScreen().bounds.width, height: self.bounds.height + 20))
        }
        overlay!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        insertSubview(self.overlay!, atIndex: 0)
        overlay?.backgroundColor = color
    }
    /**
     滚动时动态修改NavigationBar颜色
     - parameter color:      颜色
     - parameter offsetY:    当前offsetY
     - parameter maxOffsetY: 偏移量最大值
     */
    func cgy_setBackgroundColor(color: UIColor, offsetY: CGFloat, maxOffsetY: CGFloat) {
        
        if offsetY > 0 {
            let alpha = 1 - ((maxOffsetY - offsetY) / maxOffsetY)
            cgy_setBackgroundColor(color.colorWithAlphaComponent(alpha))
            if overlay != nil && naviLine == nil{
                naviLine = UIView(frame: CGRect(x: 0, y: self.bounds.height + 20 - 0.5, width: UIScreen.mainScreen().bounds.width, height: 0.5))
                
                overlay?.addSubview(naviLine!)
            }
            if naviLine != nil {
                naviLine?.backgroundColor = UIColor.xzMainColor_Line().colorWithAlphaComponent(alpha)
            }
            
        } else {
            cgy_setBackgroundColor(color.colorWithAlphaComponent(0))
            if overlay != nil && naviLine != nil{
                naviLine?.removeFromSuperview()
                naviLine = nil
            }
        }
    }
    /**
     清空
     */
    func cgy_clean() {
        setBackgroundImage(nil, forBarMetrics: .Default)
        overlay?.removeFromSuperview()
        overlay = nil
    }
 
}
 */
