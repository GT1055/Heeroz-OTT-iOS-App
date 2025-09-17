/*
 * CSDoneTextField.swift
 * This class to create a custom text field with done button
 * @category   vPlay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
/// Done Text Field
class CSDoneTextField: UITextField {
    /// Return Key Name
    @IBInspectable public var returnTypeText: String? {
        didSet {
            doneButtonName = returnTypeText ?? "Done"
        }
    }
    var doneButtonName = "Done"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Add toolBar when keyboardType in this set.
        let set: [UIKeyboardType] = [.numberPad, .phonePad]
        if set.contains(self.keyboardType) {
            self.addDoneButtonOnKeyboard()
        }
    }
    /// MARK:- Add Done button to Keyboard
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,
                                                             width: UIScreen.main.bounds.size.width,
                                                             height:
            UIScreen.main.bounds.size.height/17))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                        target: nil,
                                        action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString(doneButtonName, comment: "done"),
                                                    style: UIBarButtonItem.Style.done,
                                                    target: self,
                                                    action:
            #selector(self.doneButtonAction))
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    /// done button finction
    @objc func doneButtonAction() {
        if (delegate?.textFieldShouldReturn!(self))! {
            self.resignFirstResponder()
        } else {
            self.becomeFirstResponder()
        }
    }
}
/// Phone Number Button Action
class CSNumberTextField: UITextField {
    /// Return Key Name
    @IBInspectable public var returnTypeText: String? {
        didSet {
            doneButtonName = returnTypeText ?? "Done"
        }
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    var doneButtonName = "Done"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Add toolBar when keyboardType in this set.
        let set: [UIKeyboardType] = [.numberPad, .phonePad]
        if set.contains(self.keyboardType) {
            self.addDoneButtonOnKeyboard()
        }
    }
    /// MARK:- Add Done button to Keyboard
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,
                                                             width: UIScreen.main.bounds.size.width,
                                                             height:
            UIScreen.main.bounds.size.height/17))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                        target: nil,
                                        action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString(doneButtonName, comment: "done"),
                                                    style: UIBarButtonItem.Style.done,
                                                    target: self,
                                                    action:
            #selector(self.doneButtonAction))
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    /// done button finction
    @objc func doneButtonAction() {
        if (delegate?.textFieldShouldReturn!(self))! {
            self.resignFirstResponder()
        } else {
            self.becomeFirstResponder()
        }
    }
}
extension UITextField {
    func togglePasswordVisibility() {
        isSecureTextEntry = !isSecureTextEntry
        if let existingText = text, isSecureTextEntry {
            /* When toggling to secure text, all text will be purged if the user
             continues typing unless we intervene. This is prevented by first
             deleting the existing text and then recovering the original text. */
            deleteBackward()
            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }
        /* Reset the selected text range since the cursor can end up in the wrong
         position after a toggle because the text might vary in width */
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
    }
}
extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder =
                NSAttributedString(string: self.placeholder != nil ?
                self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
