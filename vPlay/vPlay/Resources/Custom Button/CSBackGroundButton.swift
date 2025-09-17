/*
 * CSBackGroundButton.swift
 * This class is for creation Of Back ground color button
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
class CSBackGroundButton: UIButton {
    // MARK: - UILife Cycle of a Button
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customThemeButton()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        customThemeButton()
    }
    // MARK: - Private Method
    /// Customize the button
    func customThemeButton() {
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor.customBackGroundColor()
        self.titleLabel?.font = .customBackGroundButtonFont()
        self.layer.cornerRadius = 2.0
        self.layer.masksToBounds = true
    }
}
