//
//  CSActivityView.swift
//  vPlay
//
//  Created by user on 16/10/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
class CSActivityView: UIView {
    var messageLabel: UILabel!
    var indicatorView: CSActivityIndicatorView!
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
    func startLoading() {
        let indicator = CSActivityIndicatorView()
        indicator.frame.size = CGSize.init(width: 70,
                                           height: 60)
        indicator.animteColor = .white
        indicator.viewBackGroundColor = .clear
        indicator.tag = 100001
        indicator.layer.cornerRadius = 5
        indicator.layer.masksToBounds = true
        self.addSubview(indicator)
        indicator.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(80)
            make.center.equalTo(self)
            indicator.layoutIfNeeded()
            indicator.startAnimating()
        }
        let messageLabel = UILabel()
        messageLabel.backgroundColor = .clear
        messageLabel.textColor = .white
        messageLabel.text = "Loading..."
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageLabel.textAlignment = .center
        self.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(indicator.snp.bottom).offset(-25)
            make.bottom.equalTo(0)
        }
    }
    func stopLoading() {
        if let indicator = self.viewWithTag(100001) as? CSActivityIndicatorView {
            indicator.fadeOut(0.5, delay: 0.1, completion: {_ in
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            })
        }
    }
}
extension UIView {
    func fadeIn(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay,
                       options: .curveEaseIn, animations: {
                        self.alpha = 1.0
        }, completion: completion)}
    func fadeOut(_ duration: TimeInterval = 0.5, delay: TimeInterval = 1.0,
                 completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay,
                       options: .curveEaseIn, animations: {
                        self.alpha = 0.3
        }, completion: completion)}
}
extension UIView {
    func startActivity() {
        let indicator = CSActivityView()
        indicator.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        indicator.frame.size = CGSize.init(width: 100, height: 100)
        indicator.tag = 100001
        indicator.layer.cornerRadius = 5
        indicator.layer.masksToBounds = true
        indicator.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        self.addSubview(indicator)
        self.isUserInteractionEnabled = false
        indicator.startLoading()
    }
    func stopActivity() {
        self.isUserInteractionEnabled = true
        if let indicator = self.viewWithTag(100001) as? CSActivityView {
            indicator.removeFromSuperview()
        }
    }
}
