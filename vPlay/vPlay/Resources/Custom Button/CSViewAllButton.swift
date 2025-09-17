/*
 * CSViewAllButton.swift
 * This class is for creation of Custom View All Buttton
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit

class CSViewAllButton: UIButton {
    // MARK: - UILife Cycle of a Button
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customButtonViewAllButton()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        customButtonViewAllButton()
    }
    // MARK: - Private Method
    /// Customize the button
    func customButtonViewAllButton() {
        self.setTitleColor(.themeColorButton(), for: .normal)
        self.setTitle(NSLocalizedString("VIEW ALL", comment: "view All"), for: .normal)
        self.titleLabel?.font = .viewAllButtonFont()
        self.layer.cornerRadius = 2.0
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.clear
    }
}

class CSLoginAndSignButton: UIButton {
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
        self.setTitleColor(.themeColorButton(), for: .normal)
        self.titleLabel?.font = .loginAndSignButtonFont()
        self.layer.cornerRadius = 2.0
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.clear
    }
}

class CSLoginAndSignBoderButton: UIButton {
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
        self.setTitleColor(.navigationHeaderColor(), for: .normal)
        self.titleLabel?.font = .loginAndSignButtonFont()
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.themeColorButton().cgColor
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.clear
    }
}
