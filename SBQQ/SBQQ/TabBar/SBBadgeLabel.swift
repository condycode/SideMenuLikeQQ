//
//  SBBadgeLabel.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/7/3.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit

class SBBadgeLabel: UILabel {
    
    var clearBadgeCompletion: ((SBBadgeLabel) -> ())?
    
    // 是否能够通过拖动角标清空未读数
    var draggable:Bool = true

    
    // 用来存储badgeLabel的center，移动后不清空的时候，badgeLabel返回原来的位置
    private var badgeLabelCenter:CGPoint!

    // badgeLabel原始位置显示的圆 的半径
    private var r1:CGFloat!
    // 拖动的位置的badgeLabel的圆 的半径
    private var r2:CGFloat!
    // layer
    private var viscosityLayer:CAShapeLayer!
    /// 放到badgelabel正常显示的位置，连接移动轨道，永远不动，在badgeLabel的下面
    lazy var stayPutView:UIView = {
        let stayPutView = UIView()
        stayPutView.backgroundColor = self.backgroundColor
        return stayPutView
    }()
    /// 用来判断是否已经超出了最大距离，超过了以后，又回到原来的地方，不画线
    private var beyond:Bool = false
    // 表示能拖动的最大距离，超过这个距离，就不再画连接线了
    private let max_distance:CGFloat = 80
    // 表示用户再结束拖动时，只要在这个距离内，就算用户取消
    private let max_translation_cancel:CGFloat = 20
    
    
    // 用户结束拖动，但是没有清空的情况下，label应该回到原来的视图上，用来记录结束后，应该回到那个view上
    private var originalSuperView: UIView!
    
    
    override var backgroundColor: UIColor! {
        willSet {
            stayPutView.backgroundColor = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont.systemFont(ofSize: 11)
        self.isUserInteractionEnabled = true
        self.textAlignment = .center
        
        viscosityLayer = CAShapeLayer()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureMove(_:)))
        self.addGestureRecognizer(pan)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if originalSuperView == nil && newSuperview != nil {
            originalSuperView = newSuperview
        }
        
        badgeLabelCenter = self.center
        
        newSuperview?.addSubview(stayPutView)
        newSuperview?.layer.addSublayer(viscosityLayer)
        
