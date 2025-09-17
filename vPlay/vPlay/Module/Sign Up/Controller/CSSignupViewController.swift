/*
 * CSSignupViewController
 * Signup Controller for Registeration
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import ObjectMapper
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import CryptoKit
import FirebaseAuth
import AuthenticationServices
class CSSignupViewController: CSParentViewController, UIGestureRecognizerDelegate {
    // A variable to scroll the views based on content length
    @IBOutlet weak var signUpScrollview: UIScrollView!
    // A variable to enter the Username
    @IBOutlet weak var nameTextfield: UITextField!
    // A variable to enter the password
    @IBOutlet weak var passwordTextfield: UITextField!
    // A variable to enter the email
    @IBOutlet weak var emailTextfield: UITextField!
    /// The passsowrd visible boolean
    var isPasswordVisible: Bool = false
    /// The passsowrd icon Outlet
    @IBOutlet weak var passwordIconViewOutlet: UIImageView!
    /// Logo Image View
    @IBOutlet weak var logoImageView: UIImageView!
    // content view
    @IBOutlet weak var contentView: UIView!
    // info view
    @IBOutlet weak var infoView: UIView!
    // or View
    @IBOutlet weak var orView: UIView!
    // sign up type
    var registationtype = String()
    /// Login Delegate
    weak var delegate: CSLoginDelegate?
    /// Tab gesture Issue fic
    var tapGesture: UITapGestureRecognizer!
    /// Tab gesture Issue fic
    @IBOutlet var separatorView: [UIView]!
    /// Back button
    @IBOutlet weak var backButton: UIButton!
    /// Apple login View
    @IBOutlet weak var appleLoginView: UIView!
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    var parameters: [String: String]!
    // MARK: - ViewController life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Profile.enableUpdatesOnAccessTokenChange(true)
        self.addDoneButtonOnKeyboard()
        controllerTitle = NSLocalizedString("Sign Up", comment: "Sign Up")
        addLeftBarButton()
        self.addGesture()
        setDarkModeNeeds()
        setAppleSignIn()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Register Notifications
        self.registerKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // UnRegister Notifications
        unregisterKeyboardNotifications()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// Dark Mode is Need
    func setDarkModeNeeds() {
        addGradientBackGround()
        logoImageView.setLogo()
        separatorView.forEach({ $0.backgroundColor = .separatorColor })
        changeViewColor(contentView)
        changeViewColor(infoView)
        changeViewColor(orView)
        passwordIconViewOutlet.tintColor = .contactUsIcon
    }
    /// It shows or hides apple sign in based on apple sign in
    func setAppleSignIn() {
        if #available(iOS 13, *) {
            self.appleLoginView.isHidden = false
        } else {
            self.appleLoginView.isHidden = true
        }
    }
    /// Change color for the view
    func changeViewColor(_ subView: UIView) {
        for current in subView.subviews {
            if current.tag == 100 {
                let label = current as? UILabel
                label?.textColor = .labelTextColor
            } else if current.tag == 105 {
                let currentTextField = current as? UITextField
                currentTextField?.textColor = .textFieldTextColor
                currentTextField?.placeHolderColor = .textFieldPlaceHolderColor
            }
        }
    }
    // MARK: - Add TapGesture
    func addGesture() {
        /// TapGesture Initialization
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        tapGesture.delegate = self
        signUpScrollview.addGestureRecognizer(tapGesture)
    }
    @objc func viewTapped(tgr: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    /// - Parameter sender: The button object
    @IBAction func passwordViewAction(_ sender: Any) {
        if !isPasswordVisible {
            passwordIconViewOutlet.image = #imageLiteral(resourceName: "passwordViewIcon")
        } else {
            passwordIconViewOutlet.image  = #imageLiteral(resourceName: "PasswordHideIcon")
        }
        passwordTextfield.togglePasswordVisibility()
        isPasswordVisible = !isPasswordVisible
    }
    // MARK: - BUtton action
    /// Method Sigin in with Face book button action
    /// MARK:- Add Done button to Keyboard
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,
                                                             width: self.view.frame.size.width,
                                                             height: self.view.frame.size.height/17))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                        target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(
            title: "Done", style: UIBarButtonItem.Style.done, target: self,
            action: #selector(CSSignupViewController.doneButtonAction))
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        //        self.mobilenumTextfield.inputAccessoryView = doneToolbar
    }
    /// done button finction
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
}
// MARK: - Textfield delegates and notification Methods
extension CSSignupViewController: UITextFieldDelegate {
    /// Registering Notifications
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(CSSignupViewController.keyboardDidShow(notification:)),
            name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(CSSignupViewController.keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    /// UnRegistering Notifications
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    /// Scrollview's ContentInset Change on Keyboard show
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        let keyboardSize = keyboardInfo?.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardSize?.height)!, right: 0)
        signUpScrollview.contentInset = contentInsets
        signUpScrollview.scrollIndicatorInsets = contentInsets
    }
    /// Scrollview's ContentInset Change on Keyboard hide
    @objc func keyboardWillHide(notification: NSNotification) {
        signUpScrollview.contentInset = UIEdgeInsets.zero
        signUpScrollview.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    /// Text Field Should Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextfield {
            self.emailTextfield.becomeFirstResponder()
        } else if textField == emailTextfield {
            self.passwordTextfield.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTextfield {
            CSUserValidation.validateAlertMessage(
                title: "Name",
                message: "Your name should contain minimum of 3 characters and maximum of 30 characters",
                textfield: nameTextfield,
                viewController: self)
        } else if textField == passwordTextfield {
            CSUserValidation.validateAlertMessage(
                title: "Password",
                message: "Your password should be maximum of 15 characters",
                textfield: passwordTextfield,
                viewController: self)
        }
    }
}
// MARK: - Presentation style
extension CSSignupViewController {
    // MARK: - Validate of TextField
    /// validate all user Enter text
    func validate() {
        if !CSUserValidation.validateName(textField: nameTextfield,
                                          viewController: self) { return }
        if !CSUserValidation.validateEmail(textField: emailTextfield,
                                           viewController: self) { return }
        if !CSUserValidation.validatePassword(textField: passwordTextfield,
                                              viewController: self) { return }
        // Sign Up Api Call
        self.signUpCall(email: emailTextfield.text!.lowercased(),
                        userName: nameTextfield.text!,
                        password: passwordTextfield.text!)
    }
    // MARK: - Genral Sign up Button action
    /// Method for Sigin up normal button action
    @IBAction func signUpButtonAction(_ sender: Any) {
        // end editing
        self.view.endEditing(true)
        registationtype = "normal"
        validate()
    }
    // MARK: - Social Sign Up Button Action
    /// Method for Sigin up using FaceBook plus
    @IBAction func signUpWithFacebookAction(_ sender: Any) {
        self.view.endEditing(true)
        self.passwordTextfield.text = ""
        self.emailTextfield.text = ""
        let fbLoginManager: LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
            if error == nil {
                let fbloginresult: LoginManagerLoginResult = result!
                if fbloginresult.isCancelled { return }
                if fbloginresult.grantedPermissions.contains("email") {
                    /// Adding Loader
                    self.startLoading()
                    self.getFBUserData()
                } else {
                    self.showToastMessageTop(message: NSLocalizedString("Update a email id",
                                                                        comment: "Email"))
                }
            } else {
                self.showToastMessageTop(message: error?.localizedDescription)
            }
        }
    }
    /// Method for Sigin up using google plus
    @IBAction func signUpwithGooglePlusAction(_ sender: Any) {
        self.passwordTextfield.text = ""
        self.emailTextfield.text = ""
        self.view.endEditing(true)
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().clientID = LibraryAPI.sharedInstance.googleClientId()
        GIDSignIn.sharedInstance().signIn()
    }
    ///   Method Sigin in with Apple Signin button action
    @IBAction func signInWithAppleSignIn(_ sender: Any) {
        self.passwordTextfield.text = ""
        self.emailTextfield.text = ""
        self.registationtype = "fb"
        self.view.endEditing(true)
        if #available(iOS 13.0, *) {
            startSignInWithAppleFlow()
        } else {
            // Fallback on earlier versions
        }
    }
    /// Facebook logout delegate method for getting user details
    func loginButtonDidLogOut(_ loginButton: FBLoginButton!) { }
    // MARK: - Google Delegates
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    ///google sign in responce data
    ///
    /// - Parameter credential: get the credential for google
    func googleLogin(_ credential: GIDGoogleUser) {
        self.startLoading()
        self.registationtype = "google+"
        if !CSUserValidation.validateTextEmail(emailText: credential.profile.email,
                                               viewController: self) { return }
        self.socialLoginInfuction(
            email: credential.profile.email, userName: credential.profile.name,
            profilePicture: credential.profile.imageURL(withDimension: 128 * 128).absoluteString,
            socialLoginId: credential.userID, tokenSocial: credential.authentication.idToken)
        GIDSignIn.sharedInstance().signOut()
    }
    // MARK: - Facebook responce data
    func getFBUserData() {
        let fbLoginManager: LoginManager = LoginManager()
        GraphRequest.init(
            graphPath: "me",
            parameters: ["fields": "first_name, email, last_name, picture.type(large)"])
            .start { ( _, result, error) -> Void in
                if error != nil {
                    // Process error
                    self.stopLoading()
                    self.showToastMessageTop(message: error?.localizedDescription)
                } else {
                    let response = (result as? NSDictionary)!
                    let contentinMutDict: NSMutableDictionary = NSMutableDictionary(dictionary: response)
                    guard let userName = contentinMutDict.value(forKey: "first_name") as? String,
                        let userEmail = contentinMutDict.value(forKey: "email") as? String,
                        let userID: String = contentinMutDict.value(forKey: "id") as? String else {
                            self.stopLoading()
                            self.showToastMessageTop(message:
                                NSLocalizedString("Please update an email in your facebook account",
                                                  comment: "Email"))
                            return
                    }
                    var image = String()
                    if let imageURL = ((contentinMutDict.value(forKey: "picture") as
                        AnyObject).value(forKey: "data") as AnyObject).value(forKey: "url") as? String {
                            image = imageURL
                    }
                    self.registationtype = "fb"
                    let accessToken = AccessToken.current
                    let token = accessToken?.tokenString
                    self.socialLoginInfuction(email: userEmail, userName: userName,
                                              profilePicture: image, socialLoginId: userID,
                                              tokenSocial: token!)
                    fbLoginManager.logOut()
                }
        }
    }
    /// Completion Handler For Both Social And Normal Login
    func completionHandlerForLogin(_ userData: ResponseData) {
        LibraryAPI.sharedInstance.setUserDefaults(key: "EmailID", value: userData.userEmail)
        LibraryAPI.sharedInstance.setUserDefaults(key: "planName", value: userData.subscription.planName)
        LibraryAPI.sharedInstance.setUserDefaults(key: "PhoneNumber", value: userData.userPhone)
        LibraryAPI.sharedInstance.setUserDefaults(key: "Name", value: userData.userName)
        LibraryAPI.sharedInstance.setUserDefaults(key: "imageUrl", value: userData.profilePicture)
        LibraryAPI.sharedInstance.setUserDefaults(key: "Token", value: userData.accessToken)
        LibraryAPI.sharedInstance.setUserDefaults(key: "age", value: String(userData.userAge))
        LibraryAPI.sharedInstance.setUserDefaults(key: "UserID", value: String(userData.userId))
        LibraryAPI.sharedInstance.setUserDefaults(key: "notificationCount", value: "0")
        LibraryAPI.sharedInstance.setUserDefaults(key: "dateOfBirth", value: userData.userDob)
        LibraryAPI.sharedInstance.setUserDefaults(key: "videoId", value: "0")
        LibraryAPI.sharedInstance.setUserDefaults(key: "videoDuration", value: "0")
        LibraryAPI.sharedInstance.setUserBoolDefaults(key: "AutoPlayStatus", value: true)
        LibraryAPI.sharedInstance.setUserBoolDefaults(key: "Notificationstatus", value: true)
        setUserInfoForCrashAnalystics()
        UIApplication.setRootControllerBasedOnLogin()
        // delegate?.loginIsDone(self)
    }
    /// Set Data of User on crash
    func setUserInfoForCrashAnalystics() {
        // Crashlytics.sharedInstance().setUserEmail(LibraryAPI.sharedInstance.getUserEmailId())
        // Crashlytics.sharedInstance().setUserName(LibraryAPI.sharedInstance.getUserName())
        // Crashlytics.sharedInstance().setUserIdentifier(LibraryAPI.sharedInstance.getUserId())
    }
}
// MARK: - API CALL
extension CSSignupViewController {
    /// Social Login Api Call
    func socialLoginInfuction(email: String, userName: String,
                              profilePicture: String, socialLoginId: String, tokenSocial: String) {
        /// parameter set
        let paramet: [String: String] = [
            "email": email, "password": "",
            "acesstype": "mobile", "login_type": self.registationtype,
            "device_type": "IOS", "name": userName,
            "profile_picture": profilePicture, "token": tokenSocial,
            "device_token": LibraryAPI.sharedInstance.getDeviceToken(),
            "social_user_id": socialLoginId
        ]
        CSLoginApiModel.loginRequest(parentView: self, parameters: paramet,
                                     completionHandler: { user in
                                        LibraryAPI.sharedInstance.setUserBoolDefaults(key: "SocialLogin", value: true)
                                        self.completionHandlerForLogin(user.responseRequired)
        })
    }
    /// Sign Up Api Call
    func signUpCall(email: String, userName: String, password: String) {
        /// parameter set
        let paramet: [String: String] = [
            "acesstype": "mobile",
            "login_type": "normal",
            "email": email,
            "password": password,
            "name": userName,
            "password_confirmation": password,
            "device_token": LibraryAPI.sharedInstance.getDeviceToken()
        ]
        CSLoginApiModel.signUpRequest(parentView: self, parameters: paramet,
                                      completionHandler: { user in
                                        
//                                        self.showToastMessageTop(message: NSLocalizedString("Welcome to Vplay...",
//                                                                                            comment: "Common"))
                                        self.showToastMessageTop(message: user.message)
                                        self.navigationController?.popViewController(animated: true)
                                    
//                                        LibraryAPI.sharedInstance.setUserBoolDefaults(key: "SocialLogin", value: false)
//                                        self.completionHandlerForLogin(user.responseRequired)
        })
    }
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }

    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}

@available(iOS 13.0, *)
extension CSSignupViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        if appleIDCredential.email != nil {
           LibraryAPI.sharedInstance.setUserDefaults(key: "appleID", value: appleIDCredential.email ?? "")
         }
        guard let nonce = currentNonce else {
          fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
          print("Unable to fetch identity token")
          return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
          return
        }
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if (error == nil) {
                if Auth.auth().currentUser?.displayName != nil {
                    self.parameters = ["email": (authResult?.user.email ?? LibraryAPI.sharedInstance.getAppleID()) as String,
                                       "password": "", "acesstype": "mobile", "device_type": "IOS",
                                       "login_type": self.registationtype,
                                       "social_user_id": (authResult?.user.uid ?? appleIDCredential.user) as String,
                                       "name": (Auth.auth().currentUser?.displayName ?? "Heeroz-user") as String,
                                       "profile_picture": "",
                                       "token": (authResult?.user.refreshToken ?? idTokenString) as String,
                                       "device_token": LibraryAPI.sharedInstance.getDeviceToken()
                    ]
                } else {
                    self.parameters = ["email": (authResult?.user.email ?? LibraryAPI.sharedInstance.getAppleID()) as String,
                                       "password": "", "acesstype": "mobile", "device_type": "IOS",
                                       "login_type": self.registationtype,
                                       "social_user_id": (authResult?.user.uid ?? appleIDCredential.user) as String,
                                       "name": "Heeroz-user",
                                       "profile_picture": "",
                                       "token": (authResult?.user.refreshToken ?? idTokenString) as String,
                                       "device_token": LibraryAPI.sharedInstance.getDeviceToken()
                    ]
                }
                CSLoginApiModel.loginRequest(parentView: self,
                                             parameters: self.parameters,
                                             completionHandler: { user in
                                                LibraryAPI.sharedInstance.setUserBoolDefaults(key: "SocialLogin", value: true)
                                                self.completionHandlerForLogin(user.responseRequired)
                })
                return
          }
          // User is signed in to Firebase with Apple.
          // ...
        }
      }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      // Handle error.
      print("Sign in with Apple errored: \(error)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
}
