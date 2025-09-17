/*
 * CSCateoryViewController.swift
 * This class is used to view all the category present in this application
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
class CSCateoryViewController: CSParentViewController {
    /// Category Table
    @IBOutlet var categoryCollection: UICollectionView!
    /// Category Data Source
    @IBOutlet var categoryDataSource: CSCategoryDataSource!
    /// Pull to refresh declaration
    fileprivate var refreshManager: PullToRefreshManager!
    /// Pagination manger declaration
    fileprivate var paginatioManager: PaginationManager!
    // Current Language
    var currentLanguage = CSLanguage.currentAppleLanguage()
    // Current Page
    var currentPage = 0
    // Last Page
    var lastPage = 0
    /// Category List
    var categoryList = [CSCategoryList]()
    // MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerRefreshIndicator()
        callApi()
        self.changeLangauge()
        // Do any additional setup after loading the view.
     //   self.addChildView1(identifier: "Minimediacontroller", storyBoard: alertStoryBoard)
    }
    override func viewWillAppear(_ animated: Bool) {
        if islangauge(currentLanguage) { return }
        self.addGradientBackGround()
        self.chanageRefreshIndicator(refreshManager)
    }
    override func callApi() {
        super.callApi()
        currentPage = 1
        self.categoryList = [CSCategoryList]()
        fetchCategoryList()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CSCategoryVideoListViewController {
            let controller = segue.destination as? CSCategoryVideoListViewController
            let index = (sender as? Int)!
            controller?.controllerTitle = categoryList[index].categoryTitle
            controller?.categoryId = categoryList[index].categoryId
            controller?.isWebSeries = categoryList[index].isWebSeries
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()
        UIImageView.af_sharedImageDownloader.imageCache?.removeAllImages()
        UIImageView.af_sharedImageDownloader.sessionManager.session.configuration.urlCache?.removeAllCachedResponses()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        URLCache.shared.removeAllCachedResponses()
        UIImageView.af_sharedImageDownloader.imageCache?.removeAllImages()
        UIImageView.af_sharedImageDownloader.sessionManager.session.configuration.urlCache?.removeAllCachedResponses()
    }
    deinit {
        print("Its deinited finally")
    }
}
// MARK: - Private Method
extension CSCateoryViewController {
    /// Reload Data
    func reloadData() {
        if self.categoryList.count < 1 {
            self.addChildView(identifier: "NoCategory", storyBoard: alertStoryBoard)
            return
        }
        categoryDataSource.delegate = self
        categoryDataSource.categoryList = self.categoryList
        categoryCollection.reloadData()
    }
    /// register Refresh controller adding
    func registerRefreshIndicator() {
        // If you want to use Pull To Refresh
        self.refreshManager = PullToRefreshManager(scrollView: self.categoryCollection, delegate: self)
        self.refreshManager.updateActivityIndicatorStyle(.white)
        self.refreshManager.updateActivityIndicatorColor(UIColor.invertColor(true))
        // If you want to use Pagination
        self.paginatioManager = PaginationManager(scrollView: self.categoryCollection, delegate: self)
        self.paginatioManager.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
    /// Check Langauge
    func changeLangauge() {
        if currentLanguage != CSLanguage.currentAppleLanguage() {
            currentLanguage = CSLanguage.currentAppleLanguage()
            self.addGradientBackGround()
            self.chanageRefreshIndicator(refreshManager)
        }
    }
}
extension CSCateoryViewController: CSCollectionViewDelegate {
    func collectionviewDelegate(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "categoryMovie", sender: indexPath.row)
    }
}
// MARK: - Api Request Method's
extension CSCateoryViewController {
    func fetchCategoryList() {
        let paramet = ["page": String(currentPage)]
        CSCategoryApiModel.getCategoryList(parentView: self,
                                           parameters: paramet,
                                           completionHandler: { [unowned self] responce in
                                            self.currentPage = responce.responseRequired.categoryData.currentPage
                                            self.lastPage = responce.responseRequired.categoryData.lastPage
                                            self.categoryList += responce.responseRequired.categoryData.categoryList
                                            self.reloadData()
        })
    }
}
// MARK: - Pull to Refresh
extension CSCateoryViewController: PullToRefreshManagerDelegate {
    /// Pull to refresh Manager start Method
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
extension CSCateoryViewController: PaginationManagerDelegate {
    /// Pagiantion Manager start loading
    public func paginationManagerDidStartLoading(_ controller: PaginationManager,
                                                 onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.fetchCategoryList()
        }
    }
    /// Check is Pagination Needed
    public func paginationManagerShouldStartLoading(_ controller: PaginationManager) -> Bool {
        currentPage += 1
        if currentPage > self.lastPage {
            return false
        }
        return true
    }
}
