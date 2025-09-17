/*
 * CSTextField+Extension.swift
 * This controller  is for text Field Extenion
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
private let keyboardAnimationDuration: CGFloat = 0.3
private let minimumScrollFraction: CGFloat = 0.2
private let maximumScrollFraction: CGFloat = 0.8
private let portraitKeyboardHeight: CGFloat = 216
private let landscapeKeyboardHeight: CGFloat = 162
private var animatedDistance = CGFloat()
extension UITextField {
    /// Move TextField Down On Disappearencs of keyboard
    func textFieldToMoveDown(_ mainView: AnyObject) {
        let view: UIView = (mainView as? UIView)!
        var viewFrame: CGRect = view.frame
        viewFrame.origin.y += animatedDistance
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(TimeInterval(keyboardAnimationDuration))
        view.frame = viewFrame
        UIView.commitAnimations()
    }
    /// Move TextField Up On appearencs of keyboard
    func textFieldToMoveUp(_ mainView: AnyObject) {
        let view: UIView = (mainView as? UIView)!
        let textFieldRect: CGRect = view.window!.convert(self.bounds, from: self)
        let viewRect: CGRect = view.window!.convert(view.bounds, from: view)
        let midline: CGFloat = textFieldRect.origin.y + 0.5 * textFieldRect.size.height
        let numerator: CGFloat = midline - viewRect.origin.y - minimumScrollFraction * viewRect.size.height
        let denominator: CGFloat = (maximumScrollFraction - minimumScrollFraction) * viewRect.size.height
        var heightFraction: CGFloat = numerator / denominator
        if heightFraction < 0.0 {
            heightFraction = 0.0
        } else if heightFraction > 1.0 {
            heightFraction = 1.0
        }
        let orientation: UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
        if orientation == .portrait || orientation == .portraitUpsideDown {
            animatedDistance = floor(portraitKeyboardHeight * heightFraction)
        } else {
            animatedDistance = floor(landscapeKeyboardHeight * heightFraction)
        }
        var viewFrame: CGRect = view.frame
        viewFrame.origin.y -= animatedDistance
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(TimeInterval(keyboardAnimationDuration))
        view.frame = viewFrame
        UIView.commitAnimations()
    }
}
// MARK: - UItext Field Extension
private var kAssociationKeyMaxLength: Int = 0
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        } set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else { return }
        let selection = selectedTextRange
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        selectedTextRange = selection
    }
}
