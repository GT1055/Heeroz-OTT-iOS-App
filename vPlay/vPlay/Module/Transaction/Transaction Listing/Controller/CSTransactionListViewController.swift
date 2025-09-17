//
//  CSTransactionListViewController.swift
//  This Controller is used to List the transaction history of User
//  vPlay
//
//  Created by user on 29/08/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
class CSTransactionListViewController: CSParentViewController {
    // The Transaction Table View
    @IBOutlet var transactionTable: UITableView!
    // Transaction Data Sources
    @IBOutlet var transactionDataSources: CSTransactionDataSources!
    // current Page
    var currentPage = 0
    // Last Page
    var lastPage = 0
    /// Transaction List
    var transactionList = [TransactionDataArray]()
    /// Pull to refresh declaration
    fileprivate var refreshManager: PullToRefreshManager!
    /// Pagination manger declaration
    fileprivate var paginatioManager: PaginationManager!
    // MARK: - UIView Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        registerRefreshIndicator()
        callApi()
    }
    override func callApi() {
        if LibraryAPI.sharedInstance.getUserId().isEmpty {
            self.addLoginIfUserNotLogin(self)
            return
        }
        currentPage = 1
        lastPage = 1
        transactionList = [TransactionDataArray]()
        showTransactionList()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CSTransactionDetailViewController {
            let index = (sender as? Int)!
            let controller = segue.destination as? CSTransactionDetailViewController
            controller?.details = transactionList[index]
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
// MARK: - Api Request
extension CSTransactionListViewController {
    // Transaction Listing
    func showTransactionList() {
        let param: [String: String] = ["filter": "",
                                       "filters": "",
                                       "orderByFieldName": "",
                                       "intialRequest": "0",
                                       "rowsPerPage": "10",
                                       "searchRecord": "",
                                       "page": String(self.currentPage)]
        CSTransactionApiModel.listAllTransaction(parentView: self,
                                                 isPageing: currentPage.checkPageNeed(),
                                                 parameter: param ,
                                                 completionHandler: { response in
                                                    self.currentPage = response.requriedResponce.currentpage
                                                    self.lastPage = response.requriedResponce.lastpage
                                                    self.transactionList += response.requriedResponce.dataListArray
                                                    self.reloadData()
        })
    }
}
// MARK: - Private Method
extension CSTransactionListViewController {
    /// register Refresh controller adding
    func registerRefreshIndicator() {
        self.transactionTable.contentInset = UIEdgeInsets(top: 5, left: 0,
                                                          bottom: 5, right: 0)
        // If you want to use Pull To Refresh
        self.refreshManager = PullToRefreshManager(scrollView: self.transactionTable, delegate: self)
        self.refreshManager.updateActivityIndicatorStyle(.white)
        self.refreshManager.updateActivityIndicatorColor(UIColor.invertColor(true))
        // If you want to use Pagination
        self.paginatioManager = PaginationManager(scrollView: self.transactionTable, delegate: self)
        self.paginatioManager.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
    /// Reload Data
    func reloadData() {
        if self.transactionList.count < 1 {
            self.addChildView(identifier: "NoTranscation", storyBoard: alertStoryBoard)
        }
        transactionDataSources.transactionList = self.transactionList
        transactionDataSources.delegate = self
        transactionTable.reloadData()
    }
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        addLeftBarButton()
        addRightBarButton()
    }
}
extension CSTransactionListViewController: CSTableViewDelegate {
    func tableviewDelegate(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailsView", sender: indexPath.row)
    }
}
// MARK: - Pull to Refresh
extension CSTransactionListViewController: PullToRefreshManagerDelegate {
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
extension CSTransactionListViewController: PaginationManagerDelegate {
    public func paginationManagerDidStartLoading(_ controller: PaginationManager, onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.showTransactionList()
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
