/*
 * CSSubscriptionViewController.swift
 * This class is used to list all subscription plan avaliable in the application from IAP
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import StoreKit
// Custom delegate after getting success IAP
protocol customIapDelegate {
    func successResponse(transaction: SKPaymentTransaction)
    func failureResponse()
    func enableView()
    func disableView()
}
class CSSubscriptionViewController: CSParentViewController {
    /// Subscription Scroll
    @IBOutlet var subscriptionScroll: UIScrollView!
    /// Subscription Collection
    @IBOutlet var subscriptionCollection: UICollectionView!
    /// Subscription Data Source
    @IBOutlet var subscriptionDataSource: CSSubscriptionDataSource!
    /// Content Header Label
    @IBOutlet weak var contentHeaderLabel: UILabel!
    /// subsctiption collection height
    @IBOutlet var subscriptionHConstraint: NSLayoutConstraint!
    /// Scroll H Constraint
    @IBOutlet weak var scrollHConstraint: NSLayoutConstraint!
    /// Read important
    @IBOutlet weak var readLabel: UILabel!
    /// Terms Label
    @IBOutlet weak var termsLabel: UILabel!
    /// Privacy Label
    @IBOutlet weak var privacyLabel: UILabel!
    /// Originals Imageview
    @IBOutlet weak var originalImage: UIImageView!
    /// Static images
    @IBOutlet var staticImages: [UIImageView]!
    /// Static Label
    @IBOutlet var staticLabels: [UILabel]!
    // @IBOutlet weak var listingView: UIView!
    /// Current Video
    var currentPage = 0
    /// Last Video
    var lastPage = 0
    /// Pull to refresh declaration
    fileprivate var refreshManager: PullToRefreshManager!
    /// Pagination manger declaration
    fileprivate var paginatioManager: PaginationManager!
    /// Plan List Array
    var subscriptionList = [PlanList]()
    /// Current Subscribed
    var currentSubscribed = PlanList()
    /// is Via Video Detail Page
    var isViaVideo = false
    /// Get product Id
    var products: [SKProduct] = []
    // Indicatorview
    var activityView: UIActivityIndicatorView = UIActivityIndicatorView()
    var paymentActivityView: UIActivityIndicatorView = UIActivityIndicatorView()
    // Plan ID string
    var getPlanID = String()
    var Amount = String()
    var PaidAmount = String()
    var planDuration = String()
    var CurrencyType = String()
    let termsURL = "https://heeroz.tv/content/terms-and-conditions"
    let policyURL = "https://heeroz.tv/content/privacy-policy"
    // MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        inAppIdentifiers.store.iapDelegate = self
        setupNavigation()
        registerRefreshIndicator()
        addRedirection()
        self.callApi()
    }
    override func callApi() {
        subscriptionList = [PlanList]()
        currentPage = 1
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        subscriptionListing()
        addGradientBackGround()
        setModeBaseColor()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CSPaymentOptionViewController {
            let index = (sender as? Int)!
            let controller = segue.destination as? CSPaymentOptionViewController
            controller?.controllerTitle = NSLocalizedString("Checkout", comment: "error")
            controller?.subscriptionPlanId = subscriptionList[index]
            controller?.isVideoPage = isViaVideo
        }
    }
    // Add indicator
//    func setIndicator() {
//        activityView.center = CGPoint(x: listingView.bounds.size.width/2, y: listingView.bounds.size.height/2)
//        activityView.hidesWhenStopped = true
//        activityView.style = LibraryAPI.sharedInstance.isDarkMode() ? UIActivityIndicatorView.Style.white : UIActivityIndicatorView.Style.gray
//        listingView.addSubview(activityView)
//        activityView.startAnimating()
//    }
    // Payment Add indicator
    func setPaymentIndicator() {
        paymentActivityView.center = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        paymentActivityView.hidesWhenStopped = true
        paymentActivityView.style = LibraryAPI.sharedInstance.isDarkMode() ? UIActivityIndicatorView.Style.whiteLarge : UIActivityIndicatorView.Style.gray
        self.view.addSubview(paymentActivityView)
        paymentActivityView.startAnimating()
    }
    func addRedirection() {
        let termsTap = UITapGestureRecognizer(target: self, action: #selector(self.onClickRedirect(_:)))
        termsLabel.addGestureRecognizer(termsTap)
        
        let privacyTap = UITapGestureRecognizer(target: self, action: #selector(self.onClickRedirect(_:)))
        privacyLabel.addGestureRecognizer(privacyTap)
    }
    @objc func onClickRedirect(_ sender: UITapGestureRecognizer) {
        guard let currentView = sender.view as? UILabel else { return }
        let currentLink = (currentView.tag == 10) ? termsURL : policyURL
        self.redirect(currentLink)
    }
    func redirect(_ to: String) {
        guard let currentURL = URL(string: to) else { return }
        UIApplication.shared.open(currentURL)
    }
    /// backAction Controller Navigation
    /// - Parameter sender: Self
    override func backdismissAction(sender: UIButton) {
        if let viewControllers = self.navigationController?.viewControllers {
            for contoller in viewControllers where contoller is CSVideoDetailViewController {
                let viewController = (contoller as? CSVideoDetailViewController)!
                viewController.callApi()
                self.navigationController?.popToViewController(viewController, animated: true)
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    func setModeBaseColor() {
        contentHeaderLabel.textColor = UIColor.invertColor(true)
        privacyLabel.textColor = UIColor.invertColor(true)
        termsLabel.textColor = UIColor.invertColor(true)
        readLabel.textColor = UIColor.invertColor(true)
        for singleImage in staticImages {
            singleImage.tintColor = UIColor.invertColor(true)
        }
        for singleLabel in staticLabels {
            singleLabel.textColor = UIColor.invertColor(true)
        }
        let imageToShow = LibraryAPI.sharedInstance.isDarkMode() ? "White_Original" : "Black_Original"
        originalImage.image = UIImage(named: imageToShow)
    }
}
// MARK: - Delegate method for Pay Ment Success Status
extension CSSubscriptionViewController: CSCardDelegate {
    func makePaymentSuccess() {
        callApi()
    }
}
// MARK: - Private Method
extension CSSubscriptionViewController {
    /// Reload Data
    func reloadData() {
        if self.subscriptionList.count < 1 {
            self.addChildView(identifier: noDataIdentifier, storyBoard: alertStoryBoard)
        }
        subscriptionDataSource.delegate = self
        subscriptionDataSource.currentSubscribed = self.currentSubscribed
        subscriptionDataSource.subscriptionList = self.subscriptionList
        subscriptionCollection.reloadData()
    }
    // It adds the notification bar.
    func setupNavigation() {
        controllerTitle = NSLocalizedString("Pricing", comment: "Menu")
        addLeftBarButton()
    }
    /// register Refresh controller adding
    func registerRefreshIndicator() {
        // If you want to use Pull To Refresh
        self.refreshManager = PullToRefreshManager(scrollView: self.subscriptionScroll, delegate: self)
        self.refreshManager.updateActivityIndicatorStyle(.white)
        self.refreshManager.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
}
// MARK: - Button Action
extension CSSubscriptionViewController: customIapDelegate {
    
    // Enable view
       func enableView() {
           paymentActivityView.stopAnimating()
           self.view.isUserInteractionEnabled = true
           self.navigationController?.navigationBar.isUserInteractionEnabled = true
       }
       // Disable view
       func disableView() {
           setPaymentIndicator()
           self.view.isUserInteractionEnabled = false
           self.navigationController?.navigationBar.isUserInteractionEnabled = false
       }
           
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }

    
       // IAP Response Method
    func successResponse(transaction: SKPaymentTransaction) {
           activityView.startAnimating()
//        let orderID = transaction.transactionIdentifier!
//        let orderDate =  transaction.transactionDate!
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let orderDateString = dateFormatter.string(from: orderDate)
        let randomUniqueID = (UUID().uuidString.count > 0) ? UUID().uuidString : randomString(length: 8)
        let parameter: [String: String] = ["subscription_plan_id": getPlanID,
                                           "payment_method_id": "2",
                                           "razorpay_order_id": transaction.transactionIdentifier!, // "order_Fz2tzbaaaQma0e",
                                           "razorpay_payment_id": transaction.transactionIdentifier!, // "pay_Fz2uCXAbvytx5P",
                                           "razorpay_signature": randomUniqueID,
                                           "currency_type": CurrencyType,
                                           "paid_amount": Amount,
                                           "amount": PaidAmount,
                                           "platform": "ios"]
     
           CSCardApiModel.makePaymentApi(
               parentView: self,
               parameters: parameter,
               completionHandler: { responce in
                self.activityView.stopAnimating()
                LibraryAPI.sharedInstance.setUserDefaults(key: "isSubscribed", value: "1")
                LibraryAPI.sharedInstance.setUserDefaults(key: "planName", value: responce.responce.transaction.planName)
                LibraryAPI.sharedInstance.setUserDefaults(key: "planStartDate", value: responce.responce.transaction.transactionTime)
                LibraryAPI.sharedInstance.setUserDefaults(key: "planDuration", value: self.planDuration)
                let controller = menuStoryBoard.instantiateViewController(withIdentifier: "CSTransactionListViewController") as? CSTransactionListViewController
                self.navigationController?.pushViewController(controller!, animated: true)
                   //LibraryAPI.sharedInstance.setUserDefaults(key: "isSubscribed", value: "1")
           })
       }
       func failureResponse() {
        self.showToastMessageTop(message: "Cannot connect to iTunes Store")
        self.activityView.stopAnimating()
        self.navigationController?.popViewController(animated: true)
//           let parameter: [String: String] = ["subscription_plan_id": getPlanID!,
//                                                     "payment_method_id": "2", "status": "Failure"]
//                  CSCardApiModel.makePaymentApi(
//                      parentView: self,
//                      parameters: parameter,
//                      completionHandler: { responce in
//
//                          //LibraryAPI.sharedInstance.setUserDefaults(key: "isSubscribed", value: "1")
//                  })
       }
    @IBAction func subscriptionButtonAction(_ sender: UIButton) {
        products.sort(by: { (p0, p1) -> Bool in
            return p0.price.floatValue < p1.price.floatValue
        })
        
        if LibraryAPI.sharedInstance.getPlanName().isEmpty && !LibraryAPI.sharedInstance.getUserId().isEmpty{
            let sandbox = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
            if sandbox {
                /* remove all unfinished transactions older than 5 minutes */
                for transaction in SKPaymentQueue.default().transactions
                {
                    if transaction.transactionDate == nil || transaction.transactionDate!.timeIntervalSinceNow < -300 {
                        SKPaymentQueue.default().finishTransaction(transaction)
                    }
                }
            }
            
            inAppIdentifiers.store.buyProduct(self.products[sender.tag])
            self.getPlanID = String(self.subscriptionList[sender.tag].planId)
            self.Amount = "\(self.products[sender.tag].price)"
            self.PaidAmount = self.Amount
            self.CurrencyType = String(self.subscriptionList[sender.tag].geoprice.currency)
            self.planDuration = String(self.subscriptionList[sender.tag].planDuration)
        }
        
        if !LibraryAPI.sharedInstance.isUserSubscibed()
        {
            if currentSubscribed.planId == subscriptionList[sender.tag].planId {
                self.showToastMessageTop(message: NSLocalizedString("You have subscribed this plan already",
                                                                    comment: "subscribed"))
                return
            }
            if LibraryAPI.sharedInstance.getUserId().isEmpty {
                self.addLoginCloseIfUserNotLogin(self)
                return
            }
            //self.performSegue(withIdentifier: "PaymentOption", sender: sender.tag)
        }
        else {
            //self.performSegue(withIdentifier: "PaymentOption", sender: sender.tag)
            self.showToastMessageTop(message: NSLocalizedString("You have already been subscribed",comment: "subscribed"))
        }
    }
}
// MARK: - Delegate Method
extension CSSubscriptionViewController: CSCollectionViewDelegate {
    func collectionviewDelegate(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
// MARK: - Api Request
extension CSSubscriptionViewController {
    /// Subscription Listing
    func subscriptionListing() {
        self.subscriptionList.removeAll()
        let parameters = ["page": String(self.currentPage)]
        CSSubscriptionApiModel.showSubscriptionList(
            parentView: self,
            parameters: parameters,
            completionHandler: { response in
                self.subscriptionList += response.requriedResponce.planListArray
                self.currentSubscribed = response.requriedResponce.subscidedPlan
                self.subscriptionDataSource.currentSubscribed = response.requriedResponce.subscidedPlan
                self.subscriptionDataSource.subscriptionList = self.subscriptionList
                if response.requriedResponce.planListArray.count == 0 {
                    self.addChildView(identifier: noDataIdentifier, storyBoard: alertStoryBoard)
                    return
                }
                for index in 0..<response.requriedResponce.planListArray.count {
                    inAppIdentifiers.productIdentifiers.insert(response.requriedResponce.planListArray[index].inAppID)
                }
                inAppIdentifiers.store.requestProducts{ [weak self] success, products in
                    guard let self = self else { return }
                    if success {
                        self.products = products!
                        self.subscriptionDataSource.products = self.products
                        DispatchQueue.main.async {
                            self.subscriptionCollection.reloadData()
                            self.activityView.stopAnimating()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                self.subscriptionHConstraint.constant = self.subscriptionCollection.contentSize.height
                                self.scrollHConstraint.constant = self.subscriptionCollection.contentSize.height + 540 + 150
                            }
                        }
                    }
                }
        })
//        let parameters = ["page": String(self.currentPage)]
//        CSSubscriptionApiModel.showSubscriptionList(
//            parentView: self,
//            parameters: parameters,
//            completionHandler: { response in
//                self.subscriptionList += response.requriedResponce.planListArray
//                self.currentSubscribed = response.requriedResponce.subscidedPlan
//                LibraryAPI.sharedInstance.setUserDefaults(key: "planName",
//                                                          value: response.requriedResponce.subscidedPlan.planName)
//                if !self.currentSubscribed.planName.isEmpty {
//                    LibraryAPI.sharedInstance.setUserDefaults(key: "isSubscribed", value: "1")
//                    if let viewControllers = self.navigationController?.viewControllers {
//                        for contoller in viewControllers where contoller is CSVideoDetailViewController {
//                            let viewController = (contoller as? CSVideoDetailViewController)!
//                            viewController.callApi()
//                            self.navigationController?.popToViewController(viewController, animated: true)
//                        }
//                    }
//                }
//                self.reloadData()
//        })
    }
}
// MARK: - Pull to Refresh
extension CSSubscriptionViewController: PullToRefreshManagerDelegate {
    public func pullToRefreshManagerDidStartLoading(_ controller: PullToRefreshManager,
                                                    onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.callApi()
        }
    }
}
