//
//  LCD_PullMenuViewDefaultswift
//  IEXBUY
//
//  Created by 刘才德 on 16/6/17.
//  Copyright © 2016年 IEXBUY. All rights reserved.
//

import UIKit

class LCD_PullMenuViewDefaultCell: UITableViewCell {
    class func dequeueReusable(tableView:UITableView, indexPath:NSIndexPath) -> LCD_PullMenuViewDefaultCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LCD_PullMenuViewDefaultCell", forIndexPath: indexPath) as! LCD_PullMenuViewDefaultCell
        cell.selectionStyle = .None
        return cell
    }
    
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var imageY: UIImageView!
    @IBOutlet weak var imageL: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var titleR: UILabel!
    @IBOutlet weak var imageYConstraint_W: NSLayoutConstraint!
    @IBOutlet weak var imageLConstraint_W: NSLayoutConstraint!
    @IBOutlet weak var titleRConstraint_W: NSLayoutConstraint!

    func model(titlesL:[String], titlesR:[String], image:String, indexPath:NSIndexPath, seleIndex:Int, hiddenImage:Bool) {
        
        titleL.text = titlesL[indexPath.row]
        if titlesR.count > 0 && titlesR.count == titlesL.count{
            titleR.text = titlesR[indexPath.row]
            titleRConstraint_W.constant = CGSize.xzLabelSize(titlesR[indexPath.row], font: UIFont.systemFontOfSize(14), size: CGSizeMake(0, 20)).width
        }
        titleL.textColor = UIColor.xzTextBlaWu()
        titleR.textColor = UIColor.xzTextGra2()
        
        imageL.hidden = true
        imageY.hidden = true
        if seleIndex == indexPath.row {
            titleL.textColor = UIColor.xzMainColor1()
            titleR.textColor = UIColor.xzMainColor1()
            if image.isEmpty {
                imageY.hidden = false
                imageY.layer.cornerRadius = 5.0
                imageY.clipsToBounds = true
                imageY.backgroundColor = UIColor.xzMainColor1()
            }else{
                imageL.hidden = false
                imageL.image = UIImage(named: image)
            }
            
        }
        
        titleR.hidden = false
        imageYConstraint_W.constant = 10
        imageLConstraint_W.constant = 20
        titleRConstraint_W.constant = 70
        if hiddenImage {
            imageY.hidden = true
            imageL.hidden = true
            titleR.hidden = true
            imageYConstraint_W.constant = 0
            imageLConstraint_W.constant = 0
            titleRConstraint_W.constant = 0
        }else{
            
        }
        lineView.hidden = false
        if titlesL.count - 1 == indexPath.row {
            lineView.hidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
