/*
 * CSSubscriptionDataSource.swift
 * This class is used as a data source for Subscription Plan
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import StoreKit
class CSSubscriptionDataSource: NSObject, UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    /// Plan List Array
    var subscriptionList = [PlanList]()
    /// Current Subscribed
    var currentSubscribed = PlanList()
    // Active In app IDs
    var products: [SKProduct] = []
    /// Delegate
    weak var delegate: CSCollectionViewDelegate?
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return subscriptionList.count
    }
    /// popuplate Collection view
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath)
            as? CSSubscriptionCollectionCell else { return UICollectionViewCell() }
//        cell.bindDataToSubscription(subscriptionList[indexPath.row])
        let currentPlan = subscriptionList[indexPath.row]
        var currentProduct = SKProduct()
        for product in products where product.productIdentifier == currentPlan.inAppID {
            currentProduct = product
        }
        // cell.bindDataToSubscription(currentPlan)
        cell.bindSubscription(currentPlan, product: currentProduct)
        cell.backView.backgroundColor = (LibraryAPI.sharedInstance.isDarkMode()) ? UIColor.navigationColor() : UIColor.invertColor(false)
        if subscriptionList[indexPath.row].planId == currentSubscribed.planId {
            cell.showSubscribedImage(true)
        } else {
            cell.showSubscribedImage(false)
        }
        cell.subscriptionButton.tag = indexPath.row
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionviewDelegate(collectionView, didSelectItemAt: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let cell: CSBaseCollectionViewCell = (cell as? CSBaseCollectionViewCell)!
        cell.collectionViewDisplayAnimation()
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picDimensionheight = CGFloat(225) // collectionView.frame.size.height - 30
        let picDimension = picDimensionheight * 0.85
        print("\(picDimension) = \(collectionView.frame.size.height - 30)")
        return CGSize(width: picDimension, height: picDimensionheight)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        } else {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 15
        } else {
            return 10.0
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 15
        } else {
            return 10.0
        }
    }
}
