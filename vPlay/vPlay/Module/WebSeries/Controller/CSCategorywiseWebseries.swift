//
//  CSCategorywiseWebseries.swift
//  vPlay
//
//  Created by user on 11/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit
class CSCategorywiseWebseries: CSParentViewController {
    /// Category Table
    @IBOutlet var webSeriesTable: UITableView!
    /// Boolean for pagination
    var isHorizontalPagination = false
    // Page Index
    var lastPage = 0
    // Current Index
    var currentPage = 0
    /// Genre Current Page
    var genreCurrent = 0
    /// Genre Last Page
    var genreLast = 0
    /// video ID
    var categoryId = 0
    /// Pagination Tag
    var paginationTag = 0
    /// video Id
    var videoId = 0
    /// Series Data
    var mainSeriesData = CSSeries()
    /// Genre Data
    var genreSeriesData = [CSGenre]()
    /// is From web series
    var isWebSeries = Int()
    /// Horizontal Load More
    var isHorizontalLoader = false
    /// Use to store offset Valuse
    var storedOffsets = [Int: CGFloat]()
    /// Pull to refresh declaration
    fileprivate var refreshManager: PullToRefreshManager!
    /// Pagination manger declaration
    fileprivate var paginatioManager: PaginationManager!
    // MARK: - UIView Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        registerRefreshIndicator()
        callApi()
    }
    override func callApi() {
        currentPage = 1
        webSeriesData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webSeriesDetail" {
            let controller = segue.destination as? CSWebseriesPageViewController
            controller?.videoId = self.videoId
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CSCategorywiseWebseries {
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        addLeftBarButton()
    }
    /// register Refresh controller adding
    func registerRefreshIndicator() {
        // If you want to use Pull To Refresh
        self.refreshManager = PullToRefreshManager(scrollView: self.webSeriesTable, delegate: self)
        self.refreshManager.updateActivityIndicatorStyle(.white)
        self.refreshManager.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
    func refreshWebSeries() {
        if mainSeriesData.data.count == 0 {
            if genreSeriesData.count == 0 {
                self.addChildView(identifier: "CSRecordView", storyBoard: alertStoryBoard)
                return
            }
        }
        self.webSeriesTable.reloadData()
    }
}
// MARK: - Delegate Method
extension CSCategorywiseWebseries: CSCollectionViewDelegate {
    func collectionviewDelegate(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "webSeriesDetail", sender: nil)
    }
}
// MARK: - API REQUEST
extension CSCategorywiseWebseries {
    // call api To Take Home page Data
    func webSeriesData() {
        let parameter = ["page": String(self.currentPage)]
        CSCategoryApiModel.webSeriesVideoList(parentView: self,
                                              parameters: parameter,
                                              isPaging: currentPage.checkPageNeed(),
                                              categoryId: String(categoryId),
                                              completionHandler: { response in
                                                if response.response.mainSeries.count > 0 {
                                                    self.currentPage = response.response.mainSeries[0].currentPage
                                                    self.lastPage = response.response.mainSeries[0].lastPage
                                                    self.mainSeriesData = response.response.mainSeries[0]
                                                    self.refreshWebSeries()
                                                }
                                                self.genereWebseriesData()
        })
    }
    func webSeriesPagination() {
        let parameter = ["page": String(self.currentPage)]
        CSCategoryApiModel.webSeriesVideoList(parentView: self,
                                              parameters: parameter,
                                              isPaging: currentPage.checkPageNeed(),
                                              categoryId: String(categoryId),
                                              completionHandler: { response in
                                                if response.response.mainSeries.count > 0 {
                                                    self.currentPage = response.response.mainSeries[0].currentPage
                                                    self.lastPage = response.response.mainSeries[0].lastPage
                                                    for data in response.response.mainSeries[0].data {
                                                        self.mainSeriesData.data.append(data)
                                                    }
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                                                        self.isHorizontalPagination = false
                                                    })
                                                    self.refreshWebSeries()
                                                }
        })
    }
    func genereWebseriesData() {
        CSCategoryApiModel.webSeriesVideoList(parentView: self,
                                              parameters: nil,
                                              isPaging: currentPage.checkPageNeed(),
                                              categoryId: String(categoryId) + "?section=2",
                                              completionHandler: { response in
                                                self.genreSeriesData = response.response.genreSeries
                                                if self.genreSeriesData.count > 0 {
                                                    self.genreCurrent = response.response.genreSeries[self.paginationTag].seriesData.currentPage
                                                    self.genreLast = response.response.genreSeries[self.paginationTag].seriesData.lastPage
                                                }
                                                self.refreshWebSeries()
        })
    }
    func genereSeriesPagination() {
        // /api/v2/more_child_webseries?&type=genre&category=series_id&genre=genre_id&page=page_number
        let type = "genre"
        let categoryID = String(categoryId)
        let genreID = String(genreSeriesData[paginationTag].id)
        let pageNumber = String(genreCurrent)
        let full = "?&type=" + type + "&category=" + categoryID + "&genre=" + genreID + "&page=" + pageNumber
        CSCategoryApiModel.loadMorewebSeriesList(parentView: self,
                                                 parameters: nil,
                                                 isPaging: currentPage.checkPageNeed(),
                                                 categoryId: full,
                                                 completionHandler: { response in
                                                    self.genreCurrent = response.response.moreSeries.seriesData.currentPage
                                                    self.genreLast = response.response.moreSeries.seriesData.lastPage
                                                    for data in response.response.moreSeries.seriesData.data {
                                                        self.genreSeriesData[self.paginationTag].seriesData.data.append(data)
                                                    }
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                                                        self.isHorizontalPagination = false
                                                    })
                                                    self.refreshWebSeries()
        })
    }
}
// MARK: - Pull to Refresh
extension CSCategorywiseWebseries: PullToRefreshManagerDelegate {
    public func pullToRefreshManagerDidStartLoading(_ controller: PullToRefreshManager,
                                                    onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.callApi()
        }
    }
}
