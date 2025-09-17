/*
 * CSElasticSearchViewController.swift
 * This controller is used to get user search data from backend Data Base
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
class CSElasticSearchViewController: CSParentViewController {
    /// Search Table
    @IBOutlet var searchTable: UICollectionView!
    /// Search Data Sources
    @IBOutlet var searchTableDataSource: CSRelatedCollectionDataSources!
    // Search bar
    @IBOutlet var searchBar: UISearchBar!
    // Search bar
    @IBOutlet var searchBarHeaderView: UIView!
    // No data LAbel
    @IBOutlet var nodataLabel: UILabel!
    // No result View
    @IBOutlet var noResultView: UIView!
    // No result View
    @IBOutlet var noResultLabel: UILabel!
    // Search Back Button
    @IBOutlet var backButton: UIButton!
    /// Current Video
    var currentPage = 0
    /// Last Video
    var lastPage = 0
    /// Pull to refresh declaration
    fileprivate var refreshManager: PullToRefreshManager!
    /// Pagination manger declaration
    fileprivate var paginatioManager: PaginationManager!
    /// An array for video search results array
    var searchVideosArray = [CSMovieData]()
    /// Search Task
    var searchTask: DispatchWorkItem?
    // MARK: - UILife Cycle View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        nodataLabel.isHidden = true
        //        nodataLabel.isHidden = false
        //        nodataLabel.text = NSLocalizedString("Please enter a keyword to search",
        //                                             comment: "Search")
        addGradientBackGround()
        changePlaceHolderFontSize()
        registerRefreshIndicator()
        searchBar.becomeFirstResponder()
        searchBarHeaderView.backgroundColor = .navigationBarColor
        noResultView.backgroundColor = .background
        noResultLabel.textColor = UIColor.themeColorButton()
        backButton.tintColor = .iconColor()
        searchBar.tintColor = .iconColor()
        searchBar.textColor = .invertColor(true)
        nodataLabel.textColor = .invertColor(true)
        // Do any additional setup after loading the view.
    }
    override func callApi() {
        currentPage = 1
        searchVideosArray = [CSMovieData]()
        self.searchApiCall()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "videoDetail" {
            let index = (sender as? Int)!
            let controller = segue.destination as? CSVideoDetailViewController
            controller?.videoId = searchVideosArray[index].movieId
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: - Private Method
extension CSElasticSearchViewController {
    /// Place Holder Font Size
    func changePlaceHolderFontSize() {
        searchBar.superview?.backgroundColor = .navigationColor()
        searchBar.textColor = UIColor.black
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        let placeholderLabel = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
        placeholderLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    /// register Refresh controller adding
    func registerRefreshIndicator() {
        // If you want to use Pagination
        self.paginatioManager = PaginationManager(scrollView: self.searchTable, delegate: self)
        self.paginatioManager.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
    /// Load data to Table
    func loadDataToTable() {
        searchTableDataSource.delegate = self
        searchTableDataSource.movieData = searchVideosArray
        searchTable.reloadData()
        if searchVideosArray.count < 1 {
            noResultView.isHidden = false
        } else {
            noResultView.isHidden = true
        }
    }
}
// MARK: - Table Delegate
extension CSElasticSearchViewController: CSCollectionViewDelegate {
    func collectionviewDelegate(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "videoDetail", sender: indexPath.row)
    }
    func collectionViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
// MARK: - Search Bar Delegate
extension CSElasticSearchViewController: UISearchBarDelegate {
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
        searchBar.showsCancelButton = true
    }
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        CSApiHttpRequest.sharedInstance.cancelRequest(ELASTICSEARCH)
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.callApi()
        }
        self.searchTask = task
        // Execute task in 0.75 seconds (if not cancelled !)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
    }
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        CSApiHttpRequest.sharedInstance.cancelRequest(ELASTICSEARCH)
    }
}
// MARk: - Api Request
extension CSElasticSearchViewController {
    func searchApiCall() {
        let parameter: [String: String] =
            ["page": String(currentPage),
             "q": searchBar.text!]
        CSElasticSearchApiModel.getElasticSearchData(
            parentView: self, parameters: parameter,
            completionHandler: { responce in
                self.currentPage = responce.searchPage.currentPage
                self.lastPage = responce.searchPage.lastPage
                if self.currentPage == 1 {
                    self.searchVideosArray = [CSMovieData]()
                }
                self.searchVideosArray += responce.searchPage.movieList
                self.loadDataToTable()
        })
    }
}
// MARK: - vertical pagenation for
extension CSElasticSearchViewController: PaginationManagerDelegate {
    public func paginationManagerDidStartLoading(_ controller: PaginationManager,
                                                 onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.searchApiCall()
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
