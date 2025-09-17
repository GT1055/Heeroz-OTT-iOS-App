//
//  Purchaselist.swift
//  vPlay
//
//  Created by user on 10/07/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
class CSPurchaselistViewcontroller: CSParentViewController, CSTableViewDelegate {
    // purchase Tableview
    @IBOutlet var purchaseTableview: UITableView!
    // Purchase Data Sources
    @IBOutlet var purchaseDataSources: CSPurchasevideoDatasource!
    /// Index Path
    var currentIndexPath: Int!
    // current Page
    var currentPage = 0
    // Last Page
    var lastPage = 0
    /// Purchased Video List
    var purchaseDetails = [PurchaseDetail]()
    /// Store api response
    var purchaseApiResponse: PurchaseResponse?
    /// Pull to refresh declaration
    fileprivate var refreshManager: PullToRefreshManager!
    /// Pagination manger declaration
    fileprivate var paginatioManager: PaginationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setUINeeds()
        registerRefreshIndicator()
    }
    override func callApi() {
        currentPage = 1
        lastPage = 1
        purchaseDetails = [PurchaseDetail]()
        fetchPurchasedVideos()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        callApi()
    }
    func fetchPurchasedVideos() {
        let param: [String: String] = ["filter": "",
                                       "filters": "",
                                       "orderByFieldName": "",
                                       "intialRequest": "0",
                                       "rowsPerPage": "10",
                                       "searchRecord": "",
                                       "page": String(self.currentPage)]
        CSPurchaseListApiModel.fetchPurchasedVideos(parentView: self,
                                                    isPageing: currentPage.checkPageNeed(),
                                                    parameters: param ,
                                                    completionHandler: { response in
            self.currentPage = response.responseRequired.currentPage
            self.lastPage = response.responseRequired.lastPage
           // self.purchaseApiResponse = response.responseRequired
            self.purchaseDetails += response.responseRequired.purchaseDetail
            if self.purchaseDetails.count < 1 {
                self.addChildView(identifier: "NoPurchasedVideos", storyBoard: alertStoryBoard)
            }
        self.purchaseDataSources.purchaseDetails = self.purchaseDetails
        self.purchaseTableview.reloadData()
        })
    }
    // UI Needs
    func setUINeeds() {
        self.purchaseTableview.contentInset = UIEdgeInsets(top: 10, left: 0,
                                                          bottom: 10, right: 0)
        self.purchaseDataSources.delegate = self
    }
    // It adds the notification bar.
    func setupNavigation() {
        controllerTitle = NSLocalizedString("My Purchased Videos", comment: "Menu")
        addGradientBackGround()
        addLeftBarButton()
    }
    func tableviewDelegate(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentIndexPath = indexPath.row
        self.performSegue(withIdentifier: "videoDetail", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "videoDetail" {
            let controller = segue.destination as? CSVideoDetailViewController
            controller?.parent?.hidesBottomBarWhenPushed = true
            controller?.videoId = purchaseDetails[currentIndexPath].videoId
        }
    }
}
// MARK: - Private Method
extension CSPurchaselistViewcontroller {
    /// register Refresh controller adding
    func registerRefreshIndicator() {
        self.purchaseTableview.contentInset = UIEdgeInsets(top: 5, left: 0,
                                                           bottom: 5, right: 0)
        // If you want to use Pull To Refresh
        self.refreshManager = PullToRefreshManager(scrollView: self.purchaseTableview, delegate: self)
        self.refreshManager.updateActivityIndicatorStyle(.white)
        self.refreshManager.updateActivityIndicatorColor(UIColor.invertColor(true))
        // If you want to use Pagination
        self.paginatioManager = PaginationManager(scrollView: self.purchaseTableview, delegate: self)
        self.paginatioManager.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
}
// MARK: - Pull to Refresh
extension CSPurchaselistViewcontroller: PullToRefreshManagerDelegate {
    public func pullToRefreshManagerDidStartLoading(_ controller: PullToRefreshManager,
                                                    onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.callApi()
        }
    }
}
// MARK: - vertical pagenation for
extension CSPurchaselistViewcontroller: PaginationManagerDelegate {
    public func paginationManagerDidStartLoading(_ controller: PaginationManager, onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.fetchPurchasedVideos()
        }
    }
    public func paginationManagerShouldStartLoading(_ controller: PaginationManager) -> Bool {
        currentPage += 1
        if currentPage > self.lastPage {
            return false
        }
        return true
    }
}
