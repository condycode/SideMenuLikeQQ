//
//  SBTabBarMessageItemView.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/27.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit

class SBTabBarMessageItemView: SBTabBarItemView {
    
    var leftEye: CAShapeLayer!
    var rightEye: CAShapeLayer!
    
    var mouthLayer: CAShapeLayer!
    var outerLayer: CAShapeLayer!
        
    override func setupContentLayer() {
        
        if outerLayer == nil {
            outerLayer = CAShapeLayer()
            contentLayer.addSublayer(outerLayer)
        } else {
            contentLayer.path = nil
        }
        
        if leftEye == nil {
            leftEye = CAShapeLayer()
            contentLayer.addSublayer(leftEye)
            rightEye = CAShapeLayer()
            contentLayer.addSublayer(rightEye)
        } else {
            leftEye.path = nil
            rightEye.path = nil
        }
        
        if mouthLayer == nil {
            mouthLayer = CAShapeLayer()
            contentLayer.addSublayer(mouthLayer)
        } else {
            mouthLayer.path = nil
        }
        
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x: 0, y: 18))
        aPath.addQuadCurve(to: CGPoint(x: 3, y: 19), controlPoint: CGPoint(x: 1, y: 19))
        aPath.addArc(withCenter: CGPoint(x: 14, y: 12.5), radius: 12, startAngle: CGFloat.pi*4/5, endAngle: CGFloat.pi/2, clockwise: true)
        aPath.addQuadCurve(to: CGPoint(x: 0, y: 18), controlPoint: CGPoint(x: 3, y: 25))
        aPath.lineWidth = 1
        
        outerLayer.path = aPath.cgPath
        if orientation == .selected {
            outerLayer.fillColor = highlightedColor.cgColor
            outerLayer.strokeColor = UIColor.clear.cgColor
        } else {
            outerLayer.fillColor = UIColor.clear.cgColor
            outerLayer.strokeColor = normalColor.cgColor
        }
        
        if orientation == .selected {
            
            let leftEyePath = UIBezierPath(roundedRect: CGRect(x: 9.5, y: 8, width: 1.5, height: 3), cornerRadius: 0.5)
            leftEye.path = leftEyePath.cgPath
            leftEye.fillColor = UIColor.white.cgColor
            
            let rightEyePath = UIBezierPath(roundedRect: CGRect(x: 16, y: 8, width: 1.5, height: 3), cornerRadius: 0.5)
            rightEye.path = rightEyePath.cgPath
            rightEye.fillColor = UIColor.white.cgColor
            
            let dPath = UIBezierPath()
            
            dPath.move(to: CGPoint(x: 9.5, y: 15))
            dPath.addArc(withCenter: CGPoint(x: 13.5, y: 15), radius: 4, startAngle: CGFloat.pi, endAngle: 0, clockwise: false)
            dPath.addLine(to: CGPoint(x: 9.5, y: 15))
            
            mouthLayer.path = dPath.cgPath
            mouthLayer.fillColor = UIColor.white.cgColor
            mouthLayer.strokeColor = UIColor.clear.cgColor
            
        } else if orientation == .right {
            
            let leftEyePath = UIBezierPath(roundedRect: CGRect(x: 11.5, y: 8, width: 1.5, height: 3), cornerRadius: 0.5)
            leftEye.path = leftEyePath.cgPath
            leftEye.fillColor = normalColor.cgColor
            
            let rightEyePath = UIBezierPath(roundedRect: CGRect(x: 18, y: 8, width: 1.5, height: 3), cornerRadius: 0.5)
            rightEye.path = rightEyePath.cgPath
            rightEye.fillColor = normalColor.cgColor
            
            let dPath = UIBezierPath()
            
            dPath.move(to: CGPoint(x: 11.5, y: 16))
            dPath.addQuadCurve(to: CGPoint(x: 19.5, y: 16), controlPoint: CGPoint(x: 15.5, y: 20))
            dPath.lineWidth = 1
            
            mouthLayer.path = dPath.cgPath
            mouthLayer.fillColor = UIColor.clear.cgColor
            mouthLayer.strokeColor = normalColor.cgColor
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
        var right_eye_original_x: CGFloat = 0
        
        // 贝塞尔曲线的 偏移
        let offsetX = imageContentView.center.x - screenWidth/3.0/2.0
        let offsetY = imageContentView.center.y - 19.5

        mouthLayer.path = nil
        if orientation == .selected {
            
            left_eye_original_x = 9.5
            right_eye_original_x = 16
            
            let dPath = UIBezierPath()
            
            dPath.move(to: CGPoint(x: 9.5 + offsetX, y: 15 + offsetY))
            dPath.addArc(withCenter: CGPoint(x: 13.5 + offsetX, y: 15 + offsetY), radius: 4, startAngle: CGFloat.pi, endAngle: 0, clockwise: false)
            dPath.addLine(to: CGPoint(x: 9.5 + offsetX, y: 15 + offsetY))
            
            mouthLayer.path = dPath.cgPath
            mouthLayer.fillColor = UIColor.white.cgColor
            mouthLayer.strokeColor = UIColor.clear.cgColor
            
        } else if orientation == .right {
            
            left_eye_original_x = 11.5
            right_eye_original_x = 18
            
            let dPath = UIBezierPath()
            
            dPath.move(to: CGPoint(x: 11.5 + offsetX, y: 16 + offsetY))
            dPath.addQuadCurve(to: CGPoint(x: 19.5 + offsetX, y: 16 + offsetY), controlPoint: CGPoint(x: 15.5 + offsetX, y: 20 + offsetY))
            dPath.lineWidth = 1
            
            mouthLayer.path = dPath.cgPath
            mouthLayer.fillColor = UIColor.clear.cgColor
            mouthLayer.strokeColor = normalColor.cgColor
        }
        
        let leftEyePath = UIBezierPath(roundedRect: CGRect(x: left_eye_original_x + offsetX, y: 8 + offsetY, width: 1.5, height: 3), cornerRadius: 0.5)
        leftEye.path = leftEyePath.cgPath
        
        let rightEyePath = UIBezierPath(roundedRect: CGRect(x: right_eye_original_x + offsetX, y: 8 + offsetY, width: 1.5, height: 3), cornerRadius: 0.5)
        rightEye.path = rightEyePath.cgPath
        
    }
    
}
