//
//  CSWebseriesPageViewController.swift
//  vPlay
//
//  Created by user on 06/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit
class CSWebseriesPageViewController: CSParentViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var episodeListTableView: UITableView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var readMoreTapGesture: UITapGestureRecognizer!
    // Video Description View
    var videoDescription: String!
    var selectedIndex: Int?
    var videoId = Int()
    var seasonVideoID = Int()
    var sharedData: CSSharedObject!
    var info: WebSeriesInfo!
    @IBOutlet weak var publishedDate: UILabel!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var thumbNailImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var starringTitle: UILabel!
    @IBOutlet weak var starringLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var genereLabel: UILabel!
    @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var seasonView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var genereView: UIView!
    @IBOutlet weak var publishedView: UIView!
    @IBOutlet weak var selectedSeason: UILabel!
    @IBOutlet var dynamicTextLabel: [UILabel]!
    var seasonTapGesture : UITapGestureRecognizer!
    var customDelegate: pushToViewDelegate!
    /// episode To PLayBack
    var episodeTableContentSize: NSKeyValueObservation?
    var currentPage = Int()
    var lastPage = Int()
    var selectedRow = Int()
    var relatedArray = [WebSeriesData]()
    var seasonsArray = [CSSeason]()
    var selectedSeasonID = Int()
    var paginatioManager: PaginationManager!
    override func viewDidLoad() {
        self.addGradientBackGround()
        self.setUINeeds()
        episodeAddObserverToTable()
        setColorByMode()
        showSkeleton()
        callApi()
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func callApi() {
        fetchWebseriesDetail()
    }
    /// Add Observer to Table of comment
    func episodeAddObserverToTable() {
        episodeTableContentSize = episodeListTableView.observe(
            \UITableView.contentSize,
            options: [.new],
            changeHandler: { _, value  in
                if let contentSize = value.newValue {
                    self.tableViewHeightConstraint.constant = contentSize.height + 20
                }
        })
    }
    // UI Needs
    func setUINeeds() {
        readMoreTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        readMoreTapGesture.delegate = self
        self.descriptionLabel.addGestureRecognizer(readMoreTapGesture)
        seasonTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onClickSeasonTap(_:)))
        seasonView.addGestureRecognizer(seasonTapGesture)
        self.episodeListTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        self.paginatioManager = PaginationManager(scrollView: self.scrollView, delegate: self)
        self.paginatioManager.updateActivityIndicatorColor(UIColor.black)
        dynamicTextLabel.forEach({$0.textColor = .labelTextColor})
    }
    @objc func onClickSeasonTap(_ sender: UITapGestureRecognizer? = nil) {
        if seasonsArray.count < 2 { return }
        var seasonsList = [String]()
        for season in seasonsArray {
            let value = season.seasonTitle
            seasonsList.append(value)
        }
        CSOptionDropDown.seasonDropdown(
            label: selectedSeason,
            dataSource: seasonsList,
            completionHandler: { index in
                self.currentPage = 0
                self.lastPage = 0
                self.relatedArray = [WebSeriesData]()
                self.selectedSeasonID = self.seasonsArray[index].seasonId
                self.webSeries()
        })
    }
    /// Web series
    func webSeries() {
        let paramet: [String: String] = [
            "page": String(currentPage)]
        CSVideoDetailApiModel.webseriesSeasonBasedRelated(
            parentView: episodeListTableView,
            path: String(seasonVideoID) + "/" + String(selectedSeasonID),
            isPageDisable: currentPage.checkPageNeed(),
            parameters: paramet,
            completionHandler: { response in
                if let seasonsList = response.response.seasonsList {
                    self.currentPage = seasonsList.currentPage
                    self.lastPage = seasonsList.lastPage
                    self.relatedArray = seasonsList.data
                    self.episodeLabel.text = "Episodes (\(self.relatedArray.count))"
                    self.episodeListTableView.reloadData()
                }
        })
    }
    @IBAction func shareAction(_ sender: UIButton) {
        self.sharedData = CSSharedObject.init(
            videoId: String(info.id), videoSlug: info.slug,
            thumbNail: info.seriesDetails.thumbnail, videoTitle: info.title,
            videoDescription: info.seriesDetails.description)
        self.deepLinkShare(sharedData, sender: sender, isVideoDetail: true)
    }
    /// To change color based on dark mode
    func setColorByMode() {
        self.addGradientBackGround()
        self.episodeListTableView.backgroundColor = .background
        self.contentView.backgroundColor = .navigationBarColor
        self.backgroundView.backgroundColor = .background
    }
    func fetchWebseriesDetail() {
        CSWebseriesDetailApiModel.fetchWebseriesDetailRequest(parentView: self, parameters: nil,
                                                              videoId: videoId) { (response) in
            self.hideSkeleton()
            self.bindSeriesInfo(response.response)
            self.bindRelatedData(response.response.related)
            self.bindSeasonData(response.response)
            self.seasonsArray = response.response.seasons
            self.episodeListTableView.reloadData()
        }
    }
    func bindSeriesInfo(_ response: WebSeriesResponse) {
        if let seriesData = response.info.seriesDetails {
            self.titleLabel.text = seriesData.seriesTitle
            self.descriptionLabel.text = seriesData.description
            videoDescription = self.descriptionLabel.text
            setDescription()
            self.starringLabel.text = seriesData.starring
            self.publishedDate.text = CSTimeAgoSinceDate.webSeriesVideoDateAsMMMDDYYYY(seriesData.createdDate)
            self.image.setBannerImageWithUrl(seriesData.poster)
            if let genereName = seriesData.genereContent?.genereName {
            self.genereLabel.text = genereName
                self.genereView.isHidden = false
            } else {
                self.genereView.isHidden = true
            }
            self.info = response.info
        }
    }
    func bindRelatedData(_ related: WebSeriesRelated) {
        relatedArray = related.data
        lastPage = related.lastPage
        currentPage = related.currentPage
        let count = relatedArray.count
        if count > 0 {
        seasonVideoID = relatedArray[0].id
        episodeLabel.text = "Episodes (\(count))"
        episodeLabel.isHidden = false
        } else {
            episodeLabel.isHidden = true
        }
    }
    func bindSeasonData(_ response: WebSeriesResponse) {
        seasonsArray = response.seasons
        selectedSeason.text = (seasonsArray.count > 0) ? seasonsArray[0].seasonTitle : ""
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relatedArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CSWebseriesTableviewCell
        cell.bindCellData(relatedArray[indexPath.row])
        cell.customDelegate = self
        cell.posterImage.tag = indexPath.row
        if indexPath.row != selectedIndex {
            cell.posterImage.isHidden = true
            cell.descriptionLabel.isHidden = true
            cell.topDescription.isHidden = false
        } else {
            cell.posterImage.isHidden = false
            cell.descriptionLabel.isHidden = false
            cell.topDescription.isHidden = true
        }
        //self.tableViewHeightConstraint.constant = self.tableView.contentSize.height + 20
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row ==  selectedIndex {
            return 360
        } else {
        return 80
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        if selectedIndex == indexPath.row {
            selectedIndex = nil
        } else {
            selectedIndex = indexPath.row }
        UIView.transition(with: tableView,
                          duration: 0.35,
                          options: .showHideTransitionViews,
                          animations: {
                            self.episodeListTableView.reloadData() })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CSVideoDetailViewController {
            let controller = segue.destination as? CSVideoDetailViewController
            let index = (sender as? Int)!
            controller?.videoId = relatedArray[index].id
        }
    }
}
// MARK: - Read More And Read Less label
extension CSWebseriesPageViewController: UIGestureRecognizerDelegate {
    /// Set Description
    func setDescription() {
        let arr = self.videoDescription.components(separatedBy: " ")
        if arr.count < 20 {
            descriptionLabel.text = self.videoDescription
            return
        } else {
            self.readMore()
        }
    }
    /// Read Less text
    func readLess() {
        let textData = self.videoDescription + " " + NSLocalizedString("Read Less", comment: "Video Detail")
        descriptionLabel.attributedText =
            textData.attributeTextProperty(appendtext: NSLocalizedString("Read Less", comment: "Video Detail"),
                                           color: .readMoreReadLessColor(), font: UIFont.fontNewLight())
    }
    /// Read More text
    func readMore() {
        let arr = self.videoDescription.components(separatedBy: " ")
        if arr.count <= 20 {
            descriptionLabel.attributedText =
                self.videoDescription.attributeTextProperty(appendtext: "", color: .readMoreReadLessColor(),
                                                            font: UIFont.fontNewLight())
            return
        }
        let textData = arr[0..<20].joined(separator: " ") + "..." +
            NSLocalizedString("Read More", comment: "Video Detail")
        descriptionLabel.attributedText =
            textData.attributeTextProperty(appendtext: NSLocalizedString("Read More", comment: "Video Detail"),
                                           color: .readMoreReadLessColor(), font: UIFont.fontNewLight())
    }
    /// Read More Read Less Button Action
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (descriptionLabel.text)!
        if text.contains(NSLocalizedString("Read More", comment: "Video Detail")) {
            readLess()
        } else if text.contains(NSLocalizedString("Read Less", comment: "Video Detail")) {
            readMore()
        }
    }
}
extension CSWebseriesPageViewController: pushToViewDelegate {
    func clickImageView(_ cell: AnyObject) {
        let buttonIndexpath = self.episodeListTableView.indexPath(for: cell as! UITableViewCell)
        selectedRow = buttonIndexpath!.row
        selectedIndex = nil
        self.episodeListTableView.reloadData()
        self.performSegue(withIdentifier: "videoDetail", sender: selectedRow)
    }
    /// Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
           episodeTableContentSize?.invalidate()
            self.navigationController?.popViewController(animated: true)
        }
    func showSkeleton() {
        self.image.showSkeletionView()
        self.descriptionLabel.showSkeletionView()
        self.titleLabel.showSkeleton()
        self.starringLabel.showSkeletionView()
        self.episodeLabel.showSkeletionView()
        self.starringTitle.showSkeletionView()
        self.seasonView.showSkeletionView()
        self.genereView.showSkeletionView()
        self.shareView.isHidden = true
        self.publishedView.isHidden = true
    }
    func hideSkeleton() {
        self.image.hideSkeleton()
        self.descriptionLabel.hideSkeleton()
        self.titleLabel.hideSkeleton()
        self.starringLabel.hideSkeleton()
        self.episodeLabel.hideSkeleton()
        self.starringTitle.hideSkeleton()
        self.seasonView.hideSkeleton()
        self.genereView.hideSkeleton()
        self.shareView.isHidden = false
        self.publishedView.isHidden = false
    }
}
extension CSWebseriesPageViewController: PaginationManagerDelegate {
    func paginationManagerShouldStartLoading(_ controller: PaginationManager) -> Bool {
        currentPage += 1
        if currentPage > lastPage {
            return false
        }
        return true
    }
    
    func paginationManagerDidStartLoading(_ controller: PaginationManager, onCompletion: @escaping CompletionHandler) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { () -> Void in
            onCompletion()
        }
    }
}
