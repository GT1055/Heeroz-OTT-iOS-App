/*
 * CSCategoryVideoListViewController+Extension.swift
 * This class is used as a extension Class For Category Page
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import SkeletonView
// MARK: - Table view Data Source
extension CSCategorywiseWebseries: UITableViewDelegate, SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "Cell"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreSeriesData.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 250
        } else {
            return 200
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as?
            CSHomeTableViewCell else { return UITableViewCell() }
        if indexPath.row == 0 {
            if mainSeriesData.data.count != 0 {
                cell.hideSkeletonAnimation()
                cell.setModeBasedColor()
                cell.headerTitle.text = self.mainSeriesData.categoryName
                cell.noDataLabel.text = NSLocalizedString("No new Videos(s) Found", comment: "")
                cell.viewAllButton.isHidden = true
            }
        } else {
            if genreSeriesData.count != 0 {
                cell.hideSkeletonAnimation()
                cell.setModeBasedColor()
                let newIndex = indexPath.row - 1
                if newIndex < genreSeriesData.count {
                    cell.headerTitle.text = self.genreSeriesData[newIndex].name
                }
                cell.noDataLabel.text = NSLocalizedString("No new Videos(s) Found", comment: "")
                cell.viewAllButton.isHidden = true
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? CSHomeTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? CSHomeTableViewCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}
// MARK: - Collection view Delegate and Data Sources
extension CSCategorywiseWebseries: UICollectionViewDelegate, SkeletonCollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            if self.mainSeriesData.data.count != 0 {
                return mainSeriesData.data.count
            } else {
                return 10
            }
        } else {
            let newIndex = collectionView.tag - 1
            if self.genreSeriesData[newIndex].seriesData.data.count != 0 {
                return genreSeriesData[newIndex].seriesData.data.count
            } else {
                return 10
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cell", for: indexPath)
                as? CSHomeCollectionCell else { return UICollectionViewCell() }
            if collectionView.tag == 0 {
                if !self.mainSeriesData.data.count.checkDataPresent() { return cell }
                cell.hideSkeletonAnimation()
                cell.webseriesVideoContent(mainSeriesData.data[indexPath.row])
            } else {
                let newIndex = collectionView.tag - 1
                if !self.genreSeriesData[newIndex].seriesData.data.count.checkDataPresent() { return cell }
                cell.hideSkeletonAnimation()
                cell.webseriesVideoContent(genreSeriesData[newIndex].seriesData.data[indexPath.row])
            }
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // if self.seriesArray.count == 0 { return }
        if collectionView.tag == 0 {
            self.videoId = mainSeriesData.data[indexPath.row].id
        } else {
            self.videoId = genreSeriesData[collectionView.tag - 1].seriesData.data[indexPath.row].id
        }
        self.performSegue(withIdentifier: "webSeriesDetail", sender: nil)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picDimensionheight = collectionView.frame.size.height - 20
        let picDimension = picDimensionheight * 0.70
        return CGSize(width: picDimension, height: picDimensionheight)
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            if mainSeriesData.data.count == indexPath.row + 1 && !isHorizontalPagination {
                if currentPage < lastPage {
                    currentPage += 1
                    isHorizontalPagination = true
                    self.webSeriesPagination()
                }
            }
        } else {
            let newIndex = collectionView.tag - 1
            if genreSeriesData[newIndex].seriesData.data.count == indexPath.row + 1 && !isHorizontalPagination {
                if genreCurrent < genreLast {
                    genreCurrent += 1
                    paginationTag = newIndex
                    isHorizontalPagination = true
                    self.genereSeriesPagination()
                }
            }
        }
    }
}
