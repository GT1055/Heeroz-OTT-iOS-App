//
//  CSCardCollectionCell.swift
//  vPlay
//
//  Created by user on 27/08/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class CSCardCollectionCell: CSBaseCollectionViewCell {
    /// Collection view inside a table view cell
    @IBOutlet var cardName: UILabel!
    /// Card Number
    @IBOutlet var cardNumber: UILabel!
    /// Card Expire Data
    @IBOutlet var cardExpireData: UILabel!
    /// Card Expire Data
    @IBOutlet weak var ccvInfoLabel: UILabel?
    /// Card Cvv Number
    @IBOutlet var cardCvvNumber: UITextField!
    /// Deleta Card
    @IBOutlet var deleteCard: UIButton!
    /// Deleta Card
    @IBOutlet var selectCard: UIButton!
    /// Deleta Card
    @IBOutlet var selectCardImage: UIImageView!
    /// displayStack stackview
    @IBOutlet weak var displayStack: UIStackView!
    /// Custom view
    @IBOutlet var customView: UIView!
    /// Card List Data
    func cardListData(_ cardData: CSCardList) {
        cardNumber.text = cardData.cardNumber
        cardExpireData.text = cardData.cardMonth + "/" + String(cardData.cardYear)
        cardName.text = cardData.cardHolderName
        addDoneButtonOnKeyboard()
    }
    /// MARK:- Add Done button to Keyboard
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,
                                                             width: UIScreen.main.bounds.size.width,
                                                             height: UIScreen.main.bounds.size.height/17))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                        target: nil,
                                        action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done",
                                                                             comment: ""),
                                                    style: UIBarButtonItem.Style.done,
                                                    target: self,
                                                    action:
            #selector(CSCardCollectionCell.doneButtonAction))
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.cardCvvNumber.inputAccessoryView = doneToolbar
    }
    /// done button finction
    @objc func doneButtonAction() {
        self.cardCvvNumber.resignFirstResponder()
    }
    /// To show the card in DarkMode
    func setDarkModeNeeds() {
        ccvInfoLabel?.textColor = .labelTextColor
        customView.backgroundColor = UIColor.cardCustomView
        for contentViews in displayStack.subviews where contentViews.tag == 200 {
            for labelView in contentViews.subviews where labelView.tag == 100 {
                let receivedLabel = labelView as? UILabel
                receivedLabel?.textColor = .labelTextColor
            }
        }
    }
}
// MARK: - UIText Field Delegate
extension CSCardCollectionCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectCardImage.isHidden = true
    }
}
