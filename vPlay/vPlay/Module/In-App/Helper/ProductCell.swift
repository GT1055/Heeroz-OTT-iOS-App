/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import StoreKit
protocol customDelegate {
    func clickButton (cell : ProductCell)
}
class ProductCell: UITableViewCell, buttonStateDelegate {
    func buttonState() {
        self.button.isUserInteractionEnabled = true
    }
    @IBOutlet var productTitle: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet weak var lineView: UIView!
    var button: UIButton!
    var delegate: customDelegate!
    var buttonDelegate: buttonStateDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productPrice?.textColor = UIColor.invertColor(true)
        productTitle?.textColor = UIColor.invertColor(true)
        lineView.backgroundColor = .separatorColor
        self.buttonDelegate = self
        self.showSkeleton()
    }
  static let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.formatterBehavior = .behavior10_4
    formatter.numberStyle = .currency
    
    return formatter
  }()
  
  var buyButtonHandler: ((_ product: SKProduct) -> Void)?
  
  var product: SKProduct? {
    didSet {
      guard let product = product else { return }

      productTitle.text = product.localizedTitle

      if inAppIdentifiers.store.isProductPurchased(product.productIdentifier) {
        ProductCell.priceFormatter.locale = product.priceLocale
        productPrice.text = ProductCell.priceFormatter.string(from: product.price)
        accessoryType = .none
        accessoryView = self.newBuyButton()
      } else if IAPHelper.canMakePayments() {
        ProductCell.priceFormatter.locale = product.priceLocale
        productPrice.text = ProductCell.priceFormatter.string(from: product.price)
        accessoryType = .none
        accessoryView = self.newBuyButton()
      } else {
        productPrice.text = "Not available"
      }
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    textLabel?.text = ""
    detailTextLabel?.text = ""
    accessoryView = nil
  }
    func showSkeleton() {
        self.showSkeletionView()
        lineView.isHidden = true
    }
    func hideskeletonView() {
        self.hideSkeleton()
        lineView.isHidden = false
    }
  func newBuyButton() -> UIButton {
    button = UIButton(type: .system)
    button.setTitleColor(.convertHexStringToColor("2088DB"), for: .normal)
    button.setTitle("Buy", for: .normal)
    button.addTarget(self, action: #selector(ProductCell.buyButtonTapped(_:)), for: .touchUpInside)
    button.titleLabel?.font =  UIFont(name: "SF UI Display", size: 15)
    button.sizeToFit()
    
    return button
  }
  @objc func buyButtonTapped(_ sender: AnyObject) {
    button.isUserInteractionEnabled = false
    if LibraryAPI.sharedInstance.getUserId().isEmpty {
    delegate.clickButton(cell: self)
    return
    }
    buyButtonHandler?(product!)
  }
}
