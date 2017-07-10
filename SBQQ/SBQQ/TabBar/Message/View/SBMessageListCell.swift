//
//  SBMessageListCell.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/23.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit
import Kingfisher

protocol SBMessageListCellDelegate: class {
    func shouldClearUnreadMessageCount(_ cell: SBMessageListCell?)
}


class SBMessageListCell: SBTableViewCell {
    
    var friendInteractionMark: UIImageView?
    var timeLabel: UILabel?
    var badge: SBBadgeLabel?
    var singleSeparator: UIView!
    var contentModel: SBMessageListModel!
    
    weak var delegate: SBMessageListCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        singleSeparator = UIView()
        singleSeparator.backgroundColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        contentView.addSubview(singleSeparator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(with model: SBMessageListModel) {
        
        self.contentModel = model
        
        imageView?.kf.setImage(with: URL(string: model.icon!), placeholder: Image(named: "nearby_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
        imageView?.snp.remakeConstraints({ (make) in
            make.left.equalTo(12)
            make.top.equalTo(8)
            make.width.height.equalTo(50)
        })
        
        textLabel?.text = model.title
        textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        textLabel?.textColor = UIColor.black
        textLabel?.snp.remakeConstraints({ (make) in
            make.left.equalTo((imageView?.snp.right)!).offset(12)
            make.top.equalTo(14)
            make.right.equalTo(contentView.snp.right).offset(-74)
        })
        
        if timeLabel == nil {
            initTimeLabel()
        }
        timeLabel?.text = model.time.normalFarmaterString()
        timeLabel?.snp.remakeConstraints({ (make) in
            make.right.equalTo(contentView.snp.right).offset(-12)
            make.top.equalTo(16)
        })
        
        detailTextLabel?.text = model.lastMessage
        detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        detailTextLabel?.textColor = UIColor.lightGray
        detailTextLabel?.snp.remakeConstraints({ (make) in
            make.left.equalTo((textLabel?.snp.left)!)
            make.top.equalTo((textLabel?.snp.bottom)!).offset(6)
            if model.badge == 0 {
                make.right.equalTo(contentView.snp.right).offset(-15)
            } else {
                make.right.equalTo(contentView.snp.right).offset(-40)
            }
        })
        
        singleSeparator.snp.makeConstraints { (make) in
            make.left.equalTo(textLabel!.snp.left)
            make.bottom.equalTo(contentView.snp.bottom)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(1)
        }
        
        if model.badge == 0 {
            badge?.removeFromSuperview()
            badge = nil
        } else {
            if badge == nil {
                initBadge()
            }
            
            if model.notDisturb {
                badge?.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            } else {
                badge?.backgroundColor = UIColor.red
            }
            badge?.text = model.badge > 99 ? "99+" : "\(model.badge!)"
            badge?.sizeToFit()
            let badgeSize = badge!.frame.size
            
            badge?.frame = CGRect(x: contentView.frame.maxX - CGFloat.maximum(badgeSize.width + 12, 19) - 8 , y: 35, width: badgeSize.width + 12, height: 19)
            contentView.addSubview(badge!)

        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.clipsToBounds = true
        imageView?.layer.cornerRadius = 25
        
        badge?.clipsToBounds = true
        badge?.layer.cornerRadius = 9.5
        
        contentView.clipsToBounds = false
        contentView.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.masksToBounds = false
    }
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            contentView.backgroundColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
            textLabel?.backgroundColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
            detailTextLabel?.backgroundColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        } else {
            contentView.backgroundColor = UIColor.white
            textLabel?.backgroundColor = UIColor.white
            detailTextLabel?.backgroundColor = UIColor.white
        }
    }
    
    
    
    
    
    
    
    func initTimeLabel() {
        timeLabel = UILabel()
        timeLabel?.textColor = UIColor.lightGray
        timeLabel?.font = UIFont.systemFont(ofSize: 10)
        contentView.addSubview(timeLabel!)
    }
    func initBadge() {
        badge = SBBadgeLabel()
        badge?.textColor = UIColor.white
        badge?.font = UIFont.boldSystemFont(ofSize: 10)
        badge?.textAlignment = .center
        badge?.numberOfLines = 1
        badge?.clearBadgeCompletion = {[weak self] (badgeLabel) in
            self?.badge = nil
            self?.delegate?.shouldClearUnreadMessageCount(self)
        }
    }
    
}
