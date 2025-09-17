/*
 * CSLiveViewController
 * This Controller is used to display the Live videos
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import SkeletonView
// MARK: - Table view Data Source
extension CSLiveViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.liveVideoList.count != 0) ? self.liveVideoList.count : 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 250
        } else {
            return 210
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as?
            CSLiveTableViewCell else { return UITableViewCell() }
        if !liveVideoList.count.checkDataPresent() { return cell }
        cell.hideSkeletonAnimation()
        cell.setDarkModeNeeds()
        cell.headerTitle.text = self.liveVideoList[indexPath.row].liveVideoTitle
        cell.collectionView.tag = indexPath.row
        cell.viewAllButton.tag = indexPath.row
        cell.viewAllButton.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? CSLiveTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? CSLiveTableViewCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}
// MARK: - Collection view Delegate and Data Sources
extension CSLiveViewController: UICollectionViewDelegate, SkeletonCollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "collectionUntagCell"
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.liveVideoList.count != 0) ?  self.liveVideoList[collectionView.tag].liveVideoArray.count : 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
            if !liveVideoList.count.checkDataPresent() {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "collectionUntagCell", for: indexPath) as? CSLiveCollectionViewCell
                    else { return UICollectionViewCell() }
                return cell
            }
            if "Upcomingnow" == self.liveVideoList[collectionView.tag].slug {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "collectionUntagCell", for: indexPath) as? CSLiveCollectionViewCell
                    else { return UICollectionViewCell() }
                cell.hideSkeletonAnimation()
                cell.bindDataToMoreLiveVideos(
                    self.liveVideoList[collectionView.tag].liveVideoArray[indexPath.row])
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "collectionCell", for: indexPath) as? CSLiveCollectionViewCell
                    else { return UICollectionViewCell() }
                cell.hideSkeletonAnimation()
                cell.bindDataToLiveVideos(
                    self.liveVideoList[collectionView.tag].liveVideoArray[indexPath.row],
                    index: collectionView.tag)
                return cell
            }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.liveVideoList.count == 0 { return }
        self.performSegue(withIdentifier: "liveVideoDetail",
                          sender: self.liveVideoList[collectionView.tag].liveVideoArray[indexPath.row].idData)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picDimensionheight = collectionView.frame.size.height - 20
        let picDimension = picDimensionheight * 0.65
        return CGSize(width: picDimension, height: picDimensionheight)
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let cell: CSBaseCollectionViewCell = (cell as? CSBaseCollectionViewCell)!
        if self.liveVideoList.count != 0 {
            if !isHorizontalLoader {
                cell.addShadownAndAnimation()
            }
            if "Upcomingnow" == self.liveVideoList[collectionView.tag].slug,
                self.liveVideoList[collectionView.tag].liveVideoArray.count == (indexPath.row + 1) {
                if !isHorizontalLoader, self.liveVideoList[collectionView.tag].currentPage
                    < self.liveVideoList[collectionView.tag].lastPage {
                    fetchMoreLiveVideos(collectionView.tag)
                }
            }
        }
    }
}
extension CSLiveViewController: BMPlayerDelegate {
    /// Check Network
    func checkNetworkAndStorePlayBack() {
        if !Connectivity.isConnectedToInternet() {
            self.showToastMessageTop(message: "The Internet connection appears to be offline")
            self.playerView.pause()
            return
        }
    }
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        if state == .buffering {
            self.checkNetworkAndStorePlayBack()
        }
    }
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval,
                  totalDuration: TimeInterval) {
    }
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
    }
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
    }
    func setupLiveChatView() {
        self.liveChatTapGesture = UITapGestureRecognizer(target: self, action: #selector(myviewTapped(_:)))
        liveChatTapGesture.delegate = self
        liveChatView?.addGestureRecognizer(liveChatTapGesture)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setupLiveChatLayout), userInfo: nil, repeats: true)
        setupLiveChatLayout()
    }
    @objc func setupLiveChatLayout() {
        //self.view.endEditing(true)
        let isMaskShowing = playerView.customControlView?.isMaskShowing ?? false
        liveChatViewTop.constant = isMaskShowing ? 50 : 0
        liveChatViewBottom.constant = isMaskShowing ? -50 : 0
        UIView.animate(withDuration: 0.2) { self.view.layoutIfNeeded() }
    }
    /// Method to show xray tableview
    func showLiveChatView() {
        UIView.animate(withDuration: 0.4) { self.liveChatView?.alpha = 1 }
    }
    /// Method to hide xray tableview
    func dismissLiveChatView() {
        UIView.animate(withDuration: 0.4) { self.liveChatView?.alpha = 0 }
    }
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        if let playerViewable = (playerView.customControlView as? BMPlayerCustomControlView) {
            playerViewable.controlViewAnimation(isShow: true)
        }
    }
}
extension CSLiveViewController: ControlViewDelegate {
    func didTapqueue() {
    }
    func didtapXray(_ sender: UIButton) {
    }
    func didtapChatbutton(_ sender: UIButton) {
        self.view.endEditing(true)
        sender.isSelected  = !sender.isSelected
        liveChatView?.isHidden = sender.isSelected ? true : false
        if let playerViewable = (playerView.customControlView as? BMPlayerCustomControlView) {
            sender.isSelected ? playerViewable.chatButton.setImage(UIImage.init(named: "chat-show"), for: .selected) : playerViewable.chatButton.setImage(UIImage.init(named: "chat-hide"), for: .selected) }
    }
    func didtapXrayViewAll(_ sender: UIButton) {
    }
}
