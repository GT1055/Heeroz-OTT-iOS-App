//
//  BMTimeSlider.swift
//  Pods
//
//  Created by BrikerMan on 2017/4/2.
//
//

import UIKit

public class BMTimeSlider: UISlider {
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let trackHeigt:CGFloat = 2
        let position = CGPoint(x: 0 , y: 14)
        let customBounds = CGRect(origin: position, size: CGSize(width: bounds.size.width, height: trackHeigt))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
    override open func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let rect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let newx = rect.origin.x - 10
        let newRect = CGRect(x: newx, y: 0, width: 30, height: 30)
        return newRect
    }
    /// Cue Point Drawer Float
    func addCuePointSubview(_ percentage: CGFloat) {
        if let views = self.subviews[1] as? UIImageView {
            let addView = UIView()
            addView.backgroundColor = .red
            addView.tag = 1
            views.addSubview(addView)
            let offset = Float(percentage * self.frame.size.width)
            addView.snp.makeConstraints {
                $0.centerY.equalTo(views)
                $0.leading.equalTo(views).offset(offset)
                $0.width.equalTo(4)
                $0.height.equalTo(2)
            }
        }
    }
    /// Remove Cue Point
    func removeCuePoint() {
        if let views = self.subviews[1] as? UIImageView {
            for view in views.subviews { view.removeFromSuperview()}
        }
    }
}
extension UIProgressView {
    /// Cue Point Drawer Float
    func addCuePointSubview(_ percentage: CGFloat) {
        if let views = self.subviews[1] as? UIImageView {
            let addView = UIView()
            addView.backgroundColor = .red
            addView.tag = 1
            views.addSubview(addView)
            let offset = Float(percentage * self.frame.size.width)
            addView.snp.makeConstraints {
                $0.centerY.equalTo(views)
                $0.leading.equalTo(views).offset(offset)
                $0.width.equalTo(4)
                $0.height.equalTo(2)
            }
        }
    }
    /// Remove Cue Point
    func removeCuePoint() {
        if let views = self.subviews[1] as? UIImageView {
            for view in views.subviews { view.removeFromSuperview()}
        }
    }
}
