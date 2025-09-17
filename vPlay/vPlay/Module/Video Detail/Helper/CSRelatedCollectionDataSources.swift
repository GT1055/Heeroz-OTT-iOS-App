/*
 * CSRelatedCollectionDataSources.swift
 * This is data source is used to list all the related Data or Movie Data or
 * Favourite Data Or History Data in a collection View
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import SkeletonView
class CSRelatedCollectionDataSources: NSObject, SkeletonCollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    /// Play List Array
    var relatedVideo = [CSMovieData]()
    /// Movid Data for View All
    var movieData = [CSMovieData]()
    /// favourite Video List
    var favouriteListArray = [CSMovieData]()
    /// Table Delgate
    weak var delegate: CSCollectionViewDelegate?
    /// Collection Tag
    enum CollectionTag: Int {
        case favouriteTag = 2 /* Collection View is Favourite Collection */
        case historyTag = 3 /* Collection View is History Collection */
        case videoDetailTag = 4 /* Collection View is VideoDetail Collection */
        case searchTableTag = 5 /* Collection View is Search Table Collection */
        case playListDataTag = 6 /* Collection View is Playlist Collection */
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if CollectionTag.favouriteTag.rawValue == collectionView.tag {
            return favouriteListArray.count.countCheck()
        } else if CollectionTag.historyTag.rawValue == collectionView.tag {
            return movieData.count.countCheck()
        } else if CollectionTag.searchTableTag.rawValue == collectionView.tag {
            return movieData.count
        } else {
            return relatedVideo.count.countCheck()
        }
    }
    /// popuplate Collection view
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath)
            as? HomeCollectionViewCell else { return UICollectionViewCell() }
        if CollectionTag.favouriteTag.rawValue == collectionView.tag {
            if !favouriteListArray.count.checkDataPresent() { return cell }
            cell.videoDataForMovie(favouriteListArray[indexPath.row])
            cell.videoFavouriteImage.image = #imageLiteral(resourceName: "favourite")
        } else if CollectionTag.historyTag.rawValue == collectionView.tag {
            if !movieData.count.checkDataPresent() { return cell }
            cell.videoDataForMovie(movieData[indexPath.row])
            cell.videoFavouriteImage.image = #imageLiteral(resourceName: "clear")
            cell.videoFavouriteImage.tintColor = UIColor.convertHexStringToColor(ICONLIGHTCOLOR)
        }
        return collectionViewExtension(collectionView, indexPath: indexPath, cell: cell)
    }
    func collectionViewExtension(_ collectionView: UICollectionView,
                                 indexPath: IndexPath,
                                 cell: HomeCollectionViewCell) -> UICollectionViewCell {
        if CollectionTag.searchTableTag.rawValue == collectionView.tag {
            if !movieData.count.checkDataPresent() { return cell }
            cell.bindSearchData(movieData[indexPath.row])
        } else if CollectionTag.playListDataTag.rawValue == collectionView.tag {
            if !relatedVideo.count.checkDataPresent() { return cell }
            cell.videoDataForMovie(relatedVideo[indexPath.row])
        } else if CollectionTag.videoDetailTag.rawValue == collectionView.tag {
            if !relatedVideo.count.checkDataPresent() { return cell }
            cell.videoDataForMovie(relatedVideo[indexPath.row])
        }
        cell.videoFavourite.tag = indexPath.row
        if cell.openOptionButton != nil {
            cell.openOptionButton.tag = indexPath.row
        }
        cell.hideSkeletonAnimation()
        if CollectionTag.videoDetailTag.rawValue == collectionView.tag {
            cell.videoTitle.superview?.backgroundColor = .videoDetailRelatedBackground
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionviewDelegate(collectionView, didSelectItemAt: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        /* Horiontal Collection View */
        if CollectionTag.videoDetailTag.rawValue == collectionView.tag {
            let picDimensionheight = collectionView.frame.size.height - 30
            return CGSize(width: picDimensionheight * 0.58, height: picDimensionheight)
        } else {
            /* Vertical Collection View */
            if UIDevice.current.userInterfaceIdiom == .pad {
                let picDimension = collectionView.frame.size.width / 4.0 - 20
                return CGSize(width: picDimension, height: picDimension * 1.30)
            } else {
                let picDimension = (collectionView.frame.size.width/3.3) - 15
                return CGSize(width: picDimension, height: picDimension * 1.70)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        /* Horiontal Collection View */
        if CollectionTag.videoDetailTag.rawValue == collectionView.tag {
            return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        } else {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            } else {
                return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            }
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
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let cell: CSBaseCollectionViewCell = (cell as? CSBaseCollectionViewCell)!
        if collectionView.tag == CollectionTag.searchTableTag.rawValue {
            return
        }
        cell.addShadownAndAnimation()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == CollectionTag.searchTableTag.rawValue {
            delegate?.collectionViewDidScroll!(scrollView)
        }
    }
}
extension Int {
    func countCheck() -> Int {
        return self == 0 ? 10 : self
    }
    func checkDataPresent() -> Bool {
        if self == 0 {
            return false
        }
        return true
    }
}
