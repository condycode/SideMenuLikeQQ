//
//  SBTabBarDynamicItemView.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/27.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit

class SBTabBarDynamicItemView: SBTabBarItemView {
    
    var bigStar: CAShapeLayer!
    var smallStar: CAShapeLayer!
    
    override func setupContentLayer() {
        if bigStar == nil {
            bigStar = CAShapeLayer()
            contentLayer.addSublayer(bigStar)
        } else {
            bigStar.path = nil
        }
        
        if smallStar == nil {
            smallStar = CAShapeLayer()
            contentLayer.addSublayer(smallStar)
        } else {
            smallStar.path = nil
        }
        
        if orientation == .selected {
            
            let bigPath = UIBezierPath()
            bigPath.move(to: CGPoint(x: 1, y: 10))
            bigPath.addLine(to: CGPoint(x: 8.5, y: 8))
            bigPath.addLine(to: CGPoint(x: 12.5, y: 2))
            bigPath.addLine(to: CGPoint(x: 16, y: 8))
            bigPath.addLine(to: CGPoint(x: 24, y: 9.5))
            bigPath.addLine(to: CGPoint(x: 19, y: 16.5))
            bigPath.addLine(to: CGPoint(x: 20.5, y: 24))
            bigPath.addLine(to: CGPoint(x: 13.5, y: 21))
            bigPath.addLine(to: CGPoint(x: 6.5, y: 24))
            bigPath.addLine(to: CGPoint(x: 6, y: 16.5))
            bigPath.close()
            
            bigStar.path = bigPath.cgPath
            bigStar.fillColor = highlightedColor.cgColor
            bigStar.strokeColor = UIColor.clear.cgColor
            
            let smallpath = UIBezierPath()
            smallpath.move(to: CGPoint(x: 19, y: 3))
            smallpath.addArc(withCenter: CGPoint(x: 22, y: 3), radius: 3, startAngle: CGFloat.pi, endAngle: CGFloat.pi*3, clockwise: true)
            
            smallStar.path = smallpath.cgPath
            smallStar.fillColor = highlightedColor.cgColor
            
        } else {
            
            let bigPath = UIBezierPath()
            bigPath.move(to: CGPoint(x: 1, y: 10))
            bigPath.addLine(to: CGPoint(x: 8, y: 8.5))
            bigPath.addLine(to: CGPoint(x: 12.5, y: 3))
            bigPath.addLine(to: CGPoint(x: 16, y: 8))
            bigPath.addLine(to: CGPoint(x: 24, y: 9.5))
            bigPath.addLine(to: CGPoint(x: 19, y: 16.5))
            bigPath.addLine(to: CGPoint(x: 20.5, y: 24))
            bigPath.addLine(to: CGPoint(x: 11.5, y: 21))
            bigPath.addLine(to: CGPoint(x: 6, y: 24))
            bigPath.addLine(to: CGPoint(x: 6, y: 16))
            bigPath.close()
            
            bigPath.lineWidth = 1
            
            bigStar.path = bigPath.cgPath
            bigStar.strokeColor = normalColor.cgColor
            bigStar.fillColor = UIColor.clear.cgColor
        }
    }
    
    override func panGesture(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: self)
        
        if pan.state == .began || pan.state == .changed {
            var imgContentCenter = imageContentView.center
            imgContentCenter.x = imgContentCenter.x + translation.x / 5.0
            imgContentCenter.y = imgContentCenter.y + translation.y / 5.0
            
            imgContentCenter.x = CGFloat.minimum(screenWidth/3.0/2.0 + SBTabBarItemView.image_max_offset_x, imgContentCenter.x)
            imgContentCenter.x = CGFloat.maximum(screenWidth/3.0/2.0 - SBTabBarItemView.image_max_offset_x, imgContentCenter.x)
            
            imgContentCenter.y = CGFloat.minimum(19.5 + SBTabBarItemView.image_max_offset_y, imgContentCenter.y)
            imgContentCenter.y = CGFloat.maximum(19.5 - SBTabBarItemView.image_max_offset_y, imgContentCenter.y)
            
            imageContentView.center = imgContentCenter
        } else if pan.state == .cancelled || pan.state == .failed || pan.state == .ended {
            imageContentView.center = CGPoint(x: screenWidth/3.0/2.0, y: 19.5)
        }
        
        pan.setTranslation(.zero, in: self)
    }
}
