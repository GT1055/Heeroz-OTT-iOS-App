//
//  CSLiveCollectionDataSources.swift
//  vPlay
//
//  Created by user on 03/05/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import SkeletonView
class CSLiveCollectionDataSources: NSObject,
UICollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /// Table Delgate
    weak var delegate: CSCollectionViewDelegate?
    var liveVideoArray = [UpcomingliveVideosList]()
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return liveVideoArray.count.countCheck()
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "collectionCell"
    }
    /// popuplate Collection view
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "collectionCell", for: indexPath) as? CSLiveCollectionViewCell
            else { return UICollectionViewCell() }
        if !liveVideoArray.count.checkDataPresent() {
            return cell
        }
        cell.hideSkeletonAnimation()
        cell.addLiveData(self.liveVideoArray[indexPath.row])
        cell.addedTapGesture(indexPath.row)
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
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let width = (collectionView.frame.size.width - 75) / 4
            let height = width * 1.35
            return CGSize(width: width, height: height)
        } else {
            let width = (collectionView.frame.size.width / 3) - 15
            let height = width * 1.6
            return CGSize(width: width, height: height)
        }
    }
}
