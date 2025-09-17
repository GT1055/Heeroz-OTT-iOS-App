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
import ImageSlideshow
import FSPagerView
// MARK: - Table view Data Source
extension CSCategoryVideoListViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "Cell"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.moviesArray.count != 0) ? self.moviesArray.count : 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.moviesArray.count != 0 {
            if moviesArray[indexPath.row].categoryBanner.isEmpty == false {
                return (UIDevice.current.userInterfaceIdiom == .pad) ? 480 : 364.5
            } else {
                return (UIDevice.current.userInterfaceIdiom == .pad) ? 250 : 200
            }
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 250
        } else {
            return 200
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !moviesArray.count.checkDataPresent() {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as?
                    CSHomeTableViewCell else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as?
                    CSHomeTableViewCell else { return UITableViewCell() }
            cell.slideshow.superview?.showSkeletionView()
            
            if moviesArray[indexPath.row].categoryBanner.isEmpty == false {
                cell.BannerView.isHidden = true
                cell.miniBanner.isHidden = false
                cell.miniPagination.isHidden = false
                
                for content in cell.miniBanner.subviews {
                    content.removeFromSuperview()
                }
                let pagerView = FSPagerView(frame: cell.miniBanner.bounds)
                pagerView.dataSource = self
                pagerView.delegate = self
                pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
                pagerView.itemSize = FSPagerView.automaticSize
                pagerView.tag = indexPath.row
                pagerView.automaticSlidingInterval = 5
                pagerView.isInfinite = true
                cell.miniBanner.addSubview(pagerView)
                cell.miniPagination.isHidden = true
//                for content in cell.miniPagination.subviews {
//                    content.removeFromSuperview()
//                }
//                let pageControl = FSPageControl(frame: cell.miniPagination.bounds)
//                pageControl.numberOfPages = moviesArray[indexPath.row].categoryBanner.count
//                pageControl.contentHorizontalAlignment = .center
//                pageControl.backgroundColor = .clear
//                cell.miniPagination.addSubview(pageControl)
            } else {
                cell.BannerView.isHidden = true
                cell.miniBanner.isHidden = true
                cell.miniPagination.isHidden = true
            }

//            if moviesArray[indexPath.row].categoryBanner.isEmpty == false {
//                var alamofireImage = [InputSource]()
//                cell.BannerView.isHidden = false
//                let categoryBanner = moviesArray[indexPath.row].categoryBanner
//
//                for value in categoryBanner {
//                    if !value.bannerPosterImage.isEmpty {
//                        let imageString: String = value.bannerPosterImage.addingPercentEncoding(withAllowedCharacters:
//                                                                                                    NSCharacterSet.urlQueryAllowed)!
//                        let url = URL(string: imageString)
//                        alamofireImage.append(AlamofireSource.init(url: url!))
//                    } else {
//                        let imafes = UIImage.init(color: .backgroundColor())!
//                        alamofireImage.append(ImageSource(image: imafes))
//                    }
//                    self.cellBannerImageSider(alamofireSource: alamofireImage, currentArray: categoryBanner, cell: cell)
//                    cell.slideshow.tag = indexPath.row
//                }
//            } else {
//                cell.BannerView.isHidden = true
//            }
            
            cell.hideSkeletonAnimation()
            cell.setModeBasedColor()
            cell.headerTitle.text = self.moviesArray[indexPath.row].title
            cell.noDataLabel.text = NSLocalizedString("No new Movie(s) Found", comment: "NoData")
            cell.checkCountAndHideVideo(self.moviesArray[indexPath.row].movieList.count)
            cell.viewAllButton.isHidden = true
            return cell
        }
    }
    /// Banner Image Slider
    /// - Parameter alamofireSource: alamofire as! input
    func cellBannerImageSider(alamofireSource: [InputSource], currentArray: [CSBannerData], cell: CSHomeTableViewCell) {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomePageViewController.didTap(currentTap:)))
        cell.slideshow.addGestureRecognizer(gestureRecognizer)
        cell.slideshow.backgroundColor = UIColor.white
        cell.slideshow.slideshowInterval = 5
        cell.slideshow.pageIndicator = nil
        cell.slideshow.circular = true
        cell.pageControl.numberOfPages = alamofireSource.count
        cell.slideshow.contentScaleMode = UIView.ContentMode.scaleToFill
        cell.slideshow.activityIndicator = DefaultActivityIndicator()
        if currentArray[0].bannerVideoUrl.isEmpty == false{
            cell.didBannerClicked.isHidden = false
        }
        //cell.bannarTitle.text = currentArray[0].bannerCategoryTitle
        cell.slideshow.currentPageChanged = { [unowned cell] page in
            //cell.bannarTitle.text = currentArray[page].bannerCategoryTitle
            cell.pageControl.currentPage = page
            if currentArray[page].bannerVideoUrl.isEmpty == false
            {
                cell.didBannerClicked.isHidden = false
            }else
            {
                cell.didBannerClicked.isHidden = true
                
            }
        }
        cell.slideshow.setImageInputs(alamofireSource)
    }

    @objc func didTap(currentTap: UITapGestureRecognizer) {
        let view = currentTap.view!
        let tableRow = view.tag
        let currentCellData = self.moviesArray[tableRow]
        let currentIndex = IndexPath(row: tableRow, section: 0)
        if let currrentCell = self.categoryTable.cellForRow(at: currentIndex) as? CSHomeTableViewCell {
            let selectedBanner = currentCellData.categoryBanner[currrentCell.slideshow.currentPage]
            if selectedBanner.bannerVideoUrl.isEmpty == false
            {
                 if selectedBanner.bannerVideoUrl.contains("vplayed-catrack-uat.contus.us") || selectedBanner.bannerVideoUrl.contains("staging.heeroz.tv")
                               {
                                let slugArray = selectedBanner.bannerVideoUrl.components(separatedBy: "/")
                                let slugName = slugArray.first
                                print(slugName)
                                slugVideoId(selectedBanner.bannerVideoUrl)
                               }else{
                                   let url = NSURL(string: selectedBanner.bannerVideoUrl)!
                                       UIApplication.shared.open(url as URL)
                               }

                               //self.performSegue(withIdentifier: "videoDetail", sender: 537)
            }
        }
    }
    // call api To Take Home page Data
    func slugVideoId(_ id: String) {
        CSHomeApiModel.SlugVideoId(parentView: self,
                                      parameters: nil,
                                      slugid: id,
                                      completionHandler: { response in
                                        self.dataSetToSlugId(response.slugVideoResponce)
        })
    }
    // Get Slug Details
    func dataSetToSlugId(_ data: CSSlugVideoKey){
        print(data.id)
         self.videoId = data.id
        self.performSegue(withIdentifier: "videoDetail", sender: nil)
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

extension CSCategoryVideoListViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return moviesArray[pagerView.tag].categoryBanner.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        if pagerView.tag < moviesArray.count {
            if index < moviesArray[pagerView.tag].categoryBanner.count {
                let bannerData = moviesArray[pagerView.tag].categoryBanner
                cell.imageView?.image = nil
                cell.imageView?.setBannerImageWithUrl(bannerData[index].bannerPosterImage)
                let videoURL = bannerData[index].bannerVideoUrl
                let indexPath = IndexPath(row: pagerView.tag, section: 0)
                let tableCell = self.categoryTable.cellForRow(at: indexPath) as? CSHomeTableViewCell
                tableCell?.playButtonIcon.isHidden = videoURL.isEmpty
//                var isPlayHidden = true
//                if !videoURL.isEmpty {
//                    isPlayHidden = false
//                }
//                if let cellView = pagerView.superview?.superview {
//                    for playButton in cellView.subviews where playButton.tag == 90 {
//                        playButton.isHidden = isPlayHidden
//                    }
//                }
            }
        }
        return cell
    }
        
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        
        if pagerView.tag < moviesArray.count {
            if index < moviesArray[pagerView.tag].categoryBanner.count {
                let currentObj = moviesArray[pagerView.tag].categoryBanner[index]
                self.newRedirect(currentObj.bannerVideoUrl)
            }
        }
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
//        let cell = self.categoryTable.cellForRow(at: IndexPath(row: pagerView.tag, section: 0)) as? CSHomeTableViewCell
//        if let currentCell = cell {
//            let pageControl = currentCell.miniPagination.subviews[0] as? FSPageControl
//            pageControl?.currentPage = targetIndex
//        }
    }
    
    func redirect(_ to: String) {
        guard let currentURL = URL(string: to) else { return }
        UIApplication.shared.open(currentURL)
    }

    func newRedirect(_ to: String) {
        if to.isEmpty == false {
            if to.contains("vplayed-catrack-uat.contus.us") || to.contains("staging.heeroz.tv") ||
                to.contains("heeroz.tv") {
                guard let slugName = to.components(separatedBy: "/").last else { return }
                slugVideoId(slugName)
            } else {
                self.redirect(to)
            }
        }
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
//        let cell = self.categoryTable.cellForRow(at: IndexPath(row: pagerView.tag, section: 0)) as? CSHomeTableViewCell
//        if let currentCell = cell {
//            let pageControl = currentCell.miniPagination.subviews[0] as? FSPageControl
//            pageControl?.currentPage = pagerView.currentIndex
//        }
    }

}

