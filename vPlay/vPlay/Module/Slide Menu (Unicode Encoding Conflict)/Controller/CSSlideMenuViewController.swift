/*
 * CSSlideMenuViewController.swift
 * This class is used to create user account information List
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit

class CSSlideMenuViewController: CSParentViewController {
    // Header menu
    @IBOutlet weak var headerMenu: UIView!
    // side menu
    @IBOutlet var sideMenuTable: UITableView!
    // side menu
    @IBOutlet var profileName: UILabel!
    // Plan Name
    @IBOutlet var planLabel: UILabel!
    // side menu
    @IBOutlet var profileImage: UIImageView!
    // Menu Table Height
    @IBOutlet var sideMenuTableHeight: NSLayoutConstraint!
    // Plan name
    @IBOutlet weak var planName: UILabel!
    // Plan days
    @IBOutlet weak var planDays: UILabel!
    // Plan indicator label
    @IBOutlet weak var planIndicator: UILabel!
    // Plan view
    @IBOutlet weak var planView: UIView!
    // Plan view button
    @IBOutlet weak var planViewButton: UIButton!
    // profile name centre
    @IBOutlet weak var profileNameCenterConstraint: NSLayoutConstraint!
    /// Data Load
    var dataLoad = [[String: Any]]()
    // save Current Time
    var currentLiveTime = String()
    // save Current Time
    var currentLanguage = CSLanguage.currentAppleLanguage()
    /// Like To PLayBack
    var tableContentSize: NSKeyValueObservation?
    // MARK: - UIView Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        planLabel.text = NSLocalizedString("Plan - ", comment: "")
        self.addGradientBackGround()
        tableContentSize = sideMenuTable.observe(
            \UITableView.contentSize,
            options: [.new],
            changeHandler: { _, value  in
                if let contentSize = value.newValue {
                    self.sideMenuTableHeight.constant = contentSize.height
                }
        })
        self.changeOfLangauge()
    }
    deinit {
        tableContentSize?.invalidate()
    }
    override func callApi() {
        if self.islangauge(currentLanguage) { return }
        dataLoad = MENUDATA
        setDataToTable()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setColorByMode()
        callApi()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// To change color based on dark mode
    func setColorByMode() {
        self.addGradientBackGround()
        headerMenu.backgroundColor = .navigationBarColor
        profileName.textColor = UIColor.invertColor(true)
        planIndicator.textColor = UIColor.invertColor(true)
        sideMenuTable.reloadData()
    }
    /// Change of Langauge
    func changeOfLangauge() {
        if currentLanguage != CSLanguage.currentAppleLanguage() {
            currentLanguage = CSLanguage.currentAppleLanguage()
            setColorByMode()
            dataLoad = MENUDATA
            setDataToTable()
        }
    }
}
// MARK: - Button Action Methods
extension CSSlideMenuViewController {
    /// Show Profile button Action
    @IBAction func showProfileDetails(_ sender: UIButton) {
        if !UIApplication.isUserLoginInApplication() { return }
        let profileView = profileStoryBoard.instantiateViewController(withIdentifier:
            "CSEditProfileViewController")
        self.navigationController?.pushViewController(profileView, animated: true)
    }
    /// Show Subscription button Action
    @IBAction func showPlanDetails(_ sender: UIButton) {
            let subscriptionView = subscriptionStoryBoard.instantiateViewController(withIdentifier:
                       "CSSubscriptionViewController")
                   self.navigationController?.pushViewController(subscriptionView, animated: true)
    }
}
// MARK: - Private Methods
extension CSSlideMenuViewController {
    // set profile name and image of current user
    func changeProfileDetails() {
        if LibraryAPI.sharedInstance.getUserName().isEmpty {
            profileName.text = NSLocalizedString("Welcome To Heeroz", comment: "Menu")
            profileImage.image = UIImage.init(named: "HLogo")
            profileImage.contentMode = .scaleAspectFit
            changeCenterConstraint(false)
            profileImage.layer.cornerRadius = 0
            return
        } else {
            profileImage.setProfileImageWithUrl(LibraryAPI.sharedInstance.getUserImageUrl())
            planLabel.text = " "
            profileName.text = " " + LibraryAPI.sharedInstance.getUserName()
            self.planName.text = NSLocalizedString("SUBSCRIBE NOW", comment: "")
            if LibraryAPI.sharedInstance.isUserSubscibed() {
                planLabel.text = NSLocalizedString("Plan - ", comment: "")
                self.planName.text = LibraryAPI.sharedInstance.getPlanName()
                self.planDays.text = LibraryAPI.sharedInstance.getBalanceDays()
                profileName.text = LibraryAPI.sharedInstance.getUserName()
            }
            self.changeCenterConstraint(true)
            profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        }
        profileImage.layer.masksToBounds = true
    }
    /// To change center constraint
    func changeCenterConstraint(_ isShow: Bool) {
        self.planView.isHidden = !isShow
        self.planViewButton.isHidden = self.planView.isHidden
        self.profileNameCenterConstraint.constant = !isShow ? 0 : 30
    }
    /// Set Data To Table
    func setDataToTable() {
        if LibraryAPI.sharedInstance.getUserId().isEmpty {
            dataLoad.remove(at: 15)
            dataLoad.remove(at: 13)
            dataLoad.remove(at: 9)
            dataLoad.remove(at: 8)
            dataLoad.remove(at: 7)
            dataLoad.remove(at: 5)
            dataLoad.remove(at: 4)
            dataLoad.remove(at: 3)
            dataLoad.remove(at: 2)
            dataLoad.remove(at: 1)
        } else {
            dataLoad.remove(at: 13)
            dataLoad.remove(at: 9)
            dataLoad.remove(at: 8)
            dataLoad.remove(at: 1)
            dataLoad.remove(at: 0)
        }
        if !NEXTLIVETIME.isEmpty {
            self.setNextLiveDateToDelegate(NEXTLIVETIME)
        }
        self.changeProfileDetails()
        sideMenuTable.reloadData()
        sideMenuTable.layoutIfNeeded()
    }
    /// Save Card To History Section
    func moveToSavedSection(_ index: Int) {
        let storyboard = dataLoad[index]["storyBoard"] as? UIStoryboard
        let identifier = (dataLoad[index]["identifier"] as? String)!
        let controller = storyboard?.instantiateViewController(withIdentifier:
            identifier) as? CSCardListViewController
        controller?.controllerTitle = NSLocalizedString((dataLoad[index]["title"] as? String)!, comment: "Menu")
        //controller?.isSavedCard = true
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    /// Add Alert With title and Message
    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"),
                                      style: .default, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"),
                                      style: .destructive, handler: { _ in
                                        self.clearUserSession()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    /// Not Login in user
    func navigationForNonLoginUser(_ index: Int) {
        let storyboard = dataLoad[index]["storyBoard"] as? UIStoryboard
        let identifier = (dataLoad[index]["identifier"] as? String)!
        if index == 0 {
            self.addLoginCloseIfUserNotLogin(self)
            return
        }
        let controller = storyboard?.instantiateViewController(withIdentifier:
            identifier) as? CSParentViewController
        controller?.controllerTitle =
            NSLocalizedString((dataLoad[index]["title"] as? String)!, comment: "Menu")
        self.navigationController?.pushViewController(controller!, animated: true)
    }
}
// MARK: - Set Next Date
extension CSSlideMenuViewController {
    /// Change Live Video
    func setNextLiveDateToDelegate(_ nextLive: String) {
        if currentLiveTime == NEXTLIVETIME {
            return
        }
        currentLiveTime = NEXTLIVETIME
        sideMenuTable.reloadData()
    }
}
// MARK: - TableView Delegate and Datasources
extension CSSlideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLoad.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as? CSSlideMenuTableCell else { return UITableViewCell() }
        cell.setModeBaseColor()
        cell.menuTitle.text = NSLocalizedString((dataLoad[indexPath.row]["title"] as? String)!, comment: "Menu")
        cell.menuImage.image = UIImage.init(named: (dataLoad[indexPath.row]["image"] as? String)!)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataLoad[indexPath.row]["title"] as? String == NSLocalizedString("Rate us on the App Store",
                                                                            comment: "Menu") {
            let url = URL(string: BASEURL)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            return
        }
        if dataLoad[indexPath.row]["title"] as? String == NSLocalizedString("FAQ", comment: "") {
            redirect("https://heeroz.tv/content/heeroz-faq")
            return
        }
        /// Not Login user
        if LibraryAPI.sharedInstance.getUserId().isEmpty {
            self.navigationForNonLoginUser(indexPath.row)
            return
        }
        // Logout
        if indexPath.row == (dataLoad.count - 1) {
            self.showAlertView(title: NSLocalizedString("Sign out", comment: "SignUp"),
                               message: NSLocalizedString("Do you want to sign out?", comment: "SignUp"))
            return
        }
        // Save Card Section
        if dataLoad[indexPath.row]["title"] as? String == NSLocalizedString("Saved Card", comment: "Menu") {
            self.moveToSavedSection(indexPath.row)
            return
        }
        let storyboard = dataLoad[indexPath.row]["storyBoard"] as? UIStoryboard
        let identifier = (dataLoad[indexPath.row]["identifier"] as? String)!
        let controller = storyboard?.instantiateViewController(withIdentifier:
            identifier) as? CSParentViewController
        controller?.controllerTitle =
            NSLocalizedString((dataLoad[indexPath.row]["title"] as? String)!, comment: "Menu")
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    func redirect(_ to: String) {
        guard let currentURL = URL(string: to) else { return }
        UIApplication.shared.open(currentURL)
    }
}
// MARK: - Call Api
extension CSSlideMenuViewController {
    /// method to logout and clear session
    func clearUserSession() {
        let paramet: [String: String] = [
            "device_type": "IOS",
            "id": LibraryAPI.sharedInstance.getUserId()]
        CSMenuApiModel.logoutApi(
            parentView: self,
            parameters: paramet,
            completionHandler: { _ in
                self.showToastMessageTop(message: NSLocalizedString("Sign out successfully", comment: "SignUp"))
                LibraryAPI.sharedInstance.setUserDefaults(key: "UserID", value: "")
                LibraryAPI.sharedInstance.setUserDefaults(key: "Token", value: "")
                LibraryAPI.sharedInstance.setUserDefaults(key: "planName", value: "")
                LibraryAPI.sharedInstance.setUserDefaults(key: "planDuration", value: "")
                LibraryAPI.sharedInstance.setUserDefaults(key: "planStartDate", value: "")
                LibraryAPI.sharedInstance.setUserDefaults(key: "Name", value: "")
                LibraryAPI.sharedInstance.setUserDefaults(key: "imageUrl", value: "")
                LibraryAPI.sharedInstance.setUserDefaults(key: "notificationCount", value: "0")
                LibraryAPI.sharedInstance.setUserDefaults(key: "isSubscribed", value: "0")
                for tracks in CSDownloadManager.shared.activeTracks {
                    CSDownloadManager.shared.cancelDownload(tracks)
                }
                CSDownloadManager.shared.activeTracks.removeAll()
                CSApiHttpRequest.sharedInstance.removeCache()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    UIApplication.shared.keyWindow?.rootViewController =
                        UIApplication.setRootViewController()
                    if let statusBar = UIApplication.shared.statusBarUIView {
                        statusBar.backgroundColor = UIColor.navigationColor()
                    }
                })
        })
    }
}
