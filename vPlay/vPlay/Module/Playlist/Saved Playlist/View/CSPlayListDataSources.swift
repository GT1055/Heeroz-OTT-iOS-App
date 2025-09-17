/*
 * CSPlayListAndLatestDataSources.swift
 * This class is used for handling playlist Data Sources
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import SkeletonView
class CSPlayListDataSources: NSObject, SkeletonCollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    /// Playlisr Video Listing
    var playList = [CSPlayList]()
    /// Table Delgate
    weak var delegate: CSCollectionViewDelegate?
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return playList.count.countCheck()
    }
    /// popuplate Collection view
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath)
            as? CSPlaylistsCollectionViewCell else { return UICollectionViewCell() }
        if !playList.count.checkDataPresent() { return cell }
        cell.bindData(playList[indexPath.row])
        cell.followButton.tag = indexPath.row
        cell.hideSkeletonAnimation()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionviewDelegate(collectionView, didSelectItemAt: indexPath)
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let picDimension = collectionView.frame.size.width / 3.0 - 20
            let picDimensionHeight = picDimension * 0.73
            return CGSize(width: picDimension, height: picDimensionHeight)
        } else {
            let picDimension = collectionView.frame.size.width / 2.0 - 20
            let picDimensionHeight = picDimension * 0.98
            return CGSize(width: picDimension - 6, height: picDimensionHeight)
        }
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
            return UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
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
