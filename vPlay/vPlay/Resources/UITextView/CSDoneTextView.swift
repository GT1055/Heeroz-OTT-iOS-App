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
class CSDoneTextView: UITextView {
    /// Return Key Name
    @IBInspectable public var returnTypeText: String? {
        didSet {
            doneButtonName = returnTypeText ?? "Done"
        }
    }
    @IBOutlet weak var textViewDelegate: AnyObject!
    weak var textDelegate: CSTextViewDelegate?
    var doneButtonName = "Done"
    override func awakeFromNib() {
        super.awakeFromNib()
        textDelegate = textViewDelegate as? CSTextViewDelegate
        // Add toolBar when keyboardType in this set.
        self.addDoneButtonOnKeyboard()
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
        if textDelegate?.textViewShouldReturn(self) ?? false {
            self.resignFirstResponder()
        } else {
            self.becomeFirstResponder()
        }
    }
}

protocol CSTextViewDelegate: UITextViewDelegate {
    func textViewShouldReturn(_ textView: UITextView) -> Bool
}