        stayPutView.isHidden = false
        stayPutView.bounds = CGRect(x: 0, y: 0, width: CGFloat.minimum(frame.width, frame.height), height: CGFloat.minimum(frame.width, frame.height))
        stayPutView.center = self.center
        stayPutView.layer.cornerRadius = CGFloat.minimum(frame.width, frame.height)/2.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        r1 = self.frame.height/2.0
        r2 = self.frame.height/2.0
    }
    
    
    // MARK: - 拖动清空数字的部分
    @objc func panGestureMove(_ pan: UIPanGestureRecognizer) {
        
        //如果设置了不可以拖动属性
        if (!draggable) {
            return
        }
        
        if let panView = pan.view {
            let point = pan.translation(in: panView)
            var center = panView.center
            center.x = center.x + point.x
            center.y = center.y + point.y
            panView.center = center
            
            pan.setTranslation(CGPoint.zero, in: panView)
            
            switch pan.state {
                
            case UIGestureRecognizer.State.cancelled, .failed, .ended:
                
                if (self.beyond == true) {
                    
                    
                    let x1 = badgeLabelCenter.x
                    let y1 = badgeLabelCenter.y
                    let x2 = self.center.x
                    let y2 = self.center.y
                    
                    // 结束时，用户拖动的距离
                    let translation = CGFloat(sqrtf(Float((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1))))
                    if (translation < max_translation_cancel) {
                        
                        // 这种情况下，用户拖动距离先是超出了预定范围，但是又挪动到距离起点很近的地方，算作用户想取消
                        resetWithAnimation()
                        
                    } else {
                        
                        // 超出了预定的范围，理解为用户已经完成了删除操作
                        userCompleteClearOperation()
                    }
                    
                    
                } else {
                    
                    /// 没有超出预定范围，理解为用户放弃了这次清除操作，还原
                    resetWithAnimation()
                }
                
            case .began:
                let win = UIApplication.shared.keyWindow!
                
                self.center = (self.superview?.convert(self.center, to: win))!
                win.addSubview(self)
                
                
            default:
                // 默认的跟着拖动位置：移动、画线、连线
                createViscosityLayear()
            }
        }
    }
    
    
    //MARK: - 用户的操作没有完成，或者取消了，还原
    private func resetWithAnimation() {
        weak var weakSelf = self
        stayPutView.isHidden = true
        UIView.animate(withDuration: 0.2, animations: {
            guard weakSelf != nil else {return}
            self.center = weakSelf!.badgeLabelCenter
            weakSelf!.createViscosityLayear()
        }, completion: { (complete) in
            
            guard weakSelf != nil else {return}
            weakSelf!.beyond = false
            weakSelf!.stayPutView.isHidden = false
            
            let win = UIApplication.shared.keyWindow!
            weakSelf!.center = weakSelf!.originalSuperView.convert(weakSelf!.badgeLabelCenter, from: win)
            weakSelf!.originalSuperView.addSubview(self)
            
        })
    }
    
    // MARK: - 根据badgeLabel当前的位置，动态画连接线
    private func createViscosityLayear() {
        let x1 = badgeLabelCenter.x
        let y1 = badgeLabelCenter.y
        let x2 = self.center.x
        let y2 = self.center.y
        
        var cosDigree:CGFloat = 0
        var sinDigree:CGFloat = 0
        
        let centerDistance = CGFloat(sqrtf(Float((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1))))
        
        // 超过最长距离的
        if (centerDistance > max_distance || beyond == true) {
            let path = UIBezierPath()
            viscosityLayer.path = path.cgPath
            viscosityLayer.fillColor = self.backgroundColor!.cgColor
            beyond = true
            self.stayPutView.isHidden = true
            return
        }
        
        let reviseDistance = max_distance * 4
        r1 = r2 * (1 - centerDistance/reviseDistance) - 1
        
        // 在原地不动的那个view做一个大小变化的动画
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0
        animation.toValue = NSNumber(value: Float(reviseDistance - centerDistance) / Float(reviseDistance))
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        self.stayPutView.layer.add(animation, forKey: nil)
        
        
        if (centerDistance == 0) {
            cosDigree = 1
            sinDigree = 0
        } else {
            cosDigree = (y2 - y1) / centerDistance
            sinDigree = (x2 - x1) / centerDistance
            
        }
        
        // 找到6个点的位置，划线连线
        let pointA = CGPoint(x: x1-r1*cosDigree, y: y1+r1*sinDigree)  // A
        let pointB = CGPoint(x: x1+r1*cosDigree, y: y1-r1*sinDigree) // B
        let pointD = CGPoint(x: x2-r2*cosDigree, y: y2+r2*sinDigree) // D
        let pointC = CGPoint(x: x2+r2*cosDigree, y: y2-r2*sinDigree) // C
        let pointO = CGPoint(x: pointA.x + (centerDistance / 2)*sinDigree, y: pointA.y + (centerDistance / 2)*cosDigree)
        let pointP = CGPoint(x: pointB.x + (centerDistance / 2)*sinDigree, y: pointB.y + (centerDistance / 2)*cosDigree)
        
        let path = UIBezierPath()
        path.move(to: pointA)
        path.addQuadCurve(to: pointD, controlPoint: pointO)
        path.addLine(to: pointC)
        path.addQuadCurve(to: pointB, controlPoint: pointP)
        path.move(to: pointA)
        viscosityLayer.path = path.cgPath
        viscosityLayer.fillColor = self.backgroundColor!.cgColor
    }
    
    // MARK: - 用户完成了清除角标的操作
    private func userCompleteClearOperation() {
        
        let boomImg = UIImageView()
        boomImg.bounds = CGRect(x: 0, y: 0, width: 34, height: 34)
        boomImg.center = self.center
        boomImg.animationImages = [UIImage(named: "id_1")!,
                                   UIImage(named: "id_2")!,
                                   UIImage(named: "id_3")!,
                                   UIImage(named: "id_4")!,
                                   UIImage(named: "id_5")!]
        boomImg.animationDuration = 0.4
        boomImg.animationRepeatCount = 1
        boomImg.startAnimating()
        self.superview?.addSubview(boomImg)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            boomImg.removeFromSuperview()
        }
        
        self.stayPutView.removeFromSuperview()
        self.removeFromSuperview()
        // 闭包
        if (self.clearBadgeCompletion != nil) {
            self.clearBadgeCompletion!(self)
        }
    }
}
