/*
 * VIEW Extension
 * This class  is used to global declarion of method to all view
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
//// Story board Extra Feature for create border radius, border width and border Color
extension UIView {
    /// corner radius
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}
/// To change UIImage mode to template
extension UIImage {
    static func localImage(_ name: String, template: Bool = false) -> UIImage {
        var image = UIImage(named: name)!
        if template {
            image = image.withRenderingMode(.alwaysTemplate)
        }
        return image
    }
    // To crop particular image
    func crop(by: CGRect) -> UIImage? {
        guard let returnImage = self.cgImage?.cropping(to: by) else {
            return nil
        }
        return UIImage(cgImage: returnImage)
    }
}
class CSPremiumView: UIView {
    // MARK: - UILife Cycle of a Button
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        customView()
    }
    // MARK: - Private Method
    /// Customize the button
    func customView() {
        let view = UIColor().theGradientBackground(backgroundView: self,
                                                   hexColor1: "FCBD28", hexColor2: "FFD545")
        self.addSubview(view)
        self.backgroundColor = .customPremiumBackGroundColor()
        self.layer.cornerRadius = 2
        self.layer.masksToBounds = true
    }
}
class GradientView: UIView {
    @IBInspectable var startColor: UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor: UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation: Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode: Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode: Bool =  false { didSet { updatePoints() }}
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    var gradientLayer: CAGradientLayer { return (layer as? CAGradientLayer)! }
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}
