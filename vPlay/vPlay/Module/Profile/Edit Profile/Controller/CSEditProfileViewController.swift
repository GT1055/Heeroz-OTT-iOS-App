/*
 * CSEditProfileViewController
 * This controller is used to display the edit profile view
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import ObjectMapper
import Alamofire
import AVFoundation
import Photos
protocol EditImage: class {
    func editImage(_ editImage: UIImage)
}
class CSEditProfileViewController: CSParentViewController, UINavigationControllerDelegate,
UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {
    /// Outlets
    /// An Outlet for user Profile Image
    @IBOutlet var userProfileImage: UIImageView!
    /// An Outlet for Edit profile image
    @IBOutlet var editScrollView: UIScrollView!
    /// An Outlet for name text field
    @IBOutlet var nameTextfield: UITextField!
    /// An Outlet for mobile text field
    @IBOutlet var mobileTextfield: CSNumberTextField!
    /// An Outlet for country code text field
    @IBOutlet var countryCodeLabel: UILabel!
    /// An Outlet for country code Image
    @IBOutlet var countryImage: UIImageView!
    /// An Outlet for email text field
    @IBOutlet var emailTextfield: UITextField!
    /// An Outlet for update button
    @IBOutlet var updateButton: UIButton!
    /// An Outlet for age text field
    @IBOutlet var ageTextfield: UITextField!
    /// Content view
    @IBOutlet weak var contentView: UIView!
    /// drop down arrow image
    @IBOutlet weak var dropDownArrowImage: UIImageView!
    /// Separator Color
    @IBOutlet var separator: [UIView]!
    ///picker Declaration
    let picker = UIImagePickerController()
    /// Image throught Cammera is True or False
    var isImageSelected = false
    /// is Edited
    var isEdited = false
    // MARK: - ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerTitle = NSLocalizedString("My Profile", comment: "menu")
        setupNavigation()
        setDarkModeNeeds()
        self.picker.delegate = self
        // Add Gesture Recogoniser
        self.addTapGesture()
        self.callApi()
    }
    override func callApi() {
        if !UIApplication.isUserLoginInApplication() {
            self.addLoginCloseIfUserNotLogin(self)
            return
        }
        self.bindUserData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.registerKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.unregisterKeyboardNotifications()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CSDatePickerViewController {
            let controller = segue.destination as? CSDatePickerViewController
            controller?.delegate = self
            controller?.previousDate = self.ageTextfield.text!
        } else if segue.destination is CSCountryCodeListViewController {
            let controller = segue.destination as? CSCountryCodeListViewController
            controller?.countryDelegate = self
        }
    }
    /// To set basic dark mode needs
    func setDarkModeNeeds() {
        separator.forEach({$0.backgroundColor = .separatorColor})
        for displayView in contentView.subviews {
            if displayView.tag == 105 {
                let currentText = displayView as? UITextField
                if currentText == emailTextfield {
                    currentText?.textColor = .disabledTextFieldTextColor
                    currentText?.placeHolderColor = .textFieldPlaceHolderColor
                } else {
                    currentText?.textColor = .textFieldTextColor
                    currentText?.placeHolderColor = .textFieldPlaceHolderColor
                }
            } else if displayView.tag == 100 {
                let displayLabel = displayView as? UILabel
                displayLabel?.textColor = .labelTextColor
            }
        }
        dropDownArrowImage.tintColor = UIColor.invertColor(true)
    }
}
// MARK: - Private Action Methods
extension CSEditProfileViewController {
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        self.navigationItem.setLeftBarButtonItems([self.backBarButton(),
                                                   self.setHeaderTitle(controllerTitle)], animated: true)
    }
    /// Back Button
    func backBarButton() -> UIBarButtonItem {
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "header"),
                                                                    for: .default)
        let btn1 = UIButton(type: .custom)
        btn1.setImage(#imageLiteral(resourceName: "Back-arrow"), for: .normal)
        btn1.tintColor = UIColor.iconColor()
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(self.backAction(_ :)), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        return item1
    }
    // Bind User Data
    func bindData(userInfo data: Userprofile) {
        nameTextfield.text = data.profiName
        mobileTextfield.text = data.profiPhone
        emailTextfield.text = data.profiEmail
        ageTextfield.text = data.profiDob
        userProfileImage.setProfileImageWithUrl(data.profiImage)
        isImageSelected = false
    }
    /// tap gesture add to a view
    func addTapGesture() {
        /// TapGesture Initialization
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        tapGesture.delegate = self
        editScrollView.addGestureRecognizer(tapGesture)
    }
    /// Action to open Gallery
    func openImageGallery() {
        DispatchQueue.main.async {
            self.picker.delegate = self
            self.picker.allowsEditing = true
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }
    }
    /// open camera on chose camera action
    func openCamera() {
        DispatchQueue.main.async {
            self.picker.delegate = self
            self.picker.allowsEditing = true
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion: nil)
        }
    }
    // Handle api Responce
    func handleApiResponce(_ userInfo: ResponseData) {
        self.isEdited = false
        LibraryAPI.sharedInstance.setUserDefaults(key: "Name", value: userInfo.userName)
        LibraryAPI.sharedInstance.setUserDefaults(key: "imageUrl", value: userInfo.profilePicture)
        LibraryAPI.sharedInstance.setUserDefaults(key: "Token", value: userInfo.accessToken)
        LibraryAPI.sharedInstance.setUserDefaults(key: "UserID", value: userInfo.accessToken)
        LibraryAPI.sharedInstance.setUserDefaults(key: "EmailID", value: userInfo.userEmail)
        LibraryAPI.sharedInstance.setUserDefaults(key: "PhoneNumber", value: userInfo.userPhone)
        LibraryAPI.sharedInstance.setUserDefaults(key: "dateOfBirth", value: userInfo.userDob)
    }
    /// Check Camera
    func checkCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authStatus == .authorized {
            self.openCamera()
        } else if authStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if granted { self.openCamera() }
            })
        } else {
            alertToEncourageCameraAccessInitially()
        }
    }
    /// Check Photos
    func checkPhotos() {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .authorized {
            self.openImageGallery()
        } else if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized { self.openImageGallery() }
            })
        } else {
            self.alertToEncourageGalleryAccessInitially()
        }
    }
    /// Check For Alert
    func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(
            title: NSLocalizedString("Camera Permission", comment: "Permission"),
            message: NSLocalizedString("Camera access required for capturing photos!", comment: "Permission"),
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Permission"),
                                      style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Allow Camera", comment: "Permission"),
                                      style: .cancel, handler: { _ in
                                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                                                  options: [:], completionHandler: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    /// Check For Alert
    func alertToEncourageGalleryAccessInitially() {
        let alert = UIAlertController(
            title: NSLocalizedString("Gallery Permission", comment: "Permission"),
            message: NSLocalizedString("Gallery access required for selecting photos!", comment: "Permission"),
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Permission"),
                                      style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Allow Gallery", comment: "Permission"), style: .cancel, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                      options: [:], completionHandler: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    /// Alert View
    func showEditAlert() {
        let alertController = UIAlertController(
            title: NSLocalizedString("Update", comment: "Permission"),
            message: NSLocalizedString("Do you want to save changes?", comment: "Permission"),
            preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("Ok", comment: "Permission"),
            style: UIAlertAction.Style.cancel,
            handler: { _ in self.updateUserDetails(UIButton()) }))
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("Cancel", comment: "Permission"),
            style: UIAlertAction.Style.default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
        }))
        present(alertController, animated: true, completion: nil)
    }
}
// MARK: - Country Flag
extension CSEditProfileViewController: CountrySelectedDelegate {
    func countrySelected(countrySelected country: CSCountryList) {
        self.countryCodeLabel.text = country.countryDialCode
        self.countryImage.image = UIImage.init(named: country.countryCode + ".png")
    }
}
// MARK: - Button Action Methods
extension CSEditProfileViewController {
    /// udate profile
    /// - Parameter sender: Any
    @IBAction func updateUserDetails(_ sender: Any) {
        self.view.endEditing(true)
        if !CSUserValidation.validateName(textField: nameTextfield,
                                          viewController: self) { return }
        if !CSUserValidation.validateEmail(textField: emailTextfield,
                                           viewController: self) { return }
        if !CSUserValidation.validDailCode(label: countryCodeLabel,
                                           viewController: self) { return }
        if !CSUserValidation.validatePhone(textField: mobileTextfield,
                                           viewController: self) { return }
        if !CSUserValidation.validateAge(textField: ageTextfield,
                                         viewController: self) { return }
        if isImageSelected {
            self.saveAndUploadImageProfileInfo()
        } else {
            self.saveProfileInfo()
        }
    }
    /// camera button action
    /// - Parameter sender: Any
    @IBAction func cameraButtonAction(_ sender: Any) {
        self.isEdited = true
        let alert = UIAlertController(title: "",
                                      message: NSLocalizedString("What Would you like to do",
                                                                 comment: "Profile"),
                                      preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("TakePhoto", comment: "Profile"),
                                      style: UIAlertAction.Style.default, handler: { _ in
                                        self.checkCamera()
                                        alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Choose from Gallery", comment: "Profile"),
                                      style: UIAlertAction.Style.default, handler: { _ in
                                        self.checkPhotos()
                                        alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"),
                                      style: .cancel, handler: { _ in
                                        alert.dismiss(animated: true, completion: nil)
        }))
        if let popoverPresentationController = alert.popoverPresentationController {
            if let currentButton = sender as? UIButton {
                popoverPresentationController.sourceView = currentButton
                popoverPresentationController.sourceRect = currentButton.bounds
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    /// tap gesture handleing
    @objc func viewTapped(tgr: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    /// Country Flag
    @IBAction func selectCountryFlag(_ sender: UIButton) {
        self.isEdited = true
        self.performSegue(withIdentifier: "countryFlag", sender: self)
    }
    /// back Action
    @IBAction func backAction(_ sender: UIButton) {
        if self.isEdited {
            self.showEditAlert()
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: - Textfield Delegate
extension CSEditProfileViewController: UITextFieldDelegate {
    // Textfield delegates and notification Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextfield {
            self.mobileTextfield.becomeFirstResponder()
        } else if textField == mobileTextfield {
            self.mobileTextfield.resignFirstResponder()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isEdited = true
        if textField == nameTextfield {
            CSUserValidation.validateAlertMessage(
                title: "Name",
                message: "Your name should contain minimum of 3 characters and maximum of 30 characters",
                textfield: textField,
                viewController: self)
        } else if textField == mobileTextfield {
            CSUserValidation.validateAlertMessage(
                title: "Mobile Number",
                message: "Your mobile number should be maximum of 15 characters",
                textfield: textField,
                viewController: self)
        }
    }
}
// MARK: - Key board Method
extension CSEditProfileViewController {
    // register Notification of Keyboard
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(CSEditProfileViewController.keyboardDidShow(notification:)),
            name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(CSEditProfileViewController.keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // Unregister Notification of Keyboard
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    /// Scrollview's ContentInset Change on Keyboard show
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let keyboardSize = keyboardInfo?.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardSize?.height)!, right: 0)
        editScrollView.contentInset = contentInsets
        editScrollView.scrollIndicatorInsets = contentInsets
    }
    /// Scrollview's ContentInset Change on Keyboard hide
    @objc func keyboardWillHide(notification: NSNotification) {
        editScrollView.contentInset = UIEdgeInsets.zero
        editScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}
