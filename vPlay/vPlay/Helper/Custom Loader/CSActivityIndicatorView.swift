//
//  CSActivityIndicatorView.swift
//  vPlay
//
//  Created by user on 16/10/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
class CSActivityIndicatorView: UIView {
    var animteColor: UIColor = .white
    var viewBackGroundColor: UIColor = .white
    /** Start animating. */
    public final func startAnimating() {
        layer.layoutIfNeeded()
        layer.speed = 1
        setUpAnimation()
        setbackGroundColor()
    }
    /** Stop animating. */
    public final func stopAnimating() {
        layer.sublayers?.removeAll()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = viewBackGroundColor
    }
    func setbackGroundColor() {
        backgroundColor = viewBackGroundColor
    }
    /**
     Returns the natural size for the receiving view, considering only properties of the view itself.
     A size indicating the natural size for the receiving view based on its intrinsic properties.
     - returns: A size indicating the natural size for the receiving view based on its intrinsic properties.
     */
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
    // MARK: Privates
    public final func setUpAnimation() {
        let animation = CSLoaderView()
        var animationRect = frame.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        let minEdge = min(animationRect.width, animationRect.height)
        layer.sublayers = nil
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        animation.setUpAnimation(in: layer, size: animationRect.size, color: animteColor)
    }
}
