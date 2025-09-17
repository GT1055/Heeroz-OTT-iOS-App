/*
 * CSCustomView
 * This class  is used as parent class for all View
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
class CSCustomNotificationView: UIView {
    /// Text label for showing message
    @IBOutlet var textLabel: UILabel!
    /// contentView for showing View
    @IBOutlet var contentView: UIView!
    // MARK: - Life Cycle Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadnib()
    }
    /// Initializes the view from the storyboard.
    ///
    /// - parameter aDecoder:   The coder to load the XML storyboard.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadnib()
    }
    /// Load nib 
    private func loadnib() {
        Bundle.main.loadNibNamed("CustomView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,
                                        UIView.AutoresizingMask.flexibleHeight]
        textLabel.frame = self.bounds
        textLabel.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,
                                      UIView.AutoresizingMask.flexibleHeight]
    }
}
