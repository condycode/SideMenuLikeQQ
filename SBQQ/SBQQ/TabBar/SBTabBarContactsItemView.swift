//
//  SBTabBarContactsItemView.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/27.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit

class SBTabBarContactsItemView: SBTabBarItemView {
    
    var leftEye: CAShapeLayer!
    var rightEye: CAShapeLayer!
    
    var headLayer: CAShapeLayer!
    var mouthLayer: CAShapeLayer!
    var outerLayer: CAShapeLayer!
    
        
    override func setupContentLayer() {
        
        if headLayer == nil {
            headLayer = CAShapeLayer()
            contentLayer.addSublayer(headLayer)
            outerLayer = CAShapeLayer()
            contentLayer.addSublayer(outerLayer)
        } else {
            headLayer.path = nil
            outerLayer.path = nil
        }
        if leftEye == nil {
            leftEye = CAShapeLayer()
            contentLayer.addSublayer(leftEye)
            rightEye = CAShapeLayer()
            contentLayer.addSublayer(rightEye)
        }
        if mouthLayer == nil {
            mouthLayer = CAShapeLayer()
            contentLayer.addSublayer(mouthLayer)
        } else {
            mouthLayer.path = nil
        }
        
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x: 5.5, y: 8.5))
        aPath.addArc(withCenter: CGPoint(x: 12.5,y: 8.5), radius: 6.5, startAngle: CGFloat.pi, endAngle: CGFloat.pi*3, clockwise: true)
        aPath.lineWidth = 1
        
        headLayer.path = aPath.cgPath
        if orientation == .selected {
            headLayer.fillColor = highlightedColor.cgColor
            headLayer.strokeColor = UIColor.clear.cgColor
        } else {
            headLayer.strokeColor = normalColor.cgColor
            headLayer.fillColor = UIColor.clear.cgColor
        }
        
        let bPath = UIBezierPath()
        
        bPath.move(to: CGPoint(x: 0, y: 25))
        bPath.addArc(withCenter: CGPoint(x: 6.5, y: 25), radius: 6.5, startAngle: CGFloat.pi, endAngle: CGFloat.pi*3/2, clockwise: true)
        bPath.addQuadCurve(to: CGPoint(x: 18, y: 18.5), controlPoint: CGPoint(x: 12.5, y: 17))
        bPath.addArc(withCenter: CGPoint(x: 18, y: 25), radius: 6.5, startAngle: CGFloat.pi*3/2, endAngle: CGFloat.pi*2, clockwise: true)
        bPath.addLine(to: CGPoint(x: 0, y: 25))
        
        outerLayer.path = bPath.cgPath
        if orientation == .selected {
            outerLayer.fillColor = highlightedColor.cgColor
            outerLayer.strokeColor = UIColor.clear.cgColor
        } else {
            outerLayer.strokeColor = normalColor.cgColor
            outerLayer.fillColor = UIColor.clear.cgColor
        }
        
        if orientation == .selected {
            
            let leftEyePath = UIBezierPath(roundedRect: CGRect(x: 9.5, y: 6, width: 1.5, height: 3), cornerRadius: 0.5)
            leftEye.path = leftEyePath.cgPath
            leftEye.fillColor = UIColor.white.cgColor
            
            let rightEyePath = UIBezierPath(roundedRect: CGRect(x: 13.5, y: 6, width: 1.5, height: 3), cornerRadius: 0.5)
            rightEye.path = rightEyePath.cgPath
            rightEye.fillColor = UIColor.white.cgColor
            

            let ePath = UIBezierPath()
            
            ePath.move(to: CGPoint(x: 9.5, y: 11))
            
            // 嘴的半圆的半径
            let radius: CGFloat = 3
            ePath.addQuadCurve(to: CGPoint(x: 15.5, y: 11), controlPoint: CGPoint(x: radius + 9.5, y: 11 + radius))
            ePath.addLine(to: CGPoint(x: 9.5, y: 11))
            
            mouthLayer.path = ePath.cgPath
            mouthLayer.fillColor = UIColor.white.cgColor
        } else if orientation == .left {
            
            let leftEyePath = UIBezierPath(roundedRect: CGRect(x: 8, y: 6, width: 1.5, height: 3), cornerRadius: 0.5)
            leftEye.path = leftEyePath.cgPath
            leftEye.fillColor = normalColor.cgColor
            
            let rightEyePath = UIBezierPath(roundedRect: CGRect(x: 12, y: 6, width: 1.5, height: 3), cornerRadius: 0.5)
            rightEye.path = rightEyePath.cgPath
            rightEye.fillColor = normalColor.cgColor
            
        } else if orientation == .right {

            let leftEyePath = UIBezierPath(roundedRect: CGRect(x: 11, y: 6, width: 1.5, height: 3), cornerRadius: 0.5)
            leftEye.path = leftEyePath.cgPath
            leftEye.fillColor = normalColor.cgColor
            
            let rightEyePath = UIBezierPath(roundedRect: CGRect(x: 15, y: 6, width: 1.5, height: 3), cornerRadius: 0.5)
            rightEye.path = rightEyePath.cgPath
            rightEye.fillColor = normalColor.cgColor
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
        
        // 改标表情位置
        changeImageOffset()
        
        pan.setTranslation(.zero, in: self)
    }
    
    /// 改变表情的偏移
    ///
    /// - Parameter offset:
    fileprivate func changeImageOffset() {
        
        var left_eye_original_x: CGFloat = 0
        
        // 贝塞尔曲线的 偏移
        var offsetX = imageContentView.center.x - screenWidth/3.0/2.0
        var offsetY = imageContentView.center.y - 19.5
        if offsetY > 0 {
            offsetY = CGFloat.minimum(1.5, offsetY)
        } else {
            offsetY = CGFloat.maximum(-1.5, offsetY)
        }
        
        mouthLayer.path = nil
        if orientation == .selected {
            
            // 选中情况下，左右最大移动不超过 1.5
            if offsetX > 0 {
                offsetX = CGFloat.minimum(1.5, offsetX)
            } else {
                offsetX = CGFloat.maximum(-1.5, offsetX)
            }
            
            left_eye_original_x = 9.5
            let mousePath = UIBezierPath()
            
            mousePath.move(to: CGPoint(x: 9.5 + offsetX, y: 11 + offsetY))
            
            // 嘴的半圆的半径
            let radius: CGFloat = 3
            mousePath.addQuadCurve(to: CGPoint(x: 15.5 + offsetX, y: 11 + offsetY), controlPoint: CGPoint(x: radius + 9.5 + offsetX, y: 11 + radius + offsetY))
            mousePath.addLine(to: CGPoint(x: 9.5 + offsetX, y: 11 + offsetY))
            
            mouthLayer.path = mousePath.cgPath
            mouthLayer.fillColor = UIColor.white.cgColor
            mouthLayer.strokeColor = UIColor.clear.cgColor
            
        } else if orientation == .left {
            
            left_eye_original_x = 8
        } else {
            left_eye_original_x = 11
        }
        
        var leftEyeX = CGFloat.maximum(8, left_eye_original_x + offsetX)
        leftEyeX = CGFloat.minimum(leftEyeX, 11)
        
        let leftEyePath = UIBezierPath(roundedRect: CGRect(x: leftEyeX, y: 6 + offsetY, width: 1.5, height: 3), cornerRadius: 0.5)
        leftEye.path = leftEyePath.cgPath
        
        let rightEyePath = UIBezierPath(roundedRect: CGRect(x: leftEyeX + 4, y: 6 + offsetY, width: 1.5, height: 3), cornerRadius: 0.5)
        rightEye.path = rightEyePath.cgPath
        
        
    }
}
