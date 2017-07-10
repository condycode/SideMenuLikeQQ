//
//  SBTabBarItemView.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/26.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit

enum SBTabBarItemType {
    case message;
    case contacts;
    case dynamic;
}

enum SBTabBarSelectedOrientation {
    case left;
    case selected;
    case right;
}

class SBTabBarItemView: UIView {
    
    static let image_max_offset_x: CGFloat = 5
    static let image_max_offset_y: CGFloat = 3
    
    var titleLabel: UILabel!
    var highlightedColor: UIColor!
    var normalColor: UIColor!
    var type: SBTabBarItemType = .message
    var title: String!
    
    var imageContentView: UIView!
    var badgeLabel: SBBadgeLabel!

    var contentLayer = CAShapeLayer()
    
    var orientation: SBTabBarSelectedOrientation = .left {
        didSet {
            setupTitleLabel()
            setupImageView()
        }
    }
    var badgeString: String! {
        willSet {
            
            if badgeLabel == nil {
                initBadgeLabel()
            }
            
            badgeLabel.text = newValue
            badgeLabel.sizeToFit()
            let badgeSize = badgeLabel.frame.size
            let badgeWidth = badgeSize.width + 12
            badgeLabel.frame = CGRect(x: 25 - badgeWidth/2.0, y: -5, width: badgeWidth, height: 19)
            badgeLabel.layer.cornerRadius = 9.5
            
        }
    }
    
    var clearBadge: ((SBTabBarItemView) -> ())?
    
    
    func initBadgeLabel() {
        badgeLabel = SBBadgeLabel()
        badgeLabel.backgroundColor = UIColor.red
        badgeLabel.clipsToBounds = true
        badgeLabel.textColor = UIColor.white
        badgeLabel.font = UIFont.boldSystemFont(ofSize: 10)
        imageContentView.addSubview(badgeLabel)
        badgeLabel.clearBadgeCompletion = {[weak self] (badgeLabel) in
            if self?.clearBadge != nil {
                self?.badgeLabel = nil
                self?.clearBadge!(self!)
            }
        }
    }
    
    
    init(highlightedColor: UIColor = UIColor(red: 59/255.0, green: 171/255.0, blue: 253/255.0, alpha: 1.0), normalColor: UIColor = UIColor(red: 108/255.0, green: 111/255.0, blue: 129/255.0, alpha: 1.0), selected: SBTabBarSelectedOrientation = .left, title: String, type: SBTabBarItemType) {
        super.init(frame: CGRect.zero)
        
        self.orientation = selected
        self.title = title
        self.highlightedColor = highlightedColor
        self.normalColor = normalColor
        self.type = type
        
        commonInit()
        setupTitleLabel()
        setupImageView()
        initBadgeLabel()

        addPan()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 空实现，主要目的是给 子类使用，实现一些特殊的初始化
    func commonInit() {
        
    }
    
    fileprivate func addPan() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        self.addGestureRecognizer(pan)
    }
    
    
    fileprivate func setupTitleLabel() {
        if titleLabel == nil {
            titleLabel = UILabel()
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.left.bottom.right.equalTo(0)
                make.height.equalTo(16)
            }
            
            titleLabel.text = self.title
            titleLabel.font = UIFont.systemFont(ofSize: 12)
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        }
        
        if orientation == .selected {
            titleLabel.textColor = highlightedColor
        } else {
            titleLabel.textColor = normalColor
        }
    }
    
    fileprivate func setupImageView() {
        
        if imageContentView == nil {
            imageContentView = UIView()
            addSubview(imageContentView)
            
            // 添加 layer层
            imageContentView.layer.addSublayer(contentLayer)
            
            imageContentView.bounds = CGRect(x: 0, y: 0, width: 25, height: 25)
            imageContentView.center = CGPoint(x: screenWidth/3.0/2.0, y: 19.5)

        } else {
            
            // 选中以后的缩放动画
            if orientation == .selected {
                UIView.animate(withDuration: 0.1, animations: {[weak self] in
                    self?.imageContentView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    }, completion: { (complete) in
                        
                        UIView.animate(withDuration: 0.2, animations: { [weak self] in
                            self?.imageContentView.transform = CGAffineTransform.identity
                        })
                })
            }
        }
        
        setupContentLayer()
    }
    
    // 画图，无实现，具体到子类中实现
    func setupContentLayer() {
        
    }
    
    // 拖动动画，具体的拖动，到子类中实现
    func panGesture(_ pan: UIPanGestureRecognizer) {
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 得到不处理的情况下，相应点击的view结果，目的是不影响其它的点击
        let result = super.hitTest(point, with: event)
        
        guard badgeLabel != nil else {
            return result
        }
        
        let badgePoint = badgeLabel.convert(point, from: self)
        
        if self.badgeLabel.point(inside: badgePoint, with: event) {
            return badgeLabel
        }
        
        return result
    }
    
}