// MARK: - Collection view Delegate and Data Sources
extension CSCategoryVideoListViewController: UICollectionViewDelegate, SkeletonCollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.moviesArray.count != 0 {
            return self.moviesArray[collectionView.tag].movieList.count
        } else {
            return 10
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cell", for: indexPath)
                as? CSHomeCollectionCell else { return UICollectionViewCell() }
            if !moviesArray.count.checkDataPresent() { return cell }
            cell.hideSkeletonAnimation()
            if isWebSeries == 0 {
                cell.homePageVideoDataBind(self.moviesArray[collectionView.tag].movieList[indexPath.row])
            } else {
                cell.webseriesVideoData(self.moviesArray[collectionView.tag].movieList[indexPath.row])
            }
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.moviesArray.count == 0 { return }
        self.videoId = self.moviesArray[collectionView.tag].movieList[indexPath.row].movieId
        self.selectedCategoryId = self.moviesArray[collectionView.tag].categoryId
        self.performSegue(withIdentifier: "videoDetail", sender: nil)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picDimensionheight = collectionView.frame.size.height - 20
        let picDimension = picDimensionheight * 0.58
        return CGSize(width: picDimension, height: picDimensionheight)
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let cell: CSBaseCollectionViewCell = (cell as? CSBaseCollectionViewCell)!
        if self.moviesArray.count != 0 {
            if !isHorizontalLoader {
                cell.addShadownAndAnimation()
            }
            if self.moviesArray[collectionView.tag].movieList.count == (indexPath.row + 1) {
                if !isHorizontalLoader, self.moviesArray[collectionView.tag].currentPage
                    < self.moviesArray[collectionView.tag].lastPage {
                    callRecentVideos(collectionView.tag)
                }
            }
        }
    }
}
