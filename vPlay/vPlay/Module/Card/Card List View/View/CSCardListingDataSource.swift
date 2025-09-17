//
//  CSCardListingDataSource.swift
//  vPlay
//
//  Created by user on 27/08/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
protocol CSCardDelegate: class {
    func makePaymentSuccess()
}
class CSCardListingDataSource: NSObject, UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    /// Table Delgate
    weak var delegate: CSCollectionViewDelegate?
    var cardList = [CSCardList]()
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return cardList.count
    }
    /// popuplate Collection view
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath)
            as? CSCardCollectionCell else { return UICollectionViewCell() }
        cell.cardListData(cardList[indexPath.row])
        cell.setDarkModeNeeds()
        if cell.deleteCard != nil {
            cell.deleteCard.tag = indexPath.row
        }
        if cell.selectCard != nil {
            cell.selectCard.tag = indexPath.row
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionviewDelegate(collectionView, didSelectItemAt: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let picDimension = collectionView.frame.size.width / 2.0 - 20
            return CGSize(width: picDimension, height: 220)
        } else {
            let picDimension = collectionView.frame.size.width
            let picDimensionheight = collectionView.frame.size.height
            return CGSize(width: picDimension, height: picDimensionheight)
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        } else {
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let cell: CSBaseCollectionViewCell = (cell as? CSBaseCollectionViewCell)!
        cell.collectionViewDisplayAnimation()
    }
}
