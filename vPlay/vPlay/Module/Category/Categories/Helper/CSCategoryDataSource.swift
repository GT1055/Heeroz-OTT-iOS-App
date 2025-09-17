///
//  CSCategoryDataSource.swift
//  vPlay
//
//  Created by user on 30/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class CSCategoryDataSource: NSObject, UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    /// Table Delgate
    weak var delegate: CSCollectionViewDelegate?
    /// Category List
    var categoryList = [CSCategoryList]()
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return categoryList.count.countCheck()
    }
    /// popuplate Collection view
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath)
            as? CSCategoriesCollectionCell else { return UICollectionViewCell() }
        if !categoryList.count.checkDataPresent() { return cell }
        cell.hideSkeletonAnimation()
        cell.bindData(categoryList[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionviewDelegate(collectionView, didSelectItemAt: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let picDimension = collectionView.frame.size.width / 3.0 - 20
            return CGSize(width: picDimension, height: picDimension * 0.75)
        } else {
            let picDimension = (collectionView.frame.size.width - 30) / 2.0
            return CGSize(width: picDimension, height: picDimension * 0.75) //Setting Sizes
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let cell: CSBaseCollectionViewCell = (cell as? CSBaseCollectionViewCell)!
        if categoryList.count != 0 {
            cell.addShadownAndAnimation()
        }
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
            return 10
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 15
        } else {
            return 10
        }
    }
}
