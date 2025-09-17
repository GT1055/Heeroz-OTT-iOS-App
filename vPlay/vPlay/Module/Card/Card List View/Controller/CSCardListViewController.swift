/*
 * CSCardListViewController.swift
 * This class is used to list all card and Create a New card here
 * @category   vPlay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

class CSCardListViewController: CSParentViewController {
    /// Card Listing Array
    var cardListArray = [CSCardList]()
    /// Card List in collection Data Sources
    @IBOutlet var cardListCollectionDataSources: CSCardListingDataSource!
    /// Card List in collection View
    @IBOutlet var cardListCollection: UICollectionView!
    /// Card List in No Data View
    @IBOutlet var noDataView: UIView!
    /// Card List in No Data View
    @IBOutlet var cardView: UIView!
    /// info Label
    @IBOutlet weak var infoLabel: UILabel!
    /// noCard info label
    @IBOutlet weak var noCardInfoLabel: UILabel!
    /// Left line view in OR option
    @IBOutlet var leftLineView: UIView!
    /// Right line view in OR option
    @IBOutlet var rightLineView: UIView!
    /// OR Label
    @IBOutlet weak var orLabel: UILabel!
    // MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataView.isHidden = true
        cardView.isHidden = true
        setupNavigation()
        setDarkModeNeeds()
        callApi()
        // Do any additional setup after loading the view.
    }
    override func callApi() {
        carListing()
    }
}
// MARK: - Private Method
extension CSCardListViewController {
    /// Bind Data To collection View
    func bindData() {
        if self.cardListArray.count < 1 {
            noDataView.isHidden = false
            cardView.isHidden = true
            return
        }
        cardView.isHidden = false
        noDataView.isHidden = true
        cardListCollectionDataSources.cardList = self.cardListArray
        cardListCollection.reloadData()
    }
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        addLeftBarButton()
    }
    /// Add Alert With title and Message
    func showAlertView(_ sender: UIButton) {
        let title = NSLocalizedString("Delete Card", comment: "")
        let message = NSLocalizedString("Are you sure want to delete this card?", comment: "")
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"),
                                      style: .default, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"),
                                      style: .default, handler: { _ in
                                        self.deleteAddedCard(sender.tag)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    /// It sets changes that need to be made for dark mode
    func setDarkModeNeeds() {
        leftLineView.backgroundColor = .invertColor(true)
        rightLineView.backgroundColor = .invertColor(true)
        orLabel.textColor = .labelTextColor
        noDataView.backgroundColor = .background
        noCardInfoLabel.textColor = .labelTextColor
        infoLabel.textColor = .labelTextColor
    }
}
// MARK: - Button Action
extension CSCardListViewController {
    /// Deleted Card View
    @IBAction func deleteCardView(_ sender: UIButton) {
        showAlertView(sender)
    }
    /// End editing
    @IBAction func stopEditing(_ sender: Any) {
        self.view.endEditing(true)
    }
}
// MARK: - Api request
extension CSCardListViewController {
    /// Card Listing View controller
    func carListing() {
        CSCardApiModel.fetchCardApi(
            parentView: self,
            parameters: nil,
            completionHandler: { (response) in
                self.cardListArray = response.responce.cardListArray
                self.bindData()
        })
    }
    /// Delet Card
    func deleteAddedCard(_ index: Int) {
        let parameter: [String: String] = ["id": String(self.cardListArray[index].cardId)]
        CSCardApiModel.deletCardApi(
            parentView: self,
            parameters: parameter,
            completionHandler: { _ in
                self.cardListArray.remove(at: index)
                self.bindData()
        })
    }
}
