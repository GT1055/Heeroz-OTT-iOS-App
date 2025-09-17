//
//  CSPayAsYouGoViewController+Extension.swift
//  vPlay
//
//  Created by user on 03/12/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
// MARK: - card validation and Getting of card details
extension CSPayAsYouGoViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == cardNumberTextField {
            return self.cardNumberValidation(textField, shouldChangeCharactersIn: range,
                                             replacementString: string)
        } else if textField == monthInputTextField {
            return self.monthValidation(textField, shouldChangeCharactersIn: range,
                                        replacementString: string)
        } else if textField == yearInputTextField {
            return self.yearValidation(textField, shouldChangeCharactersIn: range,
                                       replacementString: string)
        } else if textField == cvcInputTextField {
            if range.location == 3 {
                name.becomeFirstResponder()
                return false
            }
        }
        return true
    }
    /// Card Number and insert a "-" or " "
    func canInsert(atLocation value: Int) -> Bool {
        return ((1 + value)%(characterBreak + 1) == 0) ? true : false
    }
    /// Rearrange the word of a array
    func canRemove(atLocation value: Int) -> Bool {
        return (value != 0) ? (value%(characterBreak + 1) == 0) : false
    }
    /// Month And Year are In Valid
    func monthAndYearFalse() {
        monthInputTextField.textColor = .red
        yearInputTextField.textColor = .red
        monthInputTextField.tag = 1
        yearInputTextField.tag = 1
    }
    /// Month And Year are Valid
    func monthAndYearTrue() {
        monthInputTextField.textColor = UIColor.invertColor(true)
        yearInputTextField.textColor = UIColor.invertColor(true)
        monthInputTextField.tag = 0
        yearInputTextField.tag = 0
    }
    /// Card Number Validation
    func cardNumberValidation(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                              replacementString string: String) -> Bool {
        if textField == cardNumberTextField {
            let nsText = textField.text! as NSString
            if range.location == 19 {
                monthInputTextField.becomeFirstResponder()
                return false
            }
            if range.length == 0 && canInsert(atLocation: range.location) {
                textField.text! = textField.text! + intervalString + string
                return false
            }
            if range.length == 1 && canRemove(atLocation: range.location) {
                textField.text! = nsText.replacingCharacters(in: NSRange(location: range.location-1, length: 2),
                                                             with: "")
                return false
            }
            return string.allowOnlyDigits()
        }; return true
    }
    /// Month validation
    func monthValidation(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                         replacementString string: String) -> Bool {
        let currentYear =  Date().getYearName()
        let enterYear = Int(yearInputTextField.text!) ?? 0
        if string == "1" || string == "0" && range.location == 0 {
            return true
        } else if range.location == 1 {
            let value = textField.text! + string
            monthInputTextField.textColor = .black
            let monthNumber: Int = Int(value) ?? 0
            if monthNumber < 13 && monthNumber != 0 {
                if enterYear != 0 && enterYear == currentYear {
                    monthAndYearTrue()
                } else {
                    monthAndYearFalse()
                }; return true
            } else {
                return false
            }
        } else if range.location == 2 {
            yearInputTextField.becomeFirstResponder()
            return false
        } else {
            if string == "" {
                return true
            }; return false
        }
    }
    /// Year validation
    func yearValidation(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                        replacementString string: String) -> Bool {
        let month =  Date().getMonthName()
        let currentYear =  Date().getYearName()
        let enterMonth = Int(monthInputTextField.text!) ?? 0
        let value = textField.text! + string
        let enterYear: Int = Int(value) ?? 0
        if range.location == 2 {
            cvcInputTextField.becomeFirstResponder()
            return false
        }
        if value.count < 2 {
            monthAndYearTrue()
            return true
        } else if value.count < 3 && enterYear < 100 {
            if enterYear < currentYear {
                monthAndYearFalse()
            } else if enterYear == currentYear {
                if enterMonth < month {
                    monthAndYearFalse()
                } else {
                    monthAndYearTrue()
                }
            } else {
                monthAndYearTrue()
            }
            return true
        } else {
            return false
        }
    }
}
